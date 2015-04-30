**Resources**
===================

It's a gem that help's you to create **CRUD** controllers for your models in a **very fast** and **flexible** way.

**Note:** Version 1.0.0+ introduces some breaking changes, to see the list of this change please check [CHANGE_LOG.md](https://github.com/emilioforrer/resources/blob/master/CHANGELOG.md)

----------


**Installation**
------------



Add this line to your application's Gemfile:

```
gem 'resources'
```

And then execute:

```
bundle install
```

Or install it yourself as:

```
$ gem install resources
```

Rub the configuration generator, this will create the **resources initializer**

```
rails g resources:install
```

----------

USAGE
-------------

 Just add `resource_for` to your controller and give the model's name

```
class Admin::CountriesController < ApplicationController
  resource_for "Country"
end
```

or use the controller generator

```
rails g resource_controller admin/country
```

And that's it, you have to do anything else on the controller to create a **CRUD** maintenance for the country model.

`resource_for` will **handle all the restful** actions for you and it will give you the next's helper_methods for your convenience:

**`resources`:** this will have a collection of `Country`, objects so you can use on the `index` actions or any other collection route actions of your controller

**`resource`:** this will have a  `Country`, object so you can use on the member route actions like  `new, create, edit, update, show, destroy`

**`resources_search`:**  this is a **[ransack](https://github.com/activerecord-hackery/ransack)** object to you in the `search_form_for` helper

**`resource_saved?`:** this is a helper to user after create or update a record to know if it was saved.


## OPTIONS AND FLEXIBILITY



`resource_for` by default expects the `params` key for update or create the object to be `resource` if you use `form_for` or `simple_form` you need to add the `as: :resource` option


```
= simple_form_for [:admin, resource], as: :resource do |f|
  = f.input :code
  = f.input :name
  = f.input :active
  = f.submit "SAVE"
```



#### **RESOURCE PARAMS -  `params_resource`**

This options allows you to change the default params key used for create or update the record. So you don't have to add the `as: :resource` to the `simple_form_for`.

```
class Admin::CountriesController < ApplicationController
  resource_for :"Country",
    params_resource: :country
end
```

**Note:** For **Rails 4** you may encounter with this error (ActiveModel::ForbiddenAttributesError)  when you try to update a record  due to **`strong_parameters`** protection. To avoid this just add to your model a method named `permited_attributes` that return an array of allowed attributes. Example

```
class Country < ActiveRecord::Base

  def permited_attributes
    [:name, :code, :active]
  end

end
```


Or you can use the  `lambda` syntax.

```
class Admin::CountriesController < ApplicationController
  resource_for :"Country",
    params_resource: lambda{ |params|   params[:country] }
end

# For rails 4

class Admin::CountriesController < ApplicationController
  resource_for :"Country",
    params_resource: lambda{ |params|
      params.require(:country).permit(:name)
    }
end
```

#### **RESOURCE ALIAS - `resource_method_name` - `resources_method_name`**

This options allows you to alias the `resource` method in case you don't like the name.  if you don't specify a `resources_method_name` it will name the alias to `resource_method_name` **pluralized**.

```
class Admin::CountriesController < ApplicationController
  resource_for :"Country",
    params_resource: :country,
    resource_method_name: :country
end
```
**NOTE:** making a change in `resource_method_name` and `resources_method_name` options requires a **server restart**.

Now in your view you can use `country` instead of `resource`

```
= simple_form_for [:admin, country] do |f|
  = f.input :code
  = f.input :name
  = f.input :active
  = f.submit "SAVE"
```


#### **PAGINATION - `pagination`**

This option enable pagination in case that you use any of the most popular pagination gems ([kaminari](https://github.com/amatsuda/kaminari) or [will_paginate](https://github.com/mislav/will_paginate)).

```
class Admin::CountriesController < ApplicationController
  resource_for :"Country",
    pagination: true,
    params_resource: :country,
    resource_method_name: :country
end
```

Or you can use the  `lambda` syntax.

```
class Admin::CountriesController < ApplicationController
  resource_for :"Country",
    pagination: lambda{ |params, controller| params[:disable_pagination].blank? },
    params_resource: :country,
    resource_method_name: :country
end
```

#### **DEFAULT SCOPES - `resource_scope`- `resources_scope`**

This options are to set a default `scope` for the `resources`, and `resource` objects.


```
class Admin::CountriesController < ApplicationController
  resource_for :"Country",
    resources_scope: :active,
    pagination: true,
    params_resource: :country,
    resource_method_name: :country
end
```
**Note:** this will execute the scope `active` and get you only the countries that are currently actives.

You can use the  `lambda` syntax for a **more complex scope**.

```
class Admin::CountriesController < ApplicationController
  resource_for :"Country",
    resources_scope: lambda{ |scope, params, controller|
      scope.by_active_state(params[:active_state]).includes(:cities)
    },
    pagination: true,
    params_resource: :country,
    resource_method_name: :country
end
```


#### **SEARCH - `search`- `search_options`**

The `search` option enable [ransack](https://github.com/activerecord-hackery/ransack) in case that you have installed it. And the `search_options` allows you to pass a hash of parameters to the result method of ransack like **`distinct: true`**


```
class Admin::CountriesController < ApplicationController
  resource_for :"Country",
    search: true,
    search_options: {distinct: true},
    resources_scope: :active,
    pagination: true,
    params_resource: :country,
    resource_method_name: :country
end
```
**NOTE:** For the use of the** `search_form_for`** you have the `resources_search` helper that is a racksack object or in this case `countries_search` because we used the resource alias `resource_method_name`

```
= search_form_for [:admin, countries_search] do |f|
  = f.label :name_cont
  = f.search_field :name_cont
  = f.submit
```
#### **Overriding methods **

##### **Redirects **

By default, after any of the REST actions that modify the record  (create, update, destroy) **it redirects to the index action** of that controller, but if you define method  **`after_#{action_name}_path_for`**  that returns  a path **it will execute this method and redirect** to that particular path.

**Example**

```
  def after_create_path_for
    root_url
  end

```
**NOTE:** After creating the record it will redirect to the **root_url**

##### **default REST actions**

If you want to override any of the REST actions, to add any extra logic that you may need, you can just pass a block to the **`save_resource`** or **`destroy_resource`** inside the actions and add your custom logic there.

**Example**

```
  def create
    save_resource do
      # Add you complex logic here
      if resource_saved?
        flash[:notice] = I18n.t("app.record_successfully_created")
        redirect_to root_url and return
      else
        render action: :new
      end
    end
  end

```

**NOTE:** Remember that you can make use of the  **`resource_saved?`** method to know if the record has been saved

#### **Using it with Grape **

If you are using `resources` with the [Grape](https://github.com/intridea/grape) gem fallow the next steps:

In your Gemfile add the `resources` **after** `grape`

```
gem "grape"
gem 'grape-raketasks'
gem "hashie-forbidden_attributes"
gem "resources"
```

Now in your api class add the **`helpers ::Resources::GrapeHelpers`** and in the execute the  **`resource_for`** inside a before block.

```
require "resources"
require "resources/grape_helpers" # only need to add this line if you didnt do the previous step
module Twitter
  class API < Grape::API
    version 'v1', using: :header, vendor: 'twitter'
    format :json
    prefix :api

    helpers ::Resources::GrapeHelpers

    before do
      resource_for :"Country"
    end

    resource :countries do
      desc "Return a list of countries."
      get do
        resources
      end

      desc "Return a country."
      get ':id' do
        resource
      end

      desc "Update a country."
      put ':id' do
        save_resource
      end

    end

  end
end

```
**NOTE:** Currently there is a limitation, the option **`resource_method_name`** doesn't work inside grape


#### **GLOBAL CONFIGURATION **

You can change the default parameters of any configuration by change the options in the `config/initializers/resources.rb` that was generated by running `rails g resources:install`

```
Resources.config do |config|
  config.params_search = :q # ransack search parameter. Default params[:q]
  config.params_resource = :resource # resource parameter to be saved.  
end
```


----------


## **Copyright**

Copyright (c) 2015 Emilio Forrer. See LICENSE.txt for further details.
