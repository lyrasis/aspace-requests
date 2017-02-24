class ArchivesSpaceService < Sinatra::Base

  # Add dedicated request endpoints so we don't have to handle too much
  # work on the public side.

  # TODO: create system request_user with update_event_record permission
  # [proxy user for public interface based requests]
  Endpoint.post('/plugins/aspace_requests/repositories/:repo_id/requests')
    .description("Create a request Event")
    .params(["request", String, "The request payload", :body => true],
            ["repo_id", :repo_id])
    .permissions([])
    .returns([200, "(:event)"],
             [400, :error]) \
  do
    request = JSON.parse(params[:request])
    agent   = Event.find_agent_by_email(request["user_email"])
    agent   = Event.create_requester(request["user_name"], request["user_email"]) unless agent
    request["requester_uri"] = agent.uri

    event = Event.create_request(request) # check request payload
    json_response(Event.to_jsonmodel(event))
  end

  Endpoint.delete('/plugins/aspace_requests/repositories/:repo_id/requests/:id')
    .description("Cancel a request Event")
    .params(["refid", String, :refid],
            ["id", Integer, :id],
            ["repo_id", :repo_id])
    .permissions([])
    .returns([200, "(:event)"]) \
  do
    refid = params[:refid]
    event = Event.find_by_refid(refid)
    raise NotFoundException.new("Request wasn't found with refid: #{refid}") unless event

    obj       = Event.to_jsonmodel(event)
    requested = obj["event_type"] == "request"
    raise BadParamsException.new("Not a valid request event for refid: #{refid}") unless requested
    obj["outcome"] = "cancelled"
    event.update_from_json(JSONModel(:event).from_hash(obj.to_hash))
    json_response(Event.to_jsonmodel(event))
  end

end