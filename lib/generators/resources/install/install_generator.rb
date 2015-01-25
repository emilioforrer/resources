class Resources::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  def generate_install
    copy_file "config/initializers/resources.rb", "config/initializers/resources.rb"
  end

  
end
