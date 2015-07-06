if(NOT WIN32)
    string(ASCII 27 Esc)
    set(COLOR_RESET "${Esc}[m")
    set(COLOR_RED "${Esc}[31m")
    set(COLOR_GREEN "${Esc}[32m")
    set(COLOR_YELLOW "${Esc}[33m")
endif()

function(log_success)
    message(STATUS "${COLOR_GREEN}${ARGV}${COLOR_RESET}")
endfunction()

function(log_warning)
    message(WARNING "${COLOR_YELLOW}${ARGV}${COLOR_RESET}")
endfunction()

function(log_error)
    message(SEND_ERROR "${COLOR_RED}${ARGV}${COLOR_RESET}")
endfunction()
