require "loader"
module Resources

end
ActionController::Base.send(:include, Resources::Controller)
