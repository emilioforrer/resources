module Resources
  class Manager
    include Resources::Routes

    def initialize controller, request, *args
      @controller = controller
      @request = request
      @settings = grape? ? @controller.resource_configuration : @controller.class.resource_configuration
    end

    def resource_class
      @resource_class_name ||= settings.resource_class_name.to_s.safe_constantize
    end

    def resources_scope
      scope = option_with_scope(:resources_scope)
      @resources_scope =
        case
        when pagination?
          scope = scope.page(params_page) if scope.respond_to?(:page)
          scope = scope.paginate(page: params_page) if scope.respond_to?(:paginate)
          scope
        else
          scope
        end
    end

    def grape?
      defined?(Grape) && !(controller.class < ActionController::Base)
    end

    def pagination?
      settings.pagination.respond_to?(:call) ? settings.pagination.call(params, controller) : settings.pagination
    end

    def resource_scope
      @resource_scope = option_with_scope(:resource_scope)
    end

    def resources_search
      @resources_search ||= resources_scope.search(params_search) if resources_scope.respond_to?(:search)
    end


    def resources
      @resources ||= settings.search ? resources_search.result(settings.search_options) : resources_scope
    end

    def resource
      if grape?
        @resource ||= params[:id].blank? ? build_resource : (resource_scope.find(params[:id]) rescue nil )
      else
        @resource ||=
          case controller.action_name
          when "new", "create"
            build_resource
          else
            resource_scope.find(params[:id]) rescue nil
          end
      end
    end

    def settings
      @settings
    end

    def params
      grape? ? request.params : controller.params
    end

    def params_search
      @params_search ||= option_with_params(:params_search)
    end

    def params_page
      @params_page ||= option_with_params(:params_page)
    end

    def params_resource
      @params_resource ||= option_with_params(:params_resource)
    end

    def build_resource
      resource_class.new()
    end



    private


    def option_with_scope name
      raise ArgumentError.new("The class '#{settings.resource_class_name}' does not exists. Please specify a valid model") if resource_class.nil?
      scope = Rails::VERSION::MAJOR >= 4 ? resource_class.all : resource_class.scoped
      if settings.send(name)
        settings.send(name).respond_to?(:call) ? settings.send(name).call(scope,params,controller) : scope.send(settings.send(name))
      else
        scope
      end
    end

    def forbidden_params_names
      [settings.resource_method_name, settings.resources_method_name, :resource, :resources]
    end

    def forbidden_params_names? name
      forbidden_params_names.map(&:to_s).include?(settings.send(name).to_s)
    end

    def resource_allow_permit?
      resource.respond_to?(:permited_attributes) && resource.permited_attributes.is_a?(Array)
    end

    def option_with_params name
      result = {}
      if settings.send(name).respond_to?(:call)
        result = settings.send(name).call(params)
      else
        if Rails::VERSION::MAJOR >= 4
          value = params[settings.send(name)]
          if name.to_s == "params_resource"
            result = value.respond_to?(:permit) && resource_allow_permit? ? value.permit(*resource.permited_attributes) : value
          else
            result = value
          end
        else
          result = params[settings.send(name)]
        end
      end
      result = result && result.is_a?(Hash) || name.to_s == "params_page" ? result :  {}
      result
    end

    def controller
      @controller
    end

    def request
      @request
    end




  end
end
