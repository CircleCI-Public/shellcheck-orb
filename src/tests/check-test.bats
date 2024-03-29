setup() {
    source ./src/scripts/check.sh
    export SC_PARAM_OUTPUT="/tmp/shellcheck.log"
    export SC_PARAM_SHELL="bash"
    Check_For_ShellCheck
}

teardown() {
    # Clean shellcheck log for sake of other tests
    rm -rf /tmp/shellcheck.log
}

# Esure Shellcheck is able to find the two included shell scripts
@test "1: Shellcheck test - Find both scripts" {
    export SC_PARAM_DIR="src/scripts"
    export SC_PARAM_SEVERITY="style"
    export SC_PARAM_EXCLUDE="SC2148,SC2038,SC2059"
    ShellCheck_Files
    # Test that 2 scripts were found
    [ $(wc -l /tmp/sc-input-files | awk '{print $1}') == 2 ]
}

# Esure Shellcheck is able to find files with custom patterns
@test "2: Shellcheck test - Find one custom pattern script" {
    export SC_PARAM_DIR="src/tests/test_data"
    export SC_PARAM_SEVERITY="style"
    export SC_PARAM_EXCLUDE="SC2148,SC2038,SC2059"
    export SC_PARAM_FORMAT="tty"
    SC_PARAM_PATTERN="*.fake"
    ShellCheck_Files
    # Test that 1 fake script was found
    [ $(wc -l /tmp/sc-input-files | awk '{print $1}') == 1 ]
}

# Esure Shellcheck command provides a failure if errors are found
@test "3: Shellcheck test - Fail on error" {
    export SC_PARAM_DIR="src/tests/test_data"
    export SC_PARAM_SEVERITY="style"
    export SC_PARAM_FORMAT="tty"
    ShellCheck_Files
    run Catch_SC_Errors
    [ "$status" == 1 ]
}

# Esure errors can be excluded
@test "4: Shellcheck test - Suppress errors" {
    export SC_PARAM_DIR="src/tests/test_data"
    export SC_PARAM_SEVERITY="style"
    export SC_PARAM_EXCLUDE="SC2006,SC2116,SC2034"
    export SC_PARAM_FORMAT="tty"
    ShellCheck_Files
    run Catch_SC_Errors
    [ "$status" == 0 ]
}

# Esure errors can be excluded
@test "5: Shellcheck test - Ignore directory list" {
    export SC_PARAM_DIR="src/tests/test_data"
    export SC_PARAM_IGNORE_DIRS="src/tests/ignore_test/ignore_path_1
    src/tests/ignore_test/ignore_path_2"
    export SC_PARAM_SEVERITY="style"
    export SC_PARAM_EXCLUDE="SC2006,SC2116,SC2034"
    export SC_PARAM_FORMAT="tty"
    ShellCheck_Files

    # Test that 1 script was found in test_data
    [ $(wc -l /tmp/sc-input-files | awk '{print $1}') == 1 ]
}