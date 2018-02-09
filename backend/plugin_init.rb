# create system request user and group
ArchivesSpaceService.loaded_hook do
  Log.info "\n\n\n~~~ ASPACE REQUESTS PLUGIN ENABLED ~~~\n\n\n"

  unless AppConfig.has_key? :request_user_secret
    AppConfig[:request_user_secret] = SecureRandom.hex
  end

  ArchivesSpaceService.create_hidden_system_user(
    "request_user", "Request System User", AppConfig[:request_user_secret]
  )

  DBAuth.set_password("request_user", AppConfig[:request_user_secret])

  ArchivesSpaceService.create_group(
    "request_group", "Request System Group", ["request_user"], ["update_event_record"]
  )
end
