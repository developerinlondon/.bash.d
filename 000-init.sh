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

THOR_API_ENDPOINT="https://api.thor.nokia.com/v1"
REPOSERVER="https://repomgr.thor.nokia.com"
export REPOCERT="$HOME/.thor/repomgr_server.crt"
REPOUSER=$USER

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
