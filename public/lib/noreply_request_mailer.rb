ArchivesSpacePublic::Application.config.after_initialize do
  RequestMailer
  class RequestMailer < ApplicationMailer

    # AppConfig[:pui_request_email_fallback_from_address] = "no-reply@archive.edu"
    def request_received_email(request)
      user_email = request.user_email
      @request   = request
      mail(from: AppConfig[:pui_request_email_fallback_from_address],
           to: user_email,
           reply_to: email_address(@request),
           subject: I18n.t('request.email.subject', :title => request.title))
    end

    def request_received_staff_email(request)
      @request = request

      mail(from: AppConfig[:pui_request_email_fallback_from_address],
           to: email_address(@request, :to),
           subject: I18n.t('request.email.subject', :title => request.title))
    end

  end
end
