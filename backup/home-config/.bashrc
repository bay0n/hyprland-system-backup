#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
alias update='$HOME/Documents/LMAO/shitty/update.sh'
export PATH="$HOME/.local/bin:$PATH"
export QT_QPA_PLATFORM=xcb
alias shutd="$HOME/Documents/LMAO/shitty/shutd.sh"
alias password='faillock --user bayon --reset'
alias nvrun="__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia"
alias zed="zeditor"
alias grubupdate="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias terminaledit="sudo nano ~/.bashrc"
alias terminalupdate="source ~/.bashrc"
alias grubedit="sudo nano /etc/default/grub"
source /usr/share/nvm/init-nvm.sh
#benhasch@gmail.com
#ben2100@gmx.de
