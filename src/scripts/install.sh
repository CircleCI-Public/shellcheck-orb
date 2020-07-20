if echo $OSTYPE | grep darwin > /dev/null 2>&1; then
    brew install shellcheck
    exit $?
fi

if cat /etc/issue | grep Alpine > /dev/null 2>&1; then
    apk add shellcheck
    exit $?
fi

if cat /etc/issue | grep Debian > /dev/null 2>&1 || cat /etc/issue | grep Ubuntu > /dev/null 2>&1; then
    if [[ $EUID == 0 ]]; then export SUDO=""; else # Check if we're root
        export SUDO="sudo";
    fi

    $SUDO apt install shellcheck
    echo $?
fi

if cat /etc/issue | grep Arch > /dev/null 2>&1; then
    if [[ $EUID == 0 ]]; then export SUDO=""; else # Check if we're root
        export SUDO="sudo";
    fi

    $SUDO pacman -S shellcheck
    exit $?
fi
# @TODO: Add Windows support.