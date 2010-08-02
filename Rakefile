
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

namespace :app_custom_files do

  desc "Create a copy of all the app custom files without the '.example' extension."
  task :generate do
    config_files = ['app_config.rb', 'database.rb', 'messages.rb']
    deploy_files  = ['deploy.rb', 'prepare.rb']

    root_path = File.dirname(__FILE__)

    config_path = File.join(root_path, 'config')
    config_files.each do |f|
      file = File.join(config_path, f)
      FileUtils.copy_file("#{file}.example", file) unless File.exist?(file)
    end

    deploy_path = File.join(root_path, 'deploy')
    deploy_files.each do |f|
      file = File.join(deploy_path, f)
      FileUtils.copy_file("#{file}.example", file) unless File.exist?(file)
    end
  end
end


