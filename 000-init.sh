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
