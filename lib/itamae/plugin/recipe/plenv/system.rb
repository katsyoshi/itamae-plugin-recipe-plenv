case node[:platform]
when "debian", "ubuntu"
  package "build-essential"
end

package "git"

require 'itamae/plugin/recipe/plenv'

scheme = "git"
scheme = node[:plenv][:scheme] if node[:plenv][:scheme]

git plenv_root do
  repository "#{scheme}://github.com/tokuhirom/plenv.git"
end

git "#{plenv_root}/plugins/perl-build" do
  repository "#{scheme}://github.com/tokuhirom/Perl-Build.git"
  if node[:'perl-build'] && node[:'perl-build'][:revision]
    revision node[:'perl-build'][:revision]
  end
end

node[:plenv][:versions].each do |version|
  execute "plenv install #{version}" do
    command "#{plenv_init} plenv install #{version}"
    not_if  "#{plenv_init} plenv versions | grep #{version}"
  end
end

node[:plenv][:global].tap do |version|
  execute "plenv global #{version}" do
    command "#{plenv_init} plenv global #{version}"
    not_if  "#{plenv_init} plenv version | grep #{version}"
  end
end
