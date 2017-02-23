require 'db/migrations/utils'
# src: common/db/migrations/XXX_event_requests.rb

Sequel.migration do

  up do
    # add top container foreign key to event relationships table
    alter_table(:event_link_rlshp) do
      add_column(:top_container_id, :integer)
      add_foreign_key([:top_container_id], :top_container, key: :id)
    end

    # add request enums: locales in common =( [so we'll abuse: frontend/locales/enums]
    enums = {
      "event_event_type" => ["request"],
      "event_outcome" => ["cancelled", "fulfilled", "pending"],
      "linked_agent_event_roles" => ["requester"],
      "linked_event_archival_record_roles" => ["context", "requested"],
    }

    enums.each do |enumeration_name, values|
      enumeration_id = self[:enumeration].filter(:name => enumeration_name).select(:id)
      values.each do |value|
        ev = self[:enumeration_value].filter(
          enumeration_id: enumeration_id, value: value
        ).select(:id).all

        if ev.length == 0
          position = self[:enumeration_value].filter(enumeration_id: enumeration_id).max(:position) + 1
          self[:enumeration_value].insert(
            :enumeration_id => enumeration_id, :value => value, position: position, :readonly => 1
          )
        end
      end
    end
  end

end