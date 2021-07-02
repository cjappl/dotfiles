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
#
#######################################################################

#######################################################################
# => Environment variables
#######################################################################

# remote logins (ssh)

# PATHS (cd)
set PERSONAL ~/Code/personal
set WORK_TRIALS ~/Code/work
set DOTFILES ~/dotfiles

set EUROPA ~/Documents/Code/cjappl_europa_main/
set PERFORCE ~/Perforce
set BUS ~/Documents/Code/atmos-bus-dynamics/

set AU ~/Library/Audio/Plug-Ins/Components
set VST ~/Library/Audio/Plug-Ins/VST3
set AAX "/Library/Application Support/Avid/Audio/Plug-Ins/"

# P4 
set -x P4USER 'cjappl'
set -x P4PORT 'perforce:1666'
set -x P4CLIENT 'cjappl_europa_dabs_1_0_new'
set -x P4DIFF 'nvim -d'
set -x EDITOR 'nvim'
set -x P4MERGE '/Applications/p4merge.app/Contents/MacOS/p4merge'


set -x RIPGREP_CONFIG_PATH '/Users/cjappl/.ripgreprc'

#set -x SDK_ROOT (xcrun --sdk macosx --show-sdk-path) 2> /dev/null 1>&2
#set -x SDKROOT (xcrun --sdk macosx --show-sdk-path) 2> /dev/null 1>&2

#######################################################################
# => Aliases and functions
#######################################################################


function rh -a pattern 
    rg $pattern -g "!qa/*" -g "!Darwin/*" -g "!contrib/*" -g "!build*/*" -g "!MacOSX" -g "!*.html" -g "!*.js" $argv
end

function rgcmake
    rg --type cmake $argv
end

function rgcpp
    rg --type cpp $argv
end

function rgpy 
    rg --type py $argv 
end


function coverage_run -a src_dir test_dir
    coverage run --source $src_dir -m py.test $test_dir -v
    coverage report -m --fail-under=100
end

function makeBuildTestEuropa -a generator config

    if test "$generator" = "Xcode"
        set extra_build_flags "-quiet"
    end

    cmake .. -G $generator -DCMAKE_BUILD_TYPE=$config -DRUN_AUVAL_OVER_HTTP=ON &&
    cmake --build . --config $config -- $extra_build_flags &&
    ctest . -C $config -j 4 --output-on-failure

    tput bel
end

set -x CTEST_PARALLEL_LEVEL 4

# finding my ip address
alias ip_addr "ifconfig en0 inet | grep inet"

#setting vim to start nvim
alias vim nvim

#eval (python3 -m virtualfish) 

# clear au cache
alias clear_au_cache "rm ~/Library/Caches/AudioUnitCache/com.apple.audiounits.cache && rm ~/Library/Preferences/com.apple.audio.InfoHelper.plist"

alias cat bat

alias tabonly "tmux kill-window -a"

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

source $PERSONAL/forgit/conf.d/forgit.plugin.fish

set -x FZF_DEFAULT_COMMAND 'rg --files 2> /dev/null'
set -x FZF_CTRL_T_OPTS '--preview="cat {} 2> /dev/null" --preview-window=right:60%:wrap'

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

set FORGIT_FZF_DEFAULT_OPTS "$FORGIT_FZF_DEFAULT_OPTS --layout=reverse-list"

#######################################################################
# => colors 
#######################################################################

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
set -g fish_user_paths "/usr/local/opt/ruby/bin" $fish_user_paths


function remove_europa_plugins
    set -l _plugin_paths "/Users/cjappl/Library/Audio/Plug-Ins/Components/Dolby"* "/Library/Audio/Plug-Ins/Components/Dolby"* "/Users/cjappl/Library/Audio/Plug-Ins/VST3/Dolby"* "/Library/Audio/Plug-Ins/VST3/Dolby"* "/Library/Application Support/Avid/Audio/Plug-Ins/Dolby"* "/Users/cjappl/Music/Ableton/User Library/Templates/"* "/Users/cjappl/Library/Preferences/Nuendo 10/Project Templates/Dolby Atmos Music/"* "/Users/cjappl/Library/Preferences/Cubase 10/Project Templates/Dolby Atmos Music/"* "/Users/cjappl/Documents/Pro Tools/Session Templates/Dolby Atmos Music/"* "/Users/cjappl/Music/Audio Music Apps/Project Templates/"* "/Users/cjappl/Documents/Pro Tools/IO Settings/"*

    if test -z "$_plugin_paths"
        echo "Nothing installed"
        return
    end
    
    for path in $_plugin_paths
        if test -e $path
            echo "REMOVING " $path
            sudo rm -rf $path 
        else
            echo "NOT FOUND " $path 
        end
    end
end

function list_europa_plugins
    set -l _plugin_paths "/Users/cjappl/Library/Audio/Plug-Ins/Components/Dolby"* "/Library/Audio/Plug-Ins/Components/Dolby"* "/Users/cjappl/Library/Audio/Plug-Ins/VST3/Dolby"* "/Library/Audio/Plug-Ins/VST3/Dolby"* "/Library/Application Support/Avid/Audio/Plug-Ins/Dolby"* "/Users/cjappl/Music/Ableton/User Library/Templates/"* "/Users/cjappl/Library/Preferences/Nuendo 10/Project Templates/Dolby Atmos Music/"* "/Users/cjappl/Library/Preferences/Cubase 10/Project Templates/Dolby Atmos Music/"* "/Users/cjappl/Documents/Pro Tools/Session Templates/Dolby Atmos Music/"* "/Users/cjappl/Music/Audio Music Apps/Project Templates/"* "/Users/cjappl/Documents/Pro Tools/IO Settings/"*

    for path in $_plugin_paths
        echo $path 
    end
end

# settings library and include paths to look in the usr/local dir
# necessary for pyliblo https://github.com/dsacre/pyliblo/issues/3
set -gx C_INCLUDE_PATH /usr/local/include $C_INCLUDE_PATH
set -gx LIBRARY_PATH /usr/local/lib $LIBRARY_PATH

set fish_greeting ""

fish_vi_key_bindings
