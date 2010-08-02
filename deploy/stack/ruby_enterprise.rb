
package :ruby_enterprise do
  description 'Ruby Enterprise Edition'
  version '1.8.7-2010.01'
  REE_PATH = "/usr/local/ruby-enterprise" unless defined?(REE_PATH)

  binaries = %w(erb gem irb rdoc ree-version ri ruby testrb)
  source "http://rubyforge.org/frs/download.php/68719/ruby-enterprise-#{version}.tar.gz" do
    custom_install 'sudo ./installer --dont-install-useful-gems --auto=/usr/local/ruby-enterprise'
    binaries.each {|bin| post :install, "ln -s #{REE_PATH}/bin/#{bin} /usr/local/bin/#{bin}" }
  end

  verify do
    has_directory install_path
    has_executable "#{REE_PATH}/bin/ruby"
    binaries.each {|bin| has_symlink "/usr/local/bin/#{bin}", "#{REE_PATH}/bin/#{bin}" }
  end

  requires :ree_dependencies
end

package :ree_dependencies do
  apt %w(zlib1g-dev libreadline5-dev libssl-dev)
  requires :build_essential
end


