require_relative "lib/archivesspace_request_client"
Plugins::extend_aspace_routes(File.join(File.dirname(__FILE__), "routes.rb"))
