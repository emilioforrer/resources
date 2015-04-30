class Admin::CountriesController < ApplicationController
  resource_for "Country",
    pagination: true,
    rest_actions: true,
    search: true,
    search_options: {distinct: true},
    params_resource: :country,
    resource_method_name: :country
end
