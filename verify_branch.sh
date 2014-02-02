#/bin/sh

CUR_BRANCH="$(git status --branch | head -1 | sed 's/# On branch //g')"

doSwitch () 
{
    BRANCH="$1"
    if $(git status | grep "$BRANCH" > /dev/null); then
        echo "Yes"
    else
        read -p "No (Current branch $CUR_BRANCH).  Should I switch it to $BRANCH for you?  (y/n): " input
        if [ "$input" = "y" ]; then
            git checkout -f $BRANCH
        else
            echo "OK, but if the build fails come back here and try again."
        fi
    fi
}

echo "Verifying a sane branch for your kernel version..."
if $(echo "$CUR_BRANCH" | grep -i "debug" > /dev/null); then
    read -p "You are on a debug branch ($CUR_BRANCH). WARNING: Unstable! (Enter to continue or Ctrl+C to abort):"
elif $(uname -r | grep "3.12" > /dev/null); then
    doSwitch "fedora-20"
elif $(uname -r | grep "3.11" > /dev/null); then
    doSwitch "ubuntu-13.10"
elif $(uname -r | grep "3.8" > /dev/null); then
    doSwitch "ubuntu-13.04"
elif $(uname -r | grep "3.2" > /dev/null); then
    doSwitch "ubuntu-12.04"
fi

