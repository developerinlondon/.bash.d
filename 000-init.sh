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
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  echo export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH" >> ~/.bashrc
  brew install coreutils
  brew install binutils
  brew install diffutils
  brew install ed --with-default-names
  brew install findutils --with-default-names
  brew install gawk
  brew install gnu-indent --with-default-names
  brew install gnu-sed --with-default-names
  brew install gnu-tar --with-default-names
  brew install gnu-which --with-default-names
  brew install gnutls
  brew install grep --with-default-names
  brew install gzip
  brew install screen
  brew install watch
  brew install wdiff --with-gettext
  brew install wget
  brew install bash
  brew install emacs
  brew install gdb  # gdb requires further actions to make it work. See `brew info gdb`.
  brew install gpatch
  brew install m4
  brew install make
  brew install nano
  brew install file-formula
  brew install git
  brew install less
  brew install openssh
  brew install perl518   # must run "brew tap homebrew/versions" first!
  brew install python
  brew install rsync
  brew install svn
  brew install unzip
  brew install vim --override-system-vi
  brew install macvim --override-system-vim --custom-system-icons
  brew install zsh
}