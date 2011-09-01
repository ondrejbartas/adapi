module Adapi

  # http://code.google.com/apis/adwords/docs/reference/latest/CampaignTargetService.html
  #
  class CampaignTarget < Api

    def initialize(params = {})
      params[:service_name] = :CampaignTargetService
      super(params)
    end

    # FIXME params should be the same as in other services, for example ad_group 
    # 
    def self.create(params = {})
      campaign_target_service = CampaignTarget.new

      raise "No Campaign ID" unless params[:campaign_id]
      campaign_id = params[:campaign_id].to_i

      # transform our own high-level target parameters to google low-level
      # target parameters
      operations = []

      params[:targets].each_pair do |targetting_type, targetting_settings|
        operations << { :operator => 'SET',
          :operand => {
            :xsi_type => "#{targetting_type.to_s.capitalize}TargetList",
            :campaign_id => campaign_id,
            :targets => self.create_targets(targetting_type, targetting_settings)
          }
        }
      end

      response = campaign_target_service.service.mutate(operations)

      targets = response[:value] || []
      targets.each do |target|
        puts "Campaign target of type #{target[:"@xsi:type"]} for campaign id " +
          "#{target[:campaign_id]} was set."
      end

      targets
    end
  
    def self.find(params = {})
      campaign_target_service = CampaignTarget.new

      selector = {} # select all campaign targets by default
      selector[:campaign_ids] = params[:campaign_ids] if params[:campaign_ids]
  
      response = campaign_target_service.service.get(selector)

      targets = nil
      if response and response[:entries]
        targets = response[:entries]
        targets.each do |target|
          p target
        end
      else
        puts "No campaign targets found."
      end

      targets
    end

    # transform our own high-level target parameters to google low-level
    #
    def self.create_targets(target_type, target_data)
      case target_type
        when :language
          target_data.map { |language| { :language_code => language } }       
          # example: ['cz','sk'] => [{:language_code => 'cz'}, {:language_code => 'sk'}]
        when :geo
          geo_targets = []
          target_data.each_pair do |geo_type, geo_values|
            geo_values.each do |geo_value|
              geo_targets << {
                :xsi_type => "#{geo_type.to_s.capitalize}Target",
                :excluded => false,
                "#{geo_type}_code".to_sym => geo_value
              }
            end
          end
          geo_targets
        else nil
      end
    end

  end
end
