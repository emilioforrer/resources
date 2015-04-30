module Resources
  class Configuration

    def self.accessors
      [:rest_actions, :search, :search_options, :params_search, :resource_class_name, :resource_scope, :resources_scope, :resource_method_name, :resources_method_name, :params_resource, :pagination, :params_page]
    end
    accessors.map{|a| attr_accessor a }

    def initialize *args
      options = args.extract_options!
      self.rest_actions = options[:rest_actions] || true
      self.search = options[:search] || false
      self.search_options = options[:search_options] && options[:search_options].is_a?(Hash) ? options[:search_options] : {distinct: false}
      self.params_search = options[:params_search] || :q
      self.params_resource = options[:params_resource] || :resource
      self.params_page = options[:params_page] || :page
      self.pagination = options[:pagination] || false
      self.resource_scope = options[:resource_scope] || nil
      self.resources_scope = options[:resources_scope] || nil
      self.resource_method_name = options[:resource_method_name] || :resource
      self.resources_method_name = options[:resources_method_name] || :resources
      if self.resource_method_name.to_s != "resource" && options[:resources_method_name].to_s == "resources"
        self.resources_method_name = self.resource_method_name.to_s.pluralize
      end
    end


    def to_hash
      hash =HashWithIndifferentAccess.new
      self.class.accessors.each do |m|
        hash[m] = send(m)
      end
      hash
    end




  end

  Config = Resources::Configuration.new()

  def self.config(&block)
    yield(Config)
  end


end
