module Resources
  module Routes
    extend ActiveSupport::Concern
          
      included do
      end

      def routes
        Rails.application.routes || request.env['action_dispatch.routes']
      end

      def named_routes
        routes.named_routes
      end

      def router
        routes.router
      end

      def path_parameters
        request.env['action_dispatch.request.path_parameters'].symbolize_keys
      end

      def current_route
        recognize_route(request)
      end

      def current_path
        recognize_path(request.path)
      end



      protected

      def recognize_path(path)
        routes.recognize_path(path)
      end

      def recognize_route(request)
        router.recognize(request) do |route, matches, params|
          return route
        end
      end

  end
end
