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
set PERSONAL ~/code/personal/
set DOTFILES ~/dotfiles/

set SPATIAL ~/code/spatial/
set SPATIAL_API ~/code/spatial-openapi/
set ENV staging 

set PERFORCE ~/Perforce

set AU ~/Library/Audio/Plug-Ins/Components
set VST ~/Library/Audio/Plug-Ins/VST3
set AAX "/Library/Application Support/Avid/Audio/Plug-Ins/"

set -x RIPGREP_CONFIG_PATH (echo $HOME'/.ripgreprc')


#######################################################################
# => Aliases and functions
#######################################################################

function rh -a pattern  --wraps "rg"
    rg -g "!tps/*" -g "!windows/*" -g "!bin/*" -g "!lib/*" -g "!build/*" -g "!*.xcodeproj" $pattern
end

function rgcmake --wraps "rg"
    rg --type cmake $argv
end

function rgcpp --wraps "rg"
    rg --type cpp $argv
end

function rgpy  --wraps "rg"
    rg --type py $argv 
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

alias gsc "git switch --create"

function mergemain
    set original_branch (git rev-parse --abbrev-ref HEAD)
    if test $original_branch = "main"
        return
    end
    echo "Updating main" && git switch main > /dev/null && git pull upstream main > /dev/null && 
    echo "Merging to branch" $original_branch && git switch $original_branch > /dev/null && git merge main --no-edit > /dev/null
    git status 
end

function convertWavMp3 -a folder
   for file in {$folder}/*.wav
       set rootname (echo $file | sed 's/\.[^.]*$//')
       lame -b 320 -h "$file" "$rootname.mp3"
   end
end

set SpatialBinDir $SPATIAL/build/bin/
set SpatialFlockNumber 122333

function releaseClientCommand 
    $SpatialBinDir/splclient -f $SpatialFlockNumber $argv
end

function runDaemon
    $SPATIAL/build/bin/spldaemon $SPATIAL/app/daemon.cfg ~/daemoncfgs/capple.cfg
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

set -x CLANG_FORMAT_DIFF /opt/homebrew/Cellar/clang-format/14.0.0/share/clang/clang-format-diff.py

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

set fish_greeting ""

fish_vi_key_bindings
eval "$(/opt/homebrew/bin/brew shellenv)"

######## # Colors for less manpage
set default $(tput sgr0)
set red $(tput setaf 1)
set green $(tput setaf 2)
set purple $(tput setaf 5)
set orange $(tput setaf 9)

# Less colors for man pages
set -x PAGER less
# Begin blinking
set -x LESS_TERMCAP_mb $red
# Begin bold
set -x LESS_TERMCAP_md $orange
# End mode
set -x LESS_TERMCAP_me $default
# End standout-mode
set -x LESS_TERMCAP_se $default
# Begin standout-mode - info box
set -x LESS_TERMCAP_so $purple
# End underline
set -x LESS_TERMCAP_ue $default
# Begin underline
set -x LESS_TERMCAP_us $green

# set folders to be teal for fish ls
set -Ux LSCOLORS gxfxbEaEBxxEhEhBaDaCaD
