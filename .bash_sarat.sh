
# b) function cd_func
# This function defines a 'cd' replacement function capable of keeping, 
# displaying and accessing history of visited directories, up to 10 entries.
# To use it, uncomment it, source this file and try 'cd --'.
# acd_func 1.0.6, 18-may-2013
# Petar Marinov, http://geocities.com/h2428, this is public domain
# Edited by Chris Olin, http://chrisolin.com, this is still public domian

 cd_func ()
 {
   local x2 the_new_dir adir index
   local -i cnt
 
   if [[ $1 ==  "--" ]]; then
     dirs -v
     return 0
   fi
 
   the_new_dir=$1
   [[ -z $1 ]] && the_new_dir=$HOME
 
   if [[ ${the_new_dir:0:1} == '-' ]]; then
     #
     # Extract dir N from dirs
     index=${the_new_dir:1}
     [[ -z $index ]] && index=1
     adir=$(dirs +$index)
     if [[ -z "$adir" ]]; then
         if [[ "$SHELL" == "/bin/zsh" ]]; then
             cd ~${index}
             return 0
             else
                echo "ADIR is null. Terminating." && return 1
         fi
     fi
     the_new_dir=$adir
   fi
 
   #
   # '~' has to be substituted by ${HOME}
   [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"
 
   #
   # Now change to the new dir and add to the top of the stack
   pushd "${the_new_dir}" > /dev/null
   [[ $? -ne 0 ]] && return 1
   the_new_dir=$(pwd)
   
   # Trim down everything beyond 11th entry
   popd -n +11 2>/dev/null 1>/dev/null
 
   #
   # Remove any other occurence of this dir, skipping the top of the stack
   for ((cnt=1; cnt <= 10; cnt++)); do
     x2=$(dirs +${cnt} 2>/dev/null)
     [[ $? -ne 0 ]] && return 0
     [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
     if [[ "${x2}" == "${the_new_dir}" ]]; then
       popd -n +$cnt 2>/dev/null 1>/dev/null
       cnt=cnt-1
     fi
   done
 
   return 0
 }

alias cd=cd_func
alias vi='vim'
#####


source ~/.git-completion.bash
source ~/.git-prompt.sh
source ~/.arc-completion.sh

export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export PROMPT_COMMAND='__git_ps1 "\u@\h:\W" "\\\$ "'
export EDITOR=vim
export PATH=$PATH:$HOME/bin
export PATH=$HOME/local/bin:$PATH
export PATH=$PATH:$HOME/Work/arcanist/bin
export NODE_PATH=$HOME/local/lib/node_modules

complete -W "$(<~/.ssh/hosts)" ssh

##### VIM GOODIES #####
#
#   sudo npm install -g jshint              # obviously, for :JSHint
#   sudo npm install -g underscore-cli      # underscore, for JSONify
#   sudo apt-get install libxml2-utils      # xmllint, for XMLify
#
# mkdir -p ~/.vim/bundle/node
# git clone https://github.com/moll/vim-node.git ~/.vim/bundle/node
# git clone git://github.com/godlygeek/tabular.git
# git clone https://github.com/walm/jshint.vim.git
#
#######################
