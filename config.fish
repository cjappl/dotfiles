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
set -x PERSONAL ~/code/personal/
set -x DOTFILES ~/dotfiles/
set -x CONTRIB_PATH ~/git/contrib2/

set -x ENGINE ~/git/game-engine/
set -x FLAG ~/git/fflag-config

set PERFORCE ~/Perforce

set AU ~/Library/Audio/Plug-Ins/Components
set VST ~/Library/Audio/Plug-Ins/VST3
set AAX "/Library/Application Support/Avid/Audio/Plug-Ins/"

# PATH
set PATH "$CONTRIB_PATH/cmake/cmake-3.18.2-Darwin-x86_64/CMake.app/Contents/bin" "$ENGINE/Tools/Util" $PATH

# P4 
set -x P4USER '$USER'
set -x P4PORT 'perforce:1666'
set -x P4CLIENT ''
set -x P4DIFF 'nvim -d'
set -x EDITOR 'nvim'
set -x P4MERGE '/Applications/p4merge.app/Contents/MacOS/p4merge'

set -x RIPGREP_CONFIG_PATH (echo $HOME'/.ripgreprc')

#######################################################################
# => Aliases and functions
#######################################################################


function rh -a pattern 
    rg -g "!qa/*" -g "!Darwin/*" -g "!contrib/*" -g "!build/*" -g "!MacOSX" -g "!*.html" -g "!*.js" "Client.LegacyAssemblies/*" $pattern
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

function makeBuildTestEuropa -a generator config

    if test "$generator" = "Xcode"
        set extra_build_flags "-quiet"
    end

    cmake .. -G $generator -DCMAKE_BUILD_TYPE=$config -DRUN_AUVAL_OVER_HTTP=ON &&
    cmake --build . --config $config -- $extra_build_flags &&
    ctest . -C $config -j 4 --output-on-failure

    tput bel
end

function generateEngine -a generator
    python3 Client/cmake/configure.py --noopt --x64 --$generator
end

function testEngine -a generator
    python3 Client/cmake/configure.py --noopt --x64 --$generator --common-tests --target App.UnitTest.Run
end

function flipFlag -a flagName
    if test -z $flagName
        echo "No flag name passed"
        return
    end

    set fname flags/capple/$flagName.json
    cd $FLAG

    git checkout master &&
    git pull > /dev/null &&
    git checkout -b capple/flip-$flagName &&
    cp simple_example.json $fname

end

function flipFlagCommit -a flagName
    set fname flags/capple/$flagName.json
    flipFlag $flagName

    git add $fname &&
    git commit -m "Setting $flagName True on Common" &&
    git push
end

# Open the Pull Request URL for your current directory's branch (base branch defaults to master)
function openpr
  set github_url (git remote -v | awk '/fetch/{print $2}' | sed -Ee 's#(git@|git://)#https://#' -e 's@com:@com/@' -e 's%\.git$%%' | awk '/github/')
  set branch_name (git symbolic-ref HEAD | cut -d"/" -f 3,4)
  set pr_url $github_url[1]"/pull/new/"$branch_name
  open $pr_url
end

# Run git push and then immediately open the Pull Request URL
function gpr
  git push origin HEAD

  if test $status -eq 0 
    openpr
  else
    echo 'failed to push commits and open a pull request.';
  end
end

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
    set -l _plugin_paths "/Users/$USER/Library/Audio/Plug-Ins/Components/Dolby"* "/Library/Audio/Plug-Ins/Components/Dolby"* "/Users/$USER/Library/Audio/Plug-Ins/VST3/Dolby"* "/Library/Audio/Plug-Ins/VST3/Dolby"* "/Library/Application Support/Avid/Audio/Plug-Ins/Dolby"* "/Users/$USER/Music/Ableton/User Library/Templates/"* "/Users/$USER/Library/Preferences/Nuendo 10/Project Templates/Dolby Atmos Music/"* "/Users/$USER/Library/Preferences/Cubase 10/Project Templates/Dolby Atmos Music/"* "/Users/$USER/Documents/Pro Tools/Session Templates/Dolby Atmos Music/"* "/Users/$USER/Music/Audio Music Apps/Project Templates/"* "/Users/$USER/Documents/Pro Tools/IO Settings/"*

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
    set -l _plugin_paths "/Users/$USER/Library/Audio/Plug-Ins/Components/Dolby"* "/Library/Audio/Plug-Ins/Components/Dolby"* "/Users/$USER/Library/Audio/Plug-Ins/VST3/Dolby"* "/Library/Audio/Plug-Ins/VST3/Dolby"* "/Library/Application Support/Avid/Audio/Plug-Ins/Dolby"* "/Users/$USER/Music/Ableton/User Library/Templates/"* "/Users/$USER/Library/Preferences/Nuendo 10/Project Templates/Dolby Atmos Music/"* "/Users/$USER/Library/Preferences/Cubase 10/Project Templates/Dolby Atmos Music/"* "/Users/$USER/Documents/Pro Tools/Session Templates/Dolby Atmos Music/"* "/Users/$USER/Music/Audio Music Apps/Project Templates/"* "/Users/$USER/Documents/Pro Tools/IO Settings/"*

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
