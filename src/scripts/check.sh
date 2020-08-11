
Set_SHELLCHECK_EXCLUDE_PARAM() {
    if [ -n "$SC_PARAM_EXCLUDE" ]; then
        SHELLCHECK_EXCLUDE_PARAM="--exclude=$SC_PARAM_EXCLUDE "
    else
        SHELLCHECK_EXCLUDE_PARAM=""
    fi
}

Check_for_shellcheck() {
    if ! command -v shellcheck &> /dev/null
    then
        echo "Shellcheck not installed"
        exit
    fi
}

Run_ShellCheck() {
    SC_PARAM_PATTERN="${SC_PARAM_PATTERN:-"*.sh"}"
    find "$SC_PARAM_DIR" ! -name "$(printf "*\n*")" -name "$SC_PARAM_PATTERN" > tmp
    set +e
    while IFS= read -r script
    do
        echo "shellcheck $SHELLCHECK_EXCLUDE_PARAM--shell=$SC_PARAM_SHELL --severity=$SC_PARAM_SEVERITY $script >> $SC_PARAM_OUTPUT"
        which shellcheck
        # shellcheck disable=SC2086
        shellcheck $SHELLCHECK_EXCLUDE_PARAM --shell=$SC_PARAM_SHELL --severity=$SC_PARAM_SEVERITY "$script" >> $SC_PARAM_OUTPUT
    done < tmp
    set -eo pipefail
}

Catch_SC_Errors() {
    if [ -s "$SC_PARAM_OUTPUT" ]; then
        printf '\e[1;31mShellCheck Errors Found\e[0m\n'
        cat "$SC_PARAM_OUTPUT"
        exit 1
    else
        printf '\e[1;32mNo ShellCheck Errors Found\e[0m\n'
    fi
}

SC_Main() {
    Check_for_shellcheck
    Set_SHELLCHECK_EXCLUDE_PARAM
    Run_ShellCheck
    Catch_SC_Errors
    rm tmp
}


# Will not run if sourced for bats.
# View src/tests for more information.
TEST_ENV="bats-core"
if [ "${0#*$TEST_ENV}" == "$0" ]; then
    SC_Main
fi
