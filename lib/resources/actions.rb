module Resources
  module Actions
    extend ActiveSupport::Concern

      included do
        helper_method :resources, :resource, :resources_search

        if self.resource_configuration.resource_method_name
          self.class_eval <<-RUBY

            alias_method :#{self.resource_configuration.resources_method_name.to_s}, :resources
            alias_method :#{self.resource_configuration.resource_method_name.to_s}, :resource
            alias_method :#{self.resource_configuration.resources_method_name.to_s}_search, :resources_search
            helper_method :#{self.resource_configuration.resources_method_name.to_s}, :#{self.resource_configuration.resource_method_name.to_s}, :#{self.resource_configuration.resources_method_name.to_s}_search
          RUBY
        end
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



      protected

      def resource_manager
        @resource_manager ||= Resources::Manager.new(self, request)
      end




      def member_route?
        params[:id].present?
      end
  end
end
