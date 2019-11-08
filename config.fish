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
set PERSONAL ~/Documents/Code/personal
set WORK_TRIALS ~/Documents/Code/work_trials
set OS_CLASS /Users/cjappl/Documents/Code/operating_systems/csci-e-92-cjappl/cjappl_workspace/CJAPPL_OS_2/Sources
set DOTFILES ~/dotfiles

set MUSE_MAIN ~/Documents/Code/museqa/devel/

set EUROPA ~/Documents/Code/cjappl_europa_main/
set EUROPA_PANNER_01 ~/Documents/Code/cjappl_europa_panner_01

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

function rgpy -a pattern dir
    rg $pattern --type py -H $dir 
end

function rgcpp -a pattern dir
    rg $pattern --type cpp -H $dir 
end

function rh -a pattern 
    rg $pattern -g "!contrib/*" -g "!build*/*" -g "!MacOSX" -g "!tags" -g "!*.html" -g "!*.js" --smart-case --pretty --line-number
end

function coverage_run -a src_dir test_dir
    coverage run --source $src_dir -m py.test $test_dir -v
    coverage report -m --fail-under=100
end

function find_and_replace -a oldtext newtext dir
    if set -q $dir 
        set dir "."
    end
    rg -l "$oldtext" -0 $dir | xargs -p -0 sed -i '' -e "s/$oldtext/$newtext/g"
end

alias .2 "cd ../.." 
alias .3 "cd ../../.." 
alias .4 "cd ../../../.." 
alias .5 "cd ../../../../.." 
alias .6 "cd ../../../../../.." 

alias makebuildtestrelease "cmake .. -DCMAKE_BUILD_TYPE=Release && cmake --build . && ctest . -C Debug -VV"
alias makebuildtestdebug "cmake .. -DCMAKE_BUILD_TYPE=Debug && cmake --build . && ctest . -C Debug -VV"

# finding my ip address
alias ip_addr "ifconfig en0 inet | grep inet"

#setting vim to start nvim
alias vim /usr/local/bin/nvim

eval (python3 -m virtualfish auto_activation) 

# clear au cache
alias clear_au_cache "rm ~/Library/Caches/AudioUnitCache/com.apple.audiounits.cache"

#######################################################################
# => Utility functions
#######################################################################

function fish_user_key_bindings
    for mode in insert default visual
        # Enable ctrl + f for auto complete 
        # Fish issue 3541
        bind -M $mode \cf forward-char
    end

    fzf_key_bindings

end

# sudo run last command
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
# => Fzf 
#######################################################################

source $PERSONAL/cjappl_forgit/forgit/forgit.plugin.fish

set -x FZF_DEFAULT_COMMAND 'rg --files 2> /dev/null'
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


set -x fish_color_user d7ff87
set -x fish_color_cwd ff6b2d
#set -x fish_color_host 2f99d4
set -x fish_color_host 2f99d4
set -x fish_color_operator $fish_color_user 

# More prompt configuration 
function fish_mode_prompt
  switch $fish_bind_mode
    case default
      set_color --bold $fish_color_cwd 
      echo '[N]'
    case insert
      set_color --bold $fish_color_host 
      echo '[I]'
    case replace_one
      set_color --bold green
      echo '[R]'
    case visual
      set_color --bold brmagenta
      echo '[V]'
    case '*'
      set_color --bold red
      echo '[?]'
  end
  set_color white 
  echo '|'
  set_color normal
end
