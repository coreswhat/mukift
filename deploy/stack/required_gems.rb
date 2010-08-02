
package :required_gems do
  description 'Gems required by the application'
  requires :bundler
  requires :rake
end

package :rake do
  description 'Rake Gem'
  gem 'rake' do
    post :install, "ln -s #{REE_PATH}/bin/rake /usr/local/bin/rake"
  end
  
  verify do
    has_gem 'rake'
    has_symlink "/usr/local/bin/rake", "#{REE_PATH}/bin/rake"
  end

  requires :ruby_enterprise
end

package :bundler do
  description 'Bundler Gem'
  gem 'bundler' do
    pre :install, "gem update --system"
    post :install, "ln -s #{REE_PATH}/bin/bundle /usr/local/bin/bundle"
  end
  
  verify do
    has_gem 'bundler'
    has_symlink "/usr/local/bin/bundle", "#{REE_PATH}/bin/bundle"
  end

  requires :ruby_enterprise
end