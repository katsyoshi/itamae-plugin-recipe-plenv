case node[:platform]
when "debian", "ubuntu"
  package "build-essential"
end

package "git"

scheme = "git"
scheme = node[:plenv][:scheme] if node[:plenv][:scheme]

plenv_root = "/usr/local/plenv"
plenv_root = node[:plenv][:plenv_root] if [:plenv][:plenv_root]

git plenv_root do
  repository "#{scheme}://github.com/tokuhirom/plenv.git"
end

git "#{plenv_root}/plugins/perl-build" do
  repository "#{scheme}://github.com/tokuhirom/Perl-Build.git"
  if node[:'perl-build'] && node[:'perl-build'][:revision]
    revision node[:'perl-build'][:revision]
  end
end

plenv_init = <<-EOS
  export PLENV_ROOT=#{plenv_root}
  export PATH="#{plenv_root}/bin:${PATH}"
  eval "$(plenv init -)"
EOS

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
