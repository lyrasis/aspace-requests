# src: backend/app/model/event.rb
class Event < Sequel::Model(:event)

  # Added TopContainer to :contains_references_to_types
  # (that's the only change here)
  # TODO: look into less copy-paste way of doing this
  define_relationship(
    :name => :event_link,
    :json_property => 'linked_records',
    :contains_references_to_types => proc {
      [
        Accession,
        Resource,
        ArchivalObject,
        DigitalObject,
        AgentPerson,
        AgentCorporateEntity,
        AgentFamily,
        AgentSoftware,
        DigitalObjectComponent,
        TopContainer,
      ]
    },
    :class_callback => proc { |clz|
      clz.instance_eval do
        include DynamicEnums
        uses_enums({
          :property => 'role',
          :uses_enum => ['linked_event_archival_record_roles'],
        })
      end
    }
  )

end