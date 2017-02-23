# src: common/schemas/event.rb
# added (no ui): "refid" => {"type" => "string"},
# added: {"type" => "JSONModel(:top_container) uri"}
{
  "refid" => {"type" => "string"},
  "linked_records" => {
    "type" => "array",
    "ifmissing" => "error",
    "minItems" => 1,
    "items" => {
      "type" => "object",
      "subtype" => "ref",
      "properties" => {
        "role" => {
          "type" => "string",
          "dynamic_enum" => "linked_event_archival_record_roles",
          "ifmissing" => "error",
        },
        "ref" => {
          "type" => [{"type" => "JSONModel(:agent_person) uri"},
                     {"type" => "JSONModel(:agent_family) uri"},
                     {"type" => "JSONModel(:agent_corporate_entity) uri"},
                     {"type" => "JSONModel(:agent_software) uri"},
                     {"type" => "JSONModel(:accession) uri"},
                     {"type" => "JSONModel(:resource) uri"},
                     {"type" => "JSONModel(:digital_object) uri"},
                     {"type" => "JSONModel(:archival_object) uri"},
                     {"type" => "JSONModel(:digital_object_component) uri"},
                     {"type" => "JSONModel(:top_container) uri"}],
          "ifmissing" => "error"
        },
        "_resolved" => {
          "type" => "object",
          "readonly" => "true"
        }
      }
    }
  },
}