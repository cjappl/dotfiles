#######################################################################
# CJAPPL fish_config 
#######################################################################
#                        .OO
#                       .OOOO
#                      .OOOO'
#                      OOOO'          .-~~~~-.
#                      OOO'          /   (o)(o)
#              .OOOOOO `O .OOOOOOO. /      .. |
#          .OOOOOOOOOOOO OOOOOOOOOO/\    \____/
#        .OOOOOOOOOOOOOOOOOOOOOOOO/ \\   ,\_/
#       .OOOOOOO%%OOOOOOOOOOOOO(#/\     /.
#      .OOOOOO%%%OOOOOOOOOOOOOOO\ \\  \/OO.
#     .OOOOO%%%%OOOOOOOOOOOOOOOOO\   \/OOOO.
#     OOOOO%%%%OOOOOOOOOOOOOOOOOOO\_\/\OOOOO
#     OOOOO%%%OOOOOOOOOOOOOOOOOOOOO\###)OOOO
#     OOOOOO%%OOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
#     OOOOOOO%OOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
#     `OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
#   .-~~\OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
#  / _/  `\(#\OOOOOOOOOOOOOOOOOOOOOOOOOOOO'
# / / \  / `~~\OOOOOOOOOOOOOOOOOOOOOOOOOO'
#|/'  `\//  \\ \OOOOOOOOOOOOOOOOOOOOOOOO'
#       `-.__\_,\OOOOOOOOOOOOOOOOOOOOO'
#           `OO\#)OOOOOOOOOOOOOOOOOOO'
#             `OOOOOOOOO''OOOOOOOOO'
#               `""""""'  `""""""'
#######################################################################

#######################################################################
# => Environment variables
#######################################################################

# remote logins (ssh)

# PATHS (cd)
set -x PATH $PATH /usr/local/sbin
set LEGACY ~/Documents/Code/First_workspace/depot/qa/tests/products/DCinema/main # Dcinema legacy area
set DEMO ~/Documents/Code/First_workspace/depot/qa/tests/products/DCinema/main/demo 
set MUSE ~/Documents/Code/museqa/devel/dj/sys-test
set MUSE_MAIN ~/Documents/Code/museqa/
set CONTROLLER "/Users/cjappl/Library/Application Support/Dolby DJ/Controller Mappings"
set PERSONAL /Users/cjappl/Documents/Code/personal

# P4 
set -x P4USER 'cjappl'
set -x P4PORT 'perforce:1666'
set -x P4CLIENT 'cjappl_CJAPPL-MBP_2200'
set -x P4DIFF '/Applications/p4merge.app/Contents/MacOS/p4merge'

set -x EDITOR 'vim'
#######################################################################
# => Aliases and functions
#######################################################################

# grep for python files recursively from dir and lower
function greppy -a pattern dir
    rg $pattern --type py -H $dir 
end

function coverage_run -a src_dir test_dir
    coverage run --source $src_dir -m py.test $test_dir -v
    coverage report -m --fail-under=100
end

alias .1 "cd .." 
alias .2 "cd ../.." 
alias .3 "cd ../../.." 
alias .4 "cd ../../../.." 
alias .5 "cd ../../../../.." 
alias .6 "cd ../../../../../.." 

# finding my ip address
alias ip_addr "ifconfig en0 inet | grep inet"

eval (python3 -m virtualfish auto_activation) 2> /dev/null

