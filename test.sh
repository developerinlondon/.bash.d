GIT_BRANCH=""
GIT_HEAD=""
GIT_STATE=""
GIT_LEADER=""
STATUS=$(git status 2> /dev/null)
if [[ -z $STATUS ]]
then
    return
fi
GIT_LEADER=":"
GIT_BRANCH="$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
GIT_HEAD=":$(git rev-parse --short HEAD)"
if [[ "$STATUS" == *'working directory clean'* ]]
then
    GIT_STATE=""
else
    GIT_HEAD=$GIT_HEAD":"
    GIT_STATE=""
    if [[ "$STATUS" == *'Changes to be committed:'* ]]
    then
        GIT_STATE=$GIT_STATE'+I' # Index has files staged for commit
    fi
    if [[ "$STATUS" == *'Changed but not updated:'* || "$STATUS" == *'Changes not staged for commit'* ]]
    then
        GIT_STATE=$GIT_STATE"+M" # Working tree has files modified but unstaged
    fi
    if [[ "$STATUS" == *'Untracked files:'* ]]
    then
        GIT_STATE=$GIT_STATE'+U' # Working tree has untracked files
    fi
    GIT_STATE=$GIT_STATE''
fi
gdir=$(cd $GIT_ROOT; pwd -P)
export gdir