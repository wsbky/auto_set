#!/bin/zsh

# # system info
# sysname=$(uname -m)

# if [ $sysname = "x86_64" ]; then
#     BREW_HOME="/usr/local/"
# elif [ $sysname = "arm64"]; then
#     BREW_HOME="/opt/homebrew"
# else
#     echo "This program is not supported on ${sysname}"
#     return 1
# fi

# # install command line developer tools
# xcode-select --install

# # install homebrew
# if !(type "brew" > /dev/null 2>&1); then
#     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# fi

# # change shell to homebrew zsh
# read -p "Change Shell to Homebrew zsh? (y/n)" Answer < /dev/tty
# case ${Answer} in
#     y|Y)
#         brew install zsh
#         sudo -S -- sh -c "echo "${BREW_HOME}/bin/zsh" >> /etc/shells"
#         chsh -s $BREW_HOME/bin/zsh
#         ;;
#     *)
#         echo "skipped";;
# esac

# backup current config files
mkdir $HOME/BACKUP
cp $HOME/.zprezto $HOME/.zlogin $HOME/.zlogout $HOME/.zpreztorc $HOME/.zprofile $HOME/.zshenv $HOME/.zshrc $HOME/BACKUP
rm -rf $HOME/.zprezto $HOME/.zlogin $HOME/.zlogout $HOME/.zpreztorc $HOME/.zprofile $HOME/.zshenv $HOME/.zshrc

if [ -n "$(ls $HOME/BACKUP)" ]; then
    rm -rf $HOME/BACKUP
fi

# set ZDOTDIR
ZDOTDIR="$HOME/.dotfiles/zsh"
touch $HOME/.zshenv
echo "export ZDOTDIR=${ZDOTDIR}" >> $HOME/.zshenv
source $HOME/.zshenv
echo "source $ZDOTDIR/.zshenv" >> $HOME/.zshenv


# install prezto
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

# path for homebrew
echo "export PATH=$PATH:$BREW_HOME/bin" >> $HOME/.dotfiles/zsh/.zshrc
source $ZDOTDIR/.zshrc
