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

# example: docker_helpers_export_commands ghcr.io/osgeo/gdal
function docker_helpers_export_commands() {
    image="$1"
    (
    set -euo pipefail
    docker pull "$image"
    mapfile -t commands < <(combine \
        <(docker run --rm --entrypoint="" "$image" /bin/bash -c 'compgen -c' | sort -u) \
        not <(compgen -c | sort -u))
    printf "%s\n" "${commands[@]}" | fzf -m |
    while read command
    do
        wrapper="$HOME/bin/$command"
        if [ -f "$wrapper" ]
        then
            echo "Cannot override $wrapper"
            continue
        fi
cat << EOF > "$wrapper"
#!/bin/bash
exec docker run --rm --pid=host \
    -v /tmp/.X11-unix:/tmp/.X11-unix:ro -e DISPLAY=\$DISPLAY \
    -v "\$PWD":/host --workdir /host \
    -v /tmp:/tmp \
    --entrypoint="" "$image" "$command" "\$@"
EOF
    chmod +x "$wrapper"
    done
    )
}
