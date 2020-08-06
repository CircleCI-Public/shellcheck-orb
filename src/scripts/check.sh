
Set_SHELLCHECK_EXCLUDE_PARAM() {
    if [ -n "$SC_PARAM_EXCLUDE" ]; then
        SHELLCHECK_EXCLUDE_PARAM=" --exclude $SC_PARAM_EXCLUDE"
    else
        SHELLCHECK_EXCLUDE_PARAM=""
    fi
}

SC_Main() {
    Set_SHELLCHECK_EXCLUDE_PARAM
    # POSIX
    find $SC_PARAM_DIR -type f \( -name '*.sh' -o -name '*.bash' -o -name '*.ksh' -o -name '*.bashrc' -o -name '*.bash_profile' -o -name '*.bash_login' -o -name '*.bash_logout' \) \
        | xargs shellcheck $SHELLCHECK_EXCLUDE_PARAM --severity $SC_PARAM_SEVERITY | tee -a "$SC_PARAM_OUTPUT"
}
# Will not run if sourced from another script. This is done so this script may be tested.
# View src/tests for more information.
if [[ "$_" == "$0" ]]; then
    SC_Main
fi