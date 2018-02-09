class ArchivesSpaceRequestClient
  # minimal api client for requests

  def initialize(username:, password:)
    # TODO
    # login!
  end

  def cancel_request(path, params_string)
    do_delete path, params_string if is_request_user?
  end

  def create_request(path, payload)
    do_post path, payload if is_request_user?
  end

  private

  def do_delete(path, params_string = nil)
    request = Net::HTTP::Delete.new(build_url(path))
    request.body = params_string if params_string
    do_parse_json_request request
  end

  def do_post(path, payload)
    request      = Net::HTTP::Post.new(build_url(path))
    request.body = payload
    do_parse_json_request request
  end

  def do_parse_json_request(request)
    response = do_http_request(request)
    if response.code != '200'
      raise RequestFailedException.new("#{response.code}: #{response.body}")
    end

    JSON.parse(response.body)
  end

  def is_request_user?
    @username == "request_user"
  end

end
