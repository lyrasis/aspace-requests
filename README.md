# aspace-requests

Implements public interface requests functionality using events.

## Summary

- Handle requests for materials as event records within ArchivesSpace.
- Upon creating a request the requester is given a reference id.
- Requests can be searched for, viewed and processed by staff.
- A requests report is available to see requests within a date range.
- No emails =)

## Backend endpoints

```
curl -H "X-ArchivesSpace-Session: $TOKEN" \
  -H "Content-Type: application/json" \
  -X POST \
  -d @request.json \
  http://localhost:4567/plugins/aspace_requests/repositories/2/requests

curl -H "X-ArchivesSpace-Session: $TOKEN" \
  -X DELETE \
  http://localhost:4567/plugins/aspace_requests/repositories/2/requests/5?refid=123
```

## Compatibility

- v1.5.?

---