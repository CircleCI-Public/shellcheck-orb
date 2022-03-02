Set_SHELLCHECK_EXCLUDE_PARAM() {
    if [ -n "$SC_PARAM_EXCLUDE" ]; then
        SHELLCHECK_EXCLUDE_PARAM="--exclude=$SC_PARAM_EXCLUDE"
    else
        SHELLCHECK_EXCLUDE_PARAM=""
    fi
}

Set_SHELLCHECK_EXTERNAL_SOURCES_PARAM() {
    if [ "$SC_PARAM_EXTERNAL_SOURCES" == "1" ]; then
        SHELLCHECK_EXTERNAL_SOURCES="--external-sources"
    else
        SHELLCHECK_EXTERNAL_SOURCES=""
    fi
}

Set_SHELLCHECK_SHELL_PARAM() {
    if [ -n "$SC_PARAM_SHELL" ]; then
        SHELLCHECK_SHELL_PARAM="--shell=$SC_PARAM_SHELL"
    else
        SHELLCHECK_SHELL_PARAM=""
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
    set -x
    for encoded in $(echo "${SC_PARAM_IGNORE_DIRS}" | jq -r '.[] | @base64'); do
        decoded=$(echo "${encoded}" | base64 -d)
        if [ -e "${decoded}" ]; then
            set -- "$@" "!" "-path" "${decoded}/*.sh"
        fi
    done
    
    SC_PARAM_PATTERN="${SC_PARAM_PATTERN:-"*.sh"}"
    SC_INPUT_FILES=/tmp/sc-input-files
    find "$SC_PARAM_DIR" ! -name "$(printf "*\n*")" -name "$SC_PARAM_PATTERN" -type f "$@" | tee "${SC_INPUT_FILES}"
    set +e
    while IFS= read -r script
    do
        shellcheck "$SHELLCHECK_EXCLUDE_PARAM" "$SHELLCHECK_EXTERNAL_SOURCES" "$SHELLCHECK_SHELL_PARAM" --severity="$SC_PARAM_SEVERITY" --format="$SC_PARAM_FORMAT" "$script" >> "$SC_PARAM_OUTPUT"
    done < "${SC_INPUT_FILES}"
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
    Set_SHELLCHECK_EXTERNAL_SOURCES_PARAM
    Set_SHELLCHECK_SHELL_PARAM
    Run_ShellCheck
    Catch_SC_Errors
    rm /tmp/sc-input-files
}


# Will not run if sourced for bats.
# View src/tests for more information.
TEST_ENV="bats-core"
if [ "${0#*$TEST_ENV}" == "$0" ]; then
    SC_Main
fi
