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
set OS_CLASS ~/Documents/Code/operating_systems

set EUROPA /Users/cjappl/Documents/Code/cjappl_europa_main/

set AU ~/Library/Audio/Plug-Ins/Components
set VST ~/Library/Audio/Plug-Ins/VST3
set AAX "/Library/Application Support/Avid/Audio/Plug-Ins/"

# P4 
set -x P4USER 'cjappl'
set -x P4PORT 'perforce:1666'
set -x P4CLIENT 'cjappl_europa_main'
set -x P4DIFF 'nvim -d'
set -x EDITOR 'nvim'
set -x P4MERGE '/Applications/p4merge.app/Contents/MacOS/p4merge'

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

alias makebuildtest "cmake .. && cmake --build . && ctest . -C Debug -VV"

# finding my ip address
alias ip_addr "ifconfig en0 inet | grep inet"
alias vim /usr/local/bin/nvim

eval (python3.5 -m virtualfish auto_activation) 

# clear au cache
alias clear_au_cache "rm ~/Library/Caches/AudioUnitCache/com.apple.audiounits.cache"

#######################################################################
# => Utility functions
#######################################################################

# Enable ctrl + f for auto complete 
#https://github.com/fish-shell/fish-shell/issues/3541
function fish_user_key_bindings
    for mode in insert default visual
        bind -M $mode \cf forward-char
    end
end

function please
  if count $argv > /dev/null
    if [ $history[$argv[1]] = "please" ]
      please (math $argv[1] + 1)
    else
      eval command sudo $history[$argv[1]]
    end
  else
    please 1
  end
end

#######################################################################
# => Fzf functions 
#######################################################################

#set -x FZF_DEFAULT_COMMAND 'rg --files 2> /dev/null'
set -x FZF_CTRL_T_OPTS '--height=70% --preview="cat {} 2> /dev/null" --preview-window=right:60%:wrap'

function fcd
    if set -q argv[1]
        set searchdir $argv[1]
    else
        set searchdir $HOME
    end

    # https://github.com/fish-shell/fish-shell/issues/1362
    set -l tmpfile (mktemp)
    #rg --hidden --files -g "!*tox"  $searchdir 2> /dev/null | xargs -I {} dirname {} | uniq | fzf > $tmpfile
    find $searchdir \( ! -regex '.*/\..*' \) ! -name __pycache__ -type d  2> /dev/null | fzf > $tmpfile
    set -l destdir (cat $tmpfile)
    rm -f $tmpfile

    if test -z "$destdir"
        return 1
    end

    cd $destdir
end

function fkill --description "Kill processes"
  set -l __fkill__pid (ps -ef | sed 1d | eval "fzf $FZF_DEFAULT_OPTS -m --header='[kill:process]'" | awk '{print $2}')
  set -l __fkill__kc $argv[1]

  if test "x$__fkill__pid" != "x"
    if test "x$argv[1]" != "x"
      echo $__fkill__pid | xargs kill $argv[1]
    else
      echo $__fkill__pid | xargs kill -9
    end
    fkill
  end
end
