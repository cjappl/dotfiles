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

set SPATIAL ~/code/spatial
set SPATIAL_API ~/code/spatial-openapi
set ENV staging 

set PERFORCE ~/Perforce

set AU ~/Library/Audio/Plug-Ins/Components
set VST ~/Library/Audio/Plug-Ins/VST3
set AAX "/Library/Application Support/Avid/Audio/Plug-Ins/"

set -x RIPGREP_CONFIG_PATH (echo $HOME'/.ripgreprc')

set -x EDITOR (which nvim)

fish_add_path $HOME/.cargo/bin/
fish_add_path $HOME/code/splbootstrap/bin/
fish_add_path $HOME/go/bin/

set -x HOMEBREW_NO_ANALYTICS 1

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

function getparentbranchname
    set current_branch_name (git rev-parse --abbrev-ref HEAD)
    set parent_branch_name (git show-branch -a 2>/dev/null \
      | grep '\*' \
      | grep -v $current_branch_name \
      | head -n1 \
      | perl -ple 's/\[[A-Za-z]+-\d+\][^\]]+$//; s/^.*\[([^~^\]]+).*$/$1/')

    echo $parent_branch_name
end

# Open the Pull Request URL for your current directory's branch, merges by default against the current branch's parent 
function openpr
  set github_url (git remote -v | awk '/fetch/{print $2}' | sed -Ee 's#(git@|git://)#https://#' -e 's@com:@com/@' -e 's%\.git$%%' | awk '/github/')
  set current_branch_name (git rev-parse --abbrev-ref HEAD)
  # https://gist.github.com/joechrysler/6073741
  set parent_branch_name (getparentbranchname)
  # https://github.com/spatiallabs/spatial/compare/release-8.4...merge-PLAT-1234?expand=1
  set pr_url $github_url[1]"/compare/$parent_branch_name...$current_branch_name?expand=1"
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


set FLOCK 122333

function releaseClientCommand 
    set_color brgreen
    echo $SPATIAL/build/bin/splclient -f $FLOCK $argv
    set_color normal

    #$SPATIAL/build/bin/splclient -f $FLOCK $argv 2>&1 | grep -E "got network instruction response|CRIT|WARN" | grep -v "permissions" | jq '{message}'
    $SPATIAL/build/bin/splclient -f $FLOCK $argv 2>&1 | jq 'select(.eventname == "instruction.responserecieved") | {timestamp, eventname, status}'
end

function releaseClientLoadsceneStart -a scenename
    releaseClientCommand loadscene $scenename "" "" "" "" true 
end

function runDaemon
    $SPATIAL/build/bin/spldaemon $SPATIAL/app/daemon.cfg ~/daemoncfgs/capple.cfg
end

function merge_to_release -a VERSION COMMIT
    cd $SPATIAL
    git checkout release-$VERSION-publish
    and git pull

    if test $status -ne 0
        return $status
    end

    set JIRA (git log --oneline $COMMIT | head -1 | string match --regex --groups-only "\[(PLAT-.*)\]")

    if test -n "$JIRA"
        set MERGE_BRANCH = "merge-$JIRA-$VERSION"
    else
        echo "Jira ticket not found in commit, faling back to SHA"
        set MERGE_BRANCH = "merge-$COMMIT-$VERSION"
    end

    git switch --create $MERGE_BRANCH
    and git cherry-pick $COMMIT
    and gpr
    and git checkout main
    git branch --delete $MERGE_BRANCH

    return $status
end

function create_release_branch -a OLD_VERSION NEW_VERSION
    cd $SPATIAL
    git checkout main
    and git pull

    # sanity check you didn't mess it up
    set FOUND_OLD_VERSION ($SPATIAL/scripts/extract-runtime-version.sh)
    if not string match -q "$FOUND_OLD_VERSION" "$OLD_VERSION"
        echo "Specified old version ($OLD_VERSION) does not match found old version ($FOUND_OLD_VERSION)" 2>&1
        return 1
    end

    set USER_RESPONSE = ""

    set NEW_RELEASE_BRANCH "release-$NEW_VERSION-publish"
    while not string match -q "$USER_RESPONSE" "y"; and not string match -q "$USER_RESPONSE" "n"
        read --prompt-str "Create new release branch $NEW_RELEASE_BRANCH? [y/n] > " USER_RESPONSE

        if test $status -ne 0
            return $status
        end
    end

    if string match -q "$USER_RESPONSE" "n"
        return 0
    end

    echo "Please increase splversion to match the provided new version"
    sleep 1 
    nvim $SPATIAL/include/splversions.h +16
    if test $status -ne 0
        return $status
    end

    set FOUND_NEW_VERSION ($SPATIAL/scripts/extract-runtime-version.sh)
    if not string match -q "$FOUND_NEW_VERSION" "$NEW_VERSION"
        echo "Specified new version ($NEW_VERSION) does not match found new version ($FOUND_NEW_VERSION)" 2>&1
        return 1
    end

    git switch --create $NEW_RELEASE_BRANCH
    and git push

    if test $status -ne 0
        return $status
    end

    set BUMP_BRANCH "bumpmain-$NEW_VERSION"
    git checkout main
    and git switch --create "$BUMP_BRANCH"
    and git add $SPATIAL/include/splversions.h
    and git commit -m "BUMP MAIN VERSION - $NEW_VERSION"
    and gpr
    and git branch --delete "$BUMP_BRANCH"
end

# finding my ip address
alias ip_addr "ifconfig en0 inet | grep inet"

#setting vim to start nvim
alias vim nvim

#eval (python3 -m virtualfish) 

# clear au cache
alias clear_au_cache "rm ~/Library/Caches/AudioUnitCache/com.apple.audiounits.cache && rm ~/Library/Preferences/com.apple.audio.InfoHelper.plist"

alias ls lsd

alias tabonly "tmux kill-window -a && tmux movew -r"

[ -f /opt/homebrew/share/autojump/autojump.fish ]; and source /opt/homebrew/share/autojump/autojump.fish

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

# copy the !! functionality of other shells
function last_history_item; echo $history[1]; end
abbr -a !! --position anywhere --function last_history_item

#######################################################################
# => Fzf 
#######################################################################

#set -x FORGIT_FZF_DEFAULT_OPTS "$FORGIT_FZF_DEFAULT_OPTS --layout=reverse-list --preview-window='down:80%' --height='90%'"
set -x FORGIT_FZF_DEFAULT_OPTS "$FORGIT_FZF_DEFAULT_OPTS --layout=reverse-list"
source $PERSONAL/forgit/conf.d/forgit.plugin.fish

set -x FZF_DEFAULT_COMMAND "fd --color=always --exclude .git . \$dir"
set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -x FZF_CTRL_T_OPTS '--preview="bat --color=always --number {} 2> /dev/null" --height=80% --preview-window=right:60%:wrap'
set -x FZF_DEFAULT_OPTS "--ansi"

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

  set_color ED7440
  echo (date +%H:%M)

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

thefuck --alias | source

source ~/.config/fish/spatial_secrets.fish


# Use forgit diff on stash enter
set -x FORGIT_STASH_ENTER_COMMAND 'echo {} | cut -d: -f1 | xargs -I % git forgit diff %^1 %'

# Pop stash on alt-enter
set -x FORGIT_STASH_POP_COMMAND 'echo {} | cut -d: -f1 | xargs -I % git stash pop %'

# Drop stash on alt-backspace
set -x FORGIT_STASH_DROP_COMMAND 'echo {} | cut -d: -f1 | xargs -I % git stash drop %'

set -x FORGIT_STASH_FZF_OPTS "
	--bind='enter:execute($FORGIT_STASH_ENTER_COMMAND)'
	--bind='ctrl-a:execute($FORGIT_STASH_POP_COMMAND)+accept'
	--bind='ctrl-x:execute($FORGIT_STASH_DROP_COMMAND)+reload(git stash list)'
	--prompt='[ENTER] show   [CTRL+a] pop   [CTRL+x] drop > '
"
