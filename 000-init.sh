case `uname -s` in
  Darwin)
    SED=gsed
    AWK=gawk
  ;;
  Linux)
    SED=sed
    AWK=awk
  ;;
esac

__usage() {
    local var; var=$1
    local usagemsg; usagemsg=$2

    [ "x${var}" = "x" ] && {
        echo "Usage: ${usagemsg}"
        return 1
    }
    return 0
}

bashdlist() {
  grep -h '() {' ~/.bash.d/*.sh \
    | grep -v grep \
    | grep -v '#' \
    | grep -v '^__' | cut -d'(' -f1 | sort
}

install_core() {
  # install rvm
  \curl -sSL https://get.rvm.io | bash
  rvm install 2.1.2

  # install cpanmin.us
  \curl -L http://cpanmin.us  | perl - App::cpanminus --sudo

  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  echo export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH" >> ~/.bashrc

  # install brew cask
  brew tap caskroom/cask
  brew install brew-cask

  brew install autojump

  brew install htop

  # gnu
  brew install coreutils
  brew install binutils
  brew install diffutils
  brew install findutils --with-default-names
  brew install gawk
  brew install gnu-indent --with-default-names
  brew install gnu-sed --with-default-names
  brew install gnu-tar --with-default-names
  brew install gnu-which --with-default-names
  brew install gnutls
    brew install watch
  brew install wdiff --with-gettext
  brew install wget
  brew install bash
  brew install emacs
  brew install gdb  # gdb requires further actions to make it work. See `brew info gdb`.
  brew install git

  brew tap homebrew/versions
  brew install perl518   # must run "brew tap homebrew/versions" first!
  brew install python
  brew install grsync
  brew install svn
  brew install vim --override-system-vi
  brew install zsh

  # install virtualbox + vagrant
  brew cask install virtualbox
  brew cask install vagrant
  brew cask install vagrant-bar
  brew cask install vagrant-manager

  brew cask install google-chrome

  # install java + misc
  brew cask install java
  brew cask install hipchat
  brew cask install caffeine
  brew cask install skype
  brew cask install keepassx
  brew cask install sublime-text
  brew cask install daisydisk
  brew cask install packer
  brew cask install viber
  brew cask install kindle-previewer
  brew cask install pokerstars
  brew cask install limechat
  brew cask install adobe-reader
  brew cask install pycharm-ce
  brew cask install filezilla
  brew cask install evernote
  brew cask install slack
  brew cask install hubic
  #brew install pass
  #echo "source /usr/local/etc/bash_completion.d/password-store" >> ~/.bashrc
  brew cask install dropbox
  brew cask install disk-inventory-x


  brew install ansible
  gem install thor parseconfig

  # install postgres + redis
  brew install postgres
  brew install python
  brew install zsh
  brew install nmap
  brew install nodejs
  brew install hub
  brew install gh
  brew install ack
  brew install links
  brew install tree


  # install awscli
  brew install pip
  curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
  unzip awscli-bundle.zip
  sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
  
  pip install boto
  pip install fabric

  npm install gulp -gulp

  # install docker
  pip install -U docker-compose
  brew cask install kitematic
  brew cask install docker-machine
}