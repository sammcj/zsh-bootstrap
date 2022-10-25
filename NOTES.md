# General notes related to this repo

## ASDF

Get install path to source

```shell
echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh"
```

Plugins

# languages

```shell
asdf plugin-add {
  nodejs  https: //github.com/asdf-vm/asdf-nodejs.git
  yarn    https: //github.com/twuni/asdf-yarn.git
  python  https: //github.com/danhper/asdf-python.git
  golang  https: //github.com/kennyp/asdf-golang.git
  bundler https: //github.com/jonathanmorley/asdf-bundler.git
  ruby    https: //github.com/asdf-vm/asdf-ruby.git
  rust    https: //github.com/code-lever/asdf-rust.git
}

  # Tools that are only available via asdf
asdf plugin-add {
  action-validator https: //github.com/mpalmer/action-validator.git
  semver https: //github.com/mathew-fleisch/asdf-semver.git
}

# Terraform
asdf plugin-add {
  tfenv               https: //github.com/carlduevel/asdf-tfenv.git
  tfsec               https: //github.com/woneill/asdf-tfsec.git
  terraform           https: //github.com/asdf-community/asdf-hashicorp.git
  terraform-ls        https: //github.com/asdf-community/asdf-hashicorp.git
  terraform-validator https: //github.com/asdf-community/asdf-hashicorp.git
  tfupdate            https: //github.com/yuokada/asdf-tfupdate.git
  tfstate-lookup      https: //github.com/carnei-ro/asdf-tfstate-lookup.git
}

```

`.tool-versions`
