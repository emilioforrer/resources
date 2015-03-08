module Resources
  module RestActions
    extend ActiveSupport::Concern

      included do
        respond_to :html, :js, :json
        helper_method :resource_saved?
        if self.resource_configuration.resource_method_name
          self.class_eval <<-RUBY
            alias_method :save_#{self.resource_configuration.resource_method_name.to_s}, :save_resource
            alias_method :destroy_#{self.resource_configuration.resource_method_name.to_s}, :destroy_resource
            alias_method :#{self.resource_configuration.resource_method_name.to_s}_saved?, :resource_saved?
            helper_method :#{self.resource_configuration.resource_method_name.to_s}_saved?
          RUBY
        end
      end

      def index

      end

      def new

      end

      def create
        save_resource
      end

      def edit

      end

      def update
        save_resource
      end

      def destroy
        destroy_resource
      end

      protected

      def resource_saved?
        @resource_saved
      end

      def save_resource &block
        resource.assign_attributes(resource_manager.params_resource)
        @resource_saved = resource.save
        after_redirect_for = "after_#{action_name}_path_for"
        action_path_for =
          case action_name
          when "create"
            :new
          when "update"
            :edit
          else
            :index
          end
        if block_given?
          block.call(resource)
        else
          if self.respond_to?(after_redirect_for, true)
            respond_with resource, location: send(after_redirect_for)
          else
            respond_with resource, location: url_for(controller: params[:controller], action: :index), action: action_path_for
          end
        end
      end

      def destroy_resource &block
        @destroy_resource = resource.destroy
        after_redirect_for = "after_#{action_name}_path_for"
        if block_given?
          block.call(@destroy_resource)
        else
          if self.respond_to?(after_redirect_for, true)
            respond_with resource, location: send(after_redirect_for), action: :destroy
          else
            respond_with resource, location: url_for(controller: params[:controller], action: :index), action: :destroy
          end
        end
      end


  end
end
