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
#  set -x PATH $PATH /usr/local/sbin
set LEGACY ~/Documents/Code/First_workspace/depot/qa/tests/products/DCinema/main # Dcinema legacy area
set DEMO ~/Documents/Code/First_workspace/depot/qa/tests/products/DCinema/main/demo 
set MUSE_MAIN ~/Documents/Code/museqa/devel/
set MUSE_105 ~/Documents/Code/museqa_rel_0.10.5/devel/
set CONTROLLER /Users/cjappl/Library/Application Support/Dolby DJ/Controller Mappings
set PERSONAL /Users/cjappl/Documents/Code/personal
set WORK_TRIALS /Users/cjappl/Documents/Code/work_trials

set EUROPA /Users/cjappl/Documents/Code/cjappl_europa_main/

set AU ~/Library/Audio/Plug-Ins/Components
set VST ~/Library/Audio/Plug-Ins/VST3
set AAX "/Library/Application Support/Avid/Audio/Plug-Ins/"

# P4 
#set -x P4USER 'cjappl'
#set -x P4PORT 'perforce:1666'
#set -x P4CLIENT 'cjappl_europa_main'
#set -x P4DIFF '/Applications/p4merge.app/Contents/MacOS/p4merge'

#set -x EDITOR 'nvim'

#######################################################################
# => Aliases and functions
#######################################################################

# grep for python files recursively from dir and lower
function greppy -a pattern dir
    rg $pattern --type py -H $dir 
end

function rh -a pattern 
    rg $pattern -g "!contrib/*" -g "!build*/*" -g "!MacOSX" -g "!tags" -g "!*.html" -g "!*.js" 
end

function coverage_run -a src_dir test_dir
    coverage run --source $src_dir -m py.test $test_dir -v
    coverage report -m --fail-under=100
end

function find_and_replace -a dir oldtext newtext
    #find $dir -type f -print0 | xargs -0 sed -i '' 's/$oldtext/$newtext/g'
    find $dir -type f -exec sed -i '' -e 's/$oldtext/$newtext/g' {} \;
end

alias .1 "cd .." 
alias .2 "cd ../.." 
alias .3 "cd ../../.." 
alias .4 "cd ../../../.." 
alias .5 "cd ../../../../.." 
alias .6 "cd ../../../../../.." 

alias makebuildtest "cmake .. && make && ctest ."

# finding my ip address
alias ip_addr "ifconfig en0 inet | grep inet"
alias vim /usr/local/bin/nvim

eval (python3.5 -m virtualfish auto_activation) 

# clear au cache
alias clear_au_cache "rm ~/Library/Caches/AudioUnitCache/com.apple.audiounits.cache"

#######################################################################
# => Remapping keys  
#######################################################################

# Enable ctrl + f for auto complete 
#https://github.com/fish-shell/fish-shell/issues/3541
function fish_user_key_bindings
    for mode in insert default visual
        bind -M $mode \cf forward-char
    end
end
