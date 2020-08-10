
Set_SHELLCHECK_EXCLUDE_PARAM() {
    echo "DEBUG: Set Exclude Param"
    if [ -n "$SC_PARAM_EXCLUDE" ]; then
        SHELLCHECK_EXCLUDE_PARAM="--exclude=$SC_PARAM_EXCLUDE"
    else
        SHELLCHECK_EXCLUDE_PARAM=""
    fi
    echo "DEBUG: Value: $SHELLCHECK_EXCLUDE_PARAM"
}

Run_ShellCheck() {
    echo "DEBUG: Shellcheck files"
    find $SC_PARAM_DIR ! -name "$(printf "*\n*")" -name '*.sh' > tmp
    set +e
    while IFS= read -r script
    do
        shellcheck $SHELLCHECK_EXCLUDE_PARAM --severity=$SC_PARAM_SEVERITY "$script" >>"$SC_PARAM_OUTPUT"
    done < tmp
    set -eo pipefail
    rm tmp
}

Catch_SC_Errors() {
    echo "DEBUG: Check for errors"
    RED='\e[1;31m'
    GREEN='\e[1;32m'
    NC='\e[0m' # No Color
    if [ -s "$SC_PARAM_OUTPUT" ]; then
        # shellcheck disable=SC2059
        printf "${RED}ShellCheck Errors Found${NC}\n"
        cat "$SC_PARAM_OUTPUT"
        exit 1
    else
        # shellcheck disable=SC2059
        printf "${GREEN}No ShellCheck Errors Found${NC}\n"
    fi
}

SC_Main() {
    echo "DEBUG: Starting"
    Set_SHELLCHECK_EXCLUDE_PARAM
    Run_ShellCheck
    Catch_SC_Errors
}

# Will not run if sourced from another script. This is done so this script may be tested.
# View src/tests for more information.
if [[ "$(basename -- "$0")" != "check.sh" ]]; then
    SC_Main
fi