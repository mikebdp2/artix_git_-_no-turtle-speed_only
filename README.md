# git

This is a mirror of https://gitea.artixlinux.org/packages/git.git  
patched with a "no-turtle-server": stop if you got randomly connected  
to a turtle server that drops the download speed lower than 128 KiB/s  
(you just restart until you get a fast one). Also, I have adjusted the  
"git-tests" to use a more reliable /tmp/ instead of a /dev/shm/ (askpass  
utility cannot be executed if a parent directory is mounted with noexec).  

# build

```bash
git clone "https://github.com/mikebdp2/artix_git_-_no-turtle-speed_only.git"
cd "./artix_git/"
makepkg -p "./PKGBUILD"
export GIT_EXEC_PATH="$(pwd)/src/git/"
printf "alias git_fast='export _GIT_FAST_OLD_PATH=\"\$PATH\" ; export PATH=\"$GIT_EXEC_PATH:\$PATH\"'\n"
printf "alias git_slow='export PATH=\"\$_GIT_FAST_OLD_PATH\" ; unset _GIT_FAST_OLD_PATH'\n"
```

# install

Copy the alias lines above to your ~/.bashrc, then you could temporarily  
enable the "no-turtle-server" workaround in a current command line window  
just by typing a git_fast command, and disable it by a git_slow command.  

# advanced

Below is a code that, combined with a manually-applied "no-turtle-server"  
workaround, will be trying to git clone a linux-firmware repository  
until we get randomly connected to a fast server and clone it successfully.  

```bash
# Formatting
   bold="\033[1m"
   bred="\033[1;31m"
 bgreen="\033[1;32m"
byellow="\033[1;33m"
   bend="\033[0m"
# Prints the status message in '$1: $2' format with a green color highlighting of a '$1'.
printgr () {
    printf "${bgreen}$1${bend}: $2\n"
    return 0
}
# Git clones a '$1' repository from a '$2' URL, with a '$3' branch if specified.
git_cloner () {
    if git clone --depth=1 ${3:+--branch $3} "$2" && [ -d "$1/.git/" ] ; then
        return 0
    else
        rm -rf "$1"
        printf "\n${byellow}WARNING${bend}: cannot download a ${byellow}$1${bend} repository !"
        printf "\n         Please check your Internet connection and try again.\n"
        sleep 1
        return 1
    fi
}
# linux-firmware needed for some Ethernet/WiFi network adapters
firmware_get () {
    printgr "LINUX-FIRMWARE" "remove the old directory if it exists"
    rm -rf ./linux-firmware/
    printgr "LINUX-FIRMWARE" "git clone a repository"
    while true; do
        git_cloner "./linux-firmware" "https://github.com/mikebdp2/linux-firmware.git" && break
    done
    return 0
}
```
