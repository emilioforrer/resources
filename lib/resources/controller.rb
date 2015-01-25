module Resources
  module Controller
    extend ActiveSupport::Concern
          
      included do
      end

      module ClassMethods

        def resource_for name = nil, *args
          options = Resources::Config.to_hash.deep_merge(args.extract_options!)
          @resource_configuration = Resources::Configuration.new(options)
          @resource_configuration.resource_class_name = name
          include Resources::Actions
          include Resources::RestActions if @resource_configuration.rest_actions
        end

        def resource_configuration
          @resource_configuration
        end

      end

  end
end
