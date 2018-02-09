# aspace-requests

Implements (currently by overriding) public interface requests functionality.

## Summary

- Handle requests for materials as event records within ArchivesSpace.
- Upon creating a request the requester is given a reference id.
- The requester is given a chance to cancel the request (via a link).
- An agent record is created for the requester with email for correspondence.
- Requests can be searched for, viewed and processed by staff.
- No emails =)

## TODO

- Add lookup request in public ui by reference id?
- Add requests report to summarize requests scoped by date range.
- Privacy option (scheduled anonymization or purge of request events not "pending")

## Setup

```ruby
AppConfig[:plugins] << "aspace-requests"
AppConfig[:pui_page_actions_request] = true

# optional: specify a regex to validate the requester email address
# i.e. if the email address matches the pattern the request is allowed.
# this is a spam mitigation strategy only. a simple example:
AppConfig[:requester_email_validator] = /\A([\w+\-].?)+@archive.somewhere.edu$/i
```

## EXAMPLES

Create a request:

![#](examples/requests1.png)

Request created:

![#](examples/requests2.png)

Can be cancelled:

![#](examples/requests3.png)

Browsing events:

![#](examples/requests4.png)

Event request record showing links:

![#](examples/requests5.png)

Instance view of events:

![#](examples/requests6.png)

Agent view of events:

![#](examples/requests7.png)

## Backend endpoints

```
curl -H "X-ArchivesSpace-Session: $TOKEN" \
  -H "Content-Type: application/json" \
  -X POST \
  -d @request.json \
  http://localhost:4567/plugins/aspace_requests/repositories/2/requests

# DELETE is really an update as it sets the event to "cancelled"
# this is like "deleting" the request, but not the event. This ok?
curl -H "X-ArchivesSpace-Session: $TOKEN" \
  -X DELETE \
  http://localhost:4567/plugins/aspace_requests/repositories/2/requests/5?refid=123
```

## Compatibility

- v2.3.0

---
