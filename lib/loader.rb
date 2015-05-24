require "responders"

require "resources/actions"
require "resources/rest_actions"
require "resources/configuration"
require "resources/controller"
require "resources/routes"
require "resources/manager"

if defined?(Grape)
  require "resources/grape_helpers"
end
