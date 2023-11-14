#!/bin/bash

FAILED_TESTS=()

perform_test() {
    test_description=$1
    command=$2

    echo "Starting test: $test_description"
    if eval "$command"; then
        echo "Test passed: $test_description"
    else
        echo "Test failed: $test_description"
        FAILED_TESTS+=("$test_description")
    fi
    echo "----------------------------------------"
}

log_failed_tests() {
    if [ ${#FAILED_TESTS[@]} -eq 0 ]; then
        echo "All tests passed successfully."
    else
        echo "The following tests failed:"
        for test in "${FAILED_TESTS[@]}"; do
            echo "- $test"
        done
        return 1
    fi
}