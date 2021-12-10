# aspace-requests

Extends requests functionality by creating request records in ArchivesSpace.

## Summary

- Handle requests for materials as event records within ArchivesSpace.
- Upon creating a request the requester is given a reference id.
- The requester is given a chance to cancel the request (via a link).
- An agent record is created for the requester with links to their requests.
- Requests can be searched for, viewed and processed by staff.
- Emails are optional =)

## TODO

- Add lookup request in public ui by reference id?
- Add requests report to summarize requests scoped by date range.
- Privacy option (scheduled anonymization or purge of request events not "pending")
- Cancel email confirmation?

## Setup

```ruby
AppConfig[:plugins] << "aspace-requests"
AppConfig[:request_user_secret] = "SOMETHING_SECRET"
AppConfig[:pui_page_actions_request] = true

# optional: specify a regex to validate the requester email address
# i.e. if the email address matches the pattern the request is allowed.
# this is a spam mitigation strategy only. a simple example:
AppConfig[:requester_email_validator] = /\A([\w+\-].?)+@archive.somewhere.edu$/i

# optional: use with email, if use_repo_email is set then the repository must
# have an email address for the request button to show in the public interface
AppConfig[:pui_email_enabled] = true
AppConfig[:pui_request_use_repo_email] = true
# ... other email settings (c.f. documentation)
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

## Test config

```ruby
AppConfig[:plugins] << "aspace-requests"
AppConfig[:request_user_secret] = "SOMETHING_SECRET"
AppConfig[:pui_page_actions_request] = true
AppConfig[:pui_email_enabled] = false
AppConfig[:pui_request_use_repo_email] = false
AppConfig[:pui_email_override] = 'testing@example.com'
AppConfig[:pui_request_email_fallback_to_address] = 'testing@example.com'
AppConfig[:pui_request_email_fallback_from_address] = 'testing@example.com'
AppConfig[:pui_email_perform_deliveries] = false
```

## Compatibility

- v2.3.0+

---
