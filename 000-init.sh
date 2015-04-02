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

__usage() {
    local var; var=$1
    local usagemsg; usagemsg=$2

    [ "x${var}" = "x" ] && {
        echo "Usage: ${usagemsg}"
        return 1
    }
    return 0
}
