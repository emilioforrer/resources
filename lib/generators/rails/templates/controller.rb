<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  resource_for :"<%= controller_class_name.to_s.singularize.demodulize %>"
end
<% end -%>
