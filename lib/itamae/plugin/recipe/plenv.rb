DEFAULT_PLENV_ROOT = "/usr/local/plenv"

def plenv_root
  if node[:plenv] && node[:plenv][:plenv_root]
    node[:plenv][:plenv_root]
  else
    DEFAULT_PLENV_ROOT
  end
end

def plenv_init
  <<-EOS
    export PLENV_ROOT=#{plenv_root}
    export PATH="#{plenv_root}/bin:${PATH}"
    eval "$(plenv init -)"
  EOS
end
