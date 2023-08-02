#!/bin/bash
if [[ $EUID == 0 ]]; then export SUDO=""; else # Check if we're root
    export SUDO="sudo"
fi

install_mac() {
    curl -LJO "https://github.com/koalaman/shellcheck/releases/download/v${SC_INSTALL_VERSION}/shellcheck-v${SC_INSTALL_VERSION}.darwin.x86_64.tar.xz"
    tar -xvf "shellcheck-v$SC_INSTALL_VERSION.darwin.x86_64.tar.xz"
    cd "shellcheck-v$SC_INSTALL_VERSION/" || false
    $SUDO cp shellcheck /usr/local/bin
}
install_linux() {
    wget -qO- "https://github.com/koalaman/shellcheck/releases/download/v${SC_INSTALL_VERSION}/shellcheck-v${SC_INSTALL_VERSION}.linux.x86_64.tar.xz" | tar -xJf -
    cd "shellcheck-v$SC_INSTALL_VERSION/" || false
    $SUDO cp shellcheck /usr/local/bin
}
install_arm64() {
    wget -qO- "https://github.com/koalaman/shellcheck/releases/download/v${SC_INSTALL_VERSION}/shellcheck-v${SC_INSTALL_VERSION}.linux.armv6hf.tar.xz" | tar -xJf -
    cd "shellcheck-v$SC_INSTALL_VERSION/" || false
    $SUDO cp shellcheck /usr/local/bin
}
install_alpine() {
    apk add shellcheck
}
install_arch() {
    wget -qO- "https://github.com/koalaman/shellcheck/releases/download/v${SC_INSTALL_VERSION}/shellcheck-v${SC_INSTALL_VERSION}.linux.aarch64.tar.xz" | tar -xJf -
    cd "shellcheck-v$SC_INSTALL_VERSION/" || false
    $SUDO cp shellcheck /usr/local/bin
}

# Platform check
if uname -a | grep "Darwin"; then
    install_mac
elif uname -a | grep "x86_64 GNU/Linux"; then
    install_linux
elif uname -a | grep "aarch64 GNU/Linux"; then
    install_arm64
elif uname -a | grep "x86_64 Msys"; then
    install_windows
elif grep "Alpine" /etc/issue >/dev/null 2>&1; then
    install_alpine
elif grep Arch /etc/issue >/dev/null 2>&1; then
    install_arch
else
    echo "This platform appears to be unsupported."
    uname -a
    exit 1
fi
