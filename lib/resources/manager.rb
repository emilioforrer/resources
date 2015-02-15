module Resources
  class Manager
    include Resources::Routes

    def initialize controller, request, *args
      @controller = controller
      @request = request
      @settings = @controller.class.resource_configuration
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

    def pagination?
      settings.pagination.is_a?(Proc) ? settings.pagination.call(params, controller) : settings.pagination
    end
    
    def resource_scope
      @resource_scope = option_with_scope(:resource_scope)
    end

    def resources_search
      @resources_search ||= resources_scope.search(params_search) rescue nil
    end


    def resources 
      @resources ||= settings.search ? resources_search.result(settings.search_options) : resources_scope
    end

    def resource 
      @resource ||=
        case controller.action_name
        when "new", "create"
          build_resource
        else
          resource_scope.where("#{resource_class.table_name}.id = ?",params[:id]).first rescue nil
        end
    end

    def settings
      @settings
    end

    def params
      request.params
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
      scope = Rails::VERSION::MAJOR >= 4 ? resource_class.all : resource_class.scoped
      if settings.send(name)
        settings.send(name).is_a?(Proc) ? settings.send(name).call(scope,params,controller) : scope.send(settings.send(name))
      else
        scope
      end
    end

    def option_with_params name 
      settings.send(name).is_a?(Proc) ? settings.send(name).call(params) : params[settings.send(name)]
    end

    def controller
      @controller
    end

    def request
      @request
    end

    


  end
end