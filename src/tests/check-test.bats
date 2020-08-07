setup() {
    source ./src/scripts/check.sh
    export SC_PARAM_DIR="./src/scripts"
}

@test "1: Shellcheck test" {
    export SC_PARAM_SEVERITY="style"
    export SC_PARAM_EXCLUDE="SC2148,SC2038"
    export SC_PARAM_OUTPUT="/tmp/shellcheck.log"
    SC_Main
}