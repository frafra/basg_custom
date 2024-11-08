alias docker_helpers_rm_volume="rootlesskit rm -rf"

function docker_helpers_kill_by_name() {
  if [[ $# -gt 0 ]]
  then
    docker kill $(docker container ls -qf name="$1")
    shift
  fi
}

# https://docs.docker.com/engine/security/protect-access/
#PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}($(docker context show))\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
