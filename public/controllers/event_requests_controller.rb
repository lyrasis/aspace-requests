ArchivesSpacePublic::Application.config.after_initialize do
  RequestsController
  class RequestsController < ApplicationController

    include PrefixHelper

    # cancel a request by refid
    def cancel_request
      path   = backend_cancel_path(cancel_params[:uri])
      client = get_request_client # logs in the request user
      event  = client.cancel_request(path, "refid=#{cancel_params[:refid]}") rescue nil

      if event
        flash[:success] = I18n.t("request.cancellation_success")
      else
        flash[:error] = I18n.t("request.cancellation_failure")
      end
      redirect_back(fallback_location: cancel_params[:context]) and return
    end

    # send a request, retain RequestItem but no emails =)
    def make_request
      @request = RequestItem.new(params)
      errs = @request.validate

      # let's try and avoid spam
      if params.fetch("comment") and !params["comment"].empty?
        errs << I18n.t('request.comment_not_appreciated')
      end

      if @request.user_email !~ AppConfig[:requester_email_validator]
        errs << I18n.t('request.email_invalid')
      end

      if errs.blank?
        path   = backend_request_path(@request.request_uri)
        client = get_request_client # logs in the request user
        event  = client.create_request(path, @request.to_json) rescue nil

        if event
          if AppConfig[:pui_email_enabled]
            begin
              # go ahead and send the email
              RequestMailer.request_received_staff_email(@request).deliver
              RequestMailer.request_received_email(@request).deliver
            rescue Exception => ex
              # for now just log email delivery errors in this context
              $stderr.puts ex.message
            end
          end

          flash[:notice] = I18n.t(
            'request.submitted_html',
            refid: event["refid"],
            cancel: cancel_link(event["uri"], event["refid"], request[:request_uri])
          )
          redirect_to params.fetch('base_url', request[:request_uri])
        else
          flash[:error] = I18n.t('request.failed')
          redirect_back(fallback_location: request[:request_uri]) and return
        end
      else
        flash[:error] = errs
        redirect_back(fallback_location: request[:request_uri]) and return
      end
    end

    private

    def backend_cancel_path(event_uri)
      repo_id = event_uri.split("/")[2]
      id      = event_uri.split("/")[-1]
      app_prefix("/plugins/aspace_requests/repositories/#{repo_id}/requests/#{id}")
    end

    def backend_request_path(request_uri)
      repo_id = request_uri.split("/")[2]
      app_prefix("/plugins/aspace_requests/repositories/#{repo_id}/requests")
    end

    def cancel_link(uri, refid, request_uri)
      view_context.link_to(
        "cancel",
        :controller => "requests",
        :action     => "cancel_request",
        :uri        => uri,
        :refid      => refid,
        :context    => request_uri
      )
    end

    def cancel_params
      params.permit(:uri, :refid, :context)
    end

    def get_request_client
      ArchivesSpaceRequestClient.new(
        username: "request_user",
        password: AppConfig[:request_user_secret],
      )
    end

  end
end
