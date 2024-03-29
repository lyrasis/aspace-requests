module Requests

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def create_request(request)
      request_date, request_date_type = nil
      begin
        request_date      = DateTime.parse(request["date"]).to_s
        request_date_type = "begin"
      rescue StandardError
        request_date      = "Invalid or no arrival date was provided"
        request_date_type = "expression"
      end

      event = {
        "refid"        => generate_refid,
        "event_type"   => "request",
        "outcome"      => "pending",
        "outcome_note" => request["note"],
        "date" => {
          "date_type"       => "single",
          "label"           => "usage",
          request_date_type => request_date
        },
        "linked_agents" => [{
          "role" => "requester",
          "ref"  => request["requester_uri"]
        }]
      }
      linked_records = [{ "role" => "context", "ref"  => request["request_uri"] }]
      if request["top_container_url"]
        request["top_container_url"].each do |tc_url|
          linked_records << { "role" => "requested", "ref" => tc_url }
        end
      end
      event["linked_records"] = linked_records

      Event.create_from_json(JSONModel(:event).from_hash(event), :system_generated => true)
    end

    def create_requester(name, email)
      created_agent = nil

      agent = JSONModel(:agent_person).from_hash(
        :publish => false,
        :names => [{
          :primary_name            => name,
          :source                  => 'local',
          :rules                   => 'local',
          :name_order              => 'direct',
          :sort_name_auto_generate => true
        }],
        :agent_contacts => [{
          :name  => name,
          :email => email,
        }]
      )

      CrudHelpers.with_record_conflict_reporting(AgentPerson, agent) do
        created_agent = AgentPerson.create_from_json(agent, :system_generated => true)
      end

      created_agent
    end

    def find_by_refid(refid)
      Event[refid: refid]
    end

    def find_agent_by_email(email_address)
      contact = AgentContact[email: email_address] # TODO: duplicate email?
      contact ? AgentPerson.get_or_die(contact.agent_person_id) : nil
    end

    def generate_refid
      refid = Time.now.to_i.to_s
      while Event[refid: refid]
        generate_refid
      end
      refid
    end

  end

end
