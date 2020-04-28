module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params = {}
      end

      def match?(method, path)
        @method == method && match_path(path)
      end

      private

      def match_path(path)
        route_array = @path.split('/')
        request_array = path.split('/')

        return false if route_array.length != request_array.length

        route_array.each_with_index do |elem, index|
          if elem.start_with?(':')
            add_param(elem, request_array[index])
          else
            return false if elem != request_array[index]
          end
        end
      end

      def add_param(param, value)
        param[0] = ''
        params[param.to_sym] = value
      end

    end
  end
end
