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

set BREW /opt/homebrew/bin/brew

eval ($BREW shellenv)

if test -d (brew --prefix)"/share/fish/completions"
    set -p fish_complete_path (brew --prefix)/share/fish/completions
end

if test -d (brew --prefix)"/share/fish/vendor_completions.d"
    set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
end

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

set -x RIPGREP_CONFIG_PATH (echo $HOME'/.ripgreprc')

set -x EDITOR (which nvim)

set -x HOMEBREW_NO_ANALYTICS 1

set TOOLROOT_PI /Volumes/xtool-build-env/crosstools_workspace/armv8-rpi3-linux-gnueabihf/

set -x CMAKE_CXX_COMPILER_LAUNCHER ccache
#set -x CCACHE_BASEDIR $SPATIAL
set -x CCACHE_MAXSIZE 10G

set -x OBSIDIAN "/Users/topher/Library/CloudStorage/ProtonDrive-christopher.j.apple@pm.me/Personal MBP/Obsidian/main_vault"

#######################################################################
# => Aliases and functions
#######################################################################

alias lg "lazygit"

alias rclang "/Users/topher/code/radsan_cjappl/build/bin/clang"
alias rclang++ "/Users/topher/code/radsan_cjappl/build/bin/clang++"

function rgcmake --wraps "rg"
    rg --type cmake $argv
end

function rgcpp --wraps "rg"
    rg --type cpp $argv
end

function rgpy  --wraps "rg"
    rg --type py $argv 
end

function fdi --wraps "fd"
    fd --no-ignore $argv
end

function rgi --wraps "rg"
    rg --no-ignore $argv
end

function getparentbranchname
    set current_branch_name (git rev-parse --abbrev-ref HEAD)
    set parent_branch_name (git show-branch -a 2>/dev/null \
      | grep '\*' \
      | grep -v $current_branch_name \
      | head -n1 \
      | grep -o '\[[^]]*\]' \
      | head -1 \
      | tr -d '[]')

    echo $parent_branch_name
end

# Open the Pull Request URL for your current directory's branch, merges by default against the current branch's parent 
function openpr
    set github_url (git remote -v | grep 'origin.*fetch' | awk '{print $2}' | sed -Ee 's#(git@|git://)#https://#' -e 's@com:@com/@' -e 's%\.git$%%' | awk '/github/')
    set current_branch_name (git rev-parse --abbrev-ref HEAD)
    # https://gist.github.com/joechrysler/6073741
    set parent_branch_name (getparentbranchname)
    # https://github.com/spatiallabs/spatial/compare/release-8.4...merge-PLAT-1234?expand=1
    set pr_url $github_url"/compare/$parent_branch_name...$current_branch_name?expand=1"
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

# finding my ip address
alias ip_addr "ifconfig en0 inet | grep inet"

#setting vim to start nvim
alias vim nvim

# clear au cache
alias clear_au_cache "rm ~/Library/Caches/AudioUnitCache/com.apple.audiounits.cache && rm ~/Library/Preferences/com.apple.audio.InfoHelper.plist"

alias ls lsd

alias tabonly "tmux kill-window -a && tmux movew -r"

[ -f $HOMEBREW_PREFIX/share/autojump/autojump.fish ]; and source $HOMEBREW_PREFIX/share/autojump/autojump.fish 

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

set -x FORGIT_FZF_DEFAULT_OPTS "$FORGIT_FZF_DEFAULT_OPTS --layout=reverse-list"
source $HOME/code/forgit/conf.d/forgit.plugin.fish

#[ -f $HOMEBREW_PREFIX/share/forgit/forgit.plugin.fish ]; and source $HOMEBREW_PREFIX/share/forgit/forgit.plugin.fish

set -x FZF_DEFAULT_COMMAND "fd --color=always --exclude .git --type file . \$dir"
set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -x FZF_CTRL_T_OPTS '--preview="bat --color=always --number {} 2> /dev/null" --height=80% --preview-window=right:60%:wrap'
set -x FZF_DEFAULT_OPTS "--ansi"

#######################################################################
# => Rust
#######################################################################

[ -d $HOME/.cargo/bin ]; and fish_add_path $HOME/.cargo/bin

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
  echo ' '
  set_color normal
end

#set __fish_git_prompt_show_informative_status true
set __fish_git_prompt_showdirtystate true
set __fish_git_prompt_showuntrackedfiles true

set -x VIRTUAL_ENV_DISABLE_PROMPT true

function fish_prompt -d "Write out the prompt"

    if set -q VIRTUAL_ENV
        echo -n -s (set_color white) "(" (basename "$VIRTUAL_ENV") ")" (set_color normal) " "
    end

    # This shows up as /home/user/ (master *)>, with the directory colored
    printf '%s%s' (set_color $fish_color_cwd) (prompt_pwd)

    set_color normal 

    fish_git_prompt

    set_color aacf9f
    printf '> ' 

    set_color normal

end

set -g fish_user_paths "/usr/local/opt/ruby/bin" $fish_user_paths

set fish_greeting ""

fish_vi_key_bindings

######## # Colors for less manpage
set default (tput sgr0)
set red (tput setaf 1)
set green (tput setaf 2)
set purple (tput setaf 5)
set orange (tput setaf 9)


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
	--prompt='[ENTER] show   [CTRL+a] pop   [CTRL+x] drop > '"


function llvm_clang_tidy --wraps "clang-tidy" --argument-names file fix
    set clang_tidy_cmd "$HOME/code/radsan_cjappl/build/bin/clang-tidy --config-file=$HOME/code/radsan_cjappl/llvm-project/.clang-tidy -p $HOME/code/radsan_cjappl/build/"
    
    if test "$fix" = "--fix"
        set clang_tidy_cmd "$clang_tidy_cmd --fix --fix-errors"
    end

    eval $clang_tidy_cmd $file
end

function clang_tidy_diff --wraps "clang-tidy-diff.py" --description 'Run clang-tidy-diff.py on a given branch or diff file'
    argparse 'b/branch=' 'd/diff-file=' -- $argv
    or return

    set clang_tidy_binary "$HOME/code/radsan_cjappl/build/bin/clang-tidy"
    set config_file "$HOME/code/radsan_cjappl/llvm-project/.clang-tidy"
    set clang_tidy_diff "$HOME/code/clang-tidy-diff.py"
    set build_database "$HOME/code/radsan_cjappl/build/compile_commands.json"

    if set -q _flag_diff_file
        cat $_flag_diff_file | $clang_tidy_diff -p1 -clang-tidy-binary $clang_tidy_binary -config $config_file -checks="-clang-diagnostic-*" -path $build_database
    else
        git -C $HOME/code/radsan_cjappl/llvm-project diff $_flag_branch | $clang_tidy_diff -p1 -clang-tidy-binary $clang_tidy_binary -config $config_file -checks="-clang-diagnostic-*" -path $build_database
    end
end

function radsan_test
    make -C ~/code/radsan_cjappl/ test
end

function make_radsan_remote
    ssh topher@Kates-MBP-2 'export PATH="/opt/homebrew/bin:$PATH" && make -C ~/code/radsan sync_and_build'
end

function make_radsan_ubuntu
  set IMAGE_NAME radsan-segfault
  set BUILD_DIR build_debug_ubuntu 
  docker run -v ~/code/radsan_cjappl:/test_radsan $IMAGE_NAME:latest ninja -C /test_radsan/$BUILD_DIR clang check-rtsan
end

abbr -a cops "gh copilot suggest \""
abbr -a cope "gh copilot explain \""

set -gx NVM_DIR "$HOME/.nvm"


# 2anki
set ANKI_SERVER_DIR ~/code/2anki/server
set ANKI_WEB_DIR $ANKI_SERVER_DIR/web
export WORKSPACE_BASE=$ANKI_SERVER_DIR/workspace

alias run_anki_server "npm run dev --prefix $ANKI_SERVER_DIR"
alias run_anki_web "npm run dev --prefix $ANKI_WEB_DIR"

function obsi_to_anki
    /Users/topher/.virtualenvs/anki_gen/bin/python $HOME/code/Obsidian_to_Anki/obsidian_to_anki.py -R "$OBSIDIAN" --regex
end
