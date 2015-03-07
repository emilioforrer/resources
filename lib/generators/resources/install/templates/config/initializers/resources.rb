# GLobal Configuration
Resources.config do |config|

  config.rest_actions = true # Enable restful actions (index,new, create, etc)
  config.search = false # Enable ransack search object (resources_search)
  config.search_options =  {distinct: false} # ransack result options. Default {distinct: false}

  # Setting Params (params_search, params_resource, etc)
  # You can specify a params key like :q, that will be params[:q]
  # Or you can set a lambda like lambda{ |params|   params[:q] }
  config.params_search = :q # ransack search parameter. Default params[:q]
  config.params_resource = :resource # resource parameter to be saved. Default params[:resource]
  config.params_page = :page # Pagination parameter. Default params[:page]


  config.pagination =  false # Enables pagination (kaminari or will_paginate)

  # Setting a default scope for the collection and resource objects
  # You can specify an scope name to be executed like :active
  # Or if you have something more complex or need to pass a parameter to the scope, you can use a lambda like lambda{ |scope, params, controller|   scope.by_activation(params[:active]).includes(:states) }
  config.resource_scope = nil # default scope for resource object
  config.resources_scope =  nil # default scope for resources collection

  # Setting alias method of resource, if you change the value to, for example :country you will gain this extra helper methods:
  # countries for the collection object
  # country for the resource object
  # country_saved? to know if the resource was saved
  config.resource_method_name =  :resource # alias method of resource
  config.resources_method_name =  :resources # alias method of resources, if you dont specify one it takes "resource_method_name.to_s.pluralize" 
end
