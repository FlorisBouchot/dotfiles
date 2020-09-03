#!/bin/bash

if [[ "$OSTYPE" != "darwin"* ]]; then
	echo "MacOS only available."
	exit 1
fi

shopt -s dotglob
TESTMODE=false
EXEPATH=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)

## ----------------------------------------
##	Functions
## ----------------------------------------
symlink_dotfiles() {
	CWD="${EXEPATH}"/dotfiles

	# ALPATH="${HOME}/Library/Application Support/Alfred"    && mkdir -p ${ALPATH}
	VSPATH="${HOME}/Library/Application Support/Code/User" && mkdir -p ${VSPATH}
	SKIPLIST=(".library" ".vscode")

	for abspath in ${CWD}/*; do
		filename=$(basename -- "$abspath");
		if [[ ${SKIPLIST[@]} =~ $filename ]]; then continue; fi;
		if [[ $filename = '.vsnip' ]]; then ln -sfnv $abspath ${VSPATH}/snippets; fi;
		
		ln -sfnv $abspath ${HOME};
	done

	for abspath in ${CWD}/.vscode/*; do
		ln -sfnv $abspath ${VSPATH};
	done

}

configure_system() {
	CWD=${EXEPATH}/system

	/bin/bash ${CWD}/macos.sh ${TESTMODE}
}

install_bundle() {
	CWD=${EXEPATH}/bundle

	## ========== Brew Bundle ==========
	brew upgrade
	brew bundle --file ${CWD}/Brewfile

	## ========== VSCode ==========
	## - code --list-extensions > Vscodefile
	if ! ${TESTMODE}; then
		plugins=($(cat ${CWD}/Vscodefile))
		for plugin in ${plugins}; do
			code --install-extension ${plugin}
		done
	fi
}

initialize() {  //TODO Device name
	if ! ${TESTMODE}; then
		xcode-select --install
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        

		mkdir -p ${HOME}/.ssh/github
		ssh-keygen -t rsa -b 4096 -C "floris@florisbouchot.com"
		ssh-keyscan -t rsa github.com >> ${HOME}/.ssh/known_hosts
		# curl -u "FlorisBouchot" --data "{\"title\":\"Floris Bouchot's DEVICE\",\"key\":\"`cat ~/.ssh/id_rsa.pub`\"}" https://api.github.com/user/keys
	fi

	
	mkdir -p ${HOME}/Projects/Code
    mkdir -p ${HOME}/Projects/Design

	! ${TESTMODE} && exec -l ${SHELL}
}

usage() {
	cat <<- EOS
		My personal dotfiles.
		Options for install.sh"
		================================================="
		init:     Core initialization"
		bundle:   Package installation"
		system:   MacOS system setting"
		dotfiles: Dotfiles installation"
		all:      All installations (except init)"
	EOS
}

## ----------------------------------------
##	Main
## ----------------------------------------
argv=$@

if [[ ${argv[@]} =~ "--help" || $# -eq 0 ]]; then
	usage
	exit 0
fi

if [[ ${argv[@]} =~ "--force" ]]; then
	argv=( ${argv[@]/"--force"} )
else
	read -p "Your file will be overwritten. OK? (Y/n): " Ans;
	[[ ${argv[@]} =~ "--init" ]] && Ans='Y';
	[[ $Ans != 'Y' ]] && echo 'Canceled' && exit 0;
fi

if [[ ${argv[@]} =~ "--test" ]]; then
	TESTMODE=true
	argv=( ${argv[@]/"--test"} )
fi

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

for opt in ${argv[@]}; do
	case $opt in
		--init)     initialize; ;;
		--bundle)   install_bundle; ;;
		--system)   configure_system; ;;
		--dotfiles) symlink_dotfiles; ;;
		--all)      install_bundle; symlink_dotfiles; configure_system; ;;
		*)          echo "invalid option $1"; ;;
	esac
done