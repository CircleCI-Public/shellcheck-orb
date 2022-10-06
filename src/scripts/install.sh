#!/bin/bash
if echo "$OSTYPE "| grep darwin > /dev/null 2>&1; then
    if [[ $EUID == 0 ]]; then export SUDO=""; else # Check if we're root
        export SUDO="sudo";
    fi
    # shellcheck disable=SC2086
    SC_DOWNLOAD_MAC="https://github.com/koalaman/shellcheck/releases/download/v${SC_INSTALL_VERSION}/shellcheck-v${SC_INSTALL_VERSION}.darwin.x86_64.tar.xz"
    curl -LJO "$SC_DOWNLOAD_MAC"
    tar -xvf "shellcheck-v$SC_INSTALL_VERSION.darwin.x86_64.tar.xz"
    cd "shellcheck-v$SC_INSTALL_VERSION/" || false
    $SUDO cp shellcheck /usr/local/bin
    exit $?
fi

if grep Alpine /etc/issue > /dev/null 2>&1; then
    apk add shellcheck
    echo "Alpine"
    exit $?
fi

if  grep Debian /etc/issue > /dev/null 2>&1 || grep Ubuntu /etc/issue > /dev/null 2>&1; then
    if [[ $EUID == 0 ]]; then export SUDO=""; else # Check if we're root
        export SUDO="sudo";
    fi
    # shellcheck disable=SC2086
    wget -qO- "https://github.com/koalaman/shellcheck/releases/download/v${SC_INSTALL_VERSION}/shellcheck-v${SC_INSTALL_VERSION}.linux.x86_64.tar.xz" | tar -xJf -
    cd "shellcheck-v$SC_INSTALL_VERSION/" || false
    $SUDO cp shellcheck /usr/local/bin
    exit $?
fi

if grep Arch /etc/issue > /dev/null 2>&1; then
    if [[ $EUID == 0 ]]; then export SUDO=""; else # Check if we're root
        export SUDO="sudo";
    fi
    # shellcheck disable=SC2086
    wget -qO- "https://github.com/koalaman/shellcheck/releases/download/v${SC_INSTALL_VERSION}/shellcheck-v${SC_INSTALL_VERSION}.linux.aarch64.tar.xz" | tar -xJf -
    cd "shellcheck-v$SC_INSTALL_VERSION/" || false
    $SUDO cp shellcheck /usr/local/bin
    exit $?
fi

