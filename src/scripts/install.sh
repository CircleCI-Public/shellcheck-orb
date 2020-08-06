if echo "$OSTYPE "| grep darwin > /dev/null 2>&1; then
    brew install shellcheck
    exit $?
fi

if grep Alpine /etc/issue > /dev/null 2>&1; then
    apk add shellcheck
    exit $?
fi

if  grep Debian /etc/issue > /dev/null 2>&1 || grep Ubuntu /etc/issue > /dev/null 2>&1; then
    if [[ $EUID == 0 ]]; then export SUDO=""; else # Check if we're root
        export SUDO="sudo";
    fi
    # This is currently installing an outdated version of Shellcheck.
    # $SUDO apt update
    # $SUDO apt install -y shellcheck
    wget -qO- https://github.com/koalaman/shellcheck/releases/download/v0.7.1/shellcheck-v0.7.1.linux.x86_64.tar.xz | tar -xJf -
    cd shellcheck-v0.7.1/ || false
    $SUDO cp shellcheck /usr/local/bin
    echo $?
fi

if grep Arch /etc/issue > /dev/null 2>&1; then
    if [[ $EUID == 0 ]]; then export SUDO=""; else # Check if we're root
        export SUDO="sudo";
    fi
    $SUDO pacman -Sy
    $SUDO pacman -S shellcheck
    exit $?
fi
# @TODO: Add Windows support.