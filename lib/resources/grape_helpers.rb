module Resources
  module GrapeHelpers

    def resource_for name = nil, *args
      options = Resources::Config.to_hash.deep_merge(args.extract_options!)
      @resource_configuration = Resources::Configuration.new(options)
      @resource_configuration.resource_class_name = name
    end

    def resource_configuration
      @resource_configuration
    end

    def resources_search
      @resources_search ||= resource_manager.resources_search
    end

    def resources
      @resources ||= resource_manager.resources
    end

    def resource
      @resource ||= resource_manager.resource
    end

    def resource_manager
      @resource_manager ||= Resources::Manager.new(self, request)
    end

    def resource_saved?
      @resource_saved
    end

    def save_resource &block
      resource.assign_attributes(resource_manager.params_resource)
      @resource_saved = resource.save
      block_given? ? block.call(resource) : resource
    end

    def destroy_resource &block
      @destroy_resource = resource.destroy
      block_given? ? block.call(resource) : resource
    end

  end
end
