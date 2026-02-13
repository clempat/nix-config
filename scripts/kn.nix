{ pkgs, ... }:
pkgs.writeShellScriptBin "kn" ''
  if [ "$1" != "" ]; then
  	kubectl config set-context --current --namespace=$1
  else
  	echo -e "\e[1;31m Error, please provide a valid Namespace\e[0m"
  fi
''
