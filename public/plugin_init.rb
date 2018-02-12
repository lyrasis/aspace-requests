require_relative "lib/archivesspace_request_client"
require_relative "lib/noreply_request_mailer"
Plugins::extend_aspace_routes(File.join(File.dirname(__FILE__), "routes.rb"))

unless AppConfig.has_key? :requester_email_validator
  AppConfig[:requester_email_validator] = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
end
