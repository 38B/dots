#!/usr/bin/env bash

usage() {
    cat <<-_EOF_
USAGE: $(basename $0) [-acldbh] [CONTAINER] [EXTRA_COMMANDS]

 -b,--basedir	  Print the location containers are stored.
 -l,--ls,--list	  List all containers.
 -a,--add	  Add a new container.
 -c,--color	  Color to use for in tab bar (to differentiate containers)
 -d,--delete	  Delete a container.
 -h,--help	  Print this help message.

Open a qutebrowser session using the provided container passing extra commands
directly to qutebrowser.

In addition to containers stored in BASEDIR there is also the default
"container" and temporary containers.

The default container opens qutebrowser normally (using the data in
qutebrowser's default state directory), this is used if CONTAINER is "default".

Temporary containers are created using \`mktemp\` if CONTAINER is temp. Each time
this is called a new container is made. NOTE: unlike a private browser session,
the data is stored and will remain until the the temporary directory is cleared.

When adding a container, an optional color argument can be passed that specifies
the color of the tab bar to use in order to differentiate between windows from
different containers:
	  $(basename $0) --color green --add foo

If color is passed when opening a container, that color will override the
default container color.
_EOF_
}

CONFIG="$XDG_CONFIG_HOME"/qutebrowser/config.py
USERSCRIPTS="$XDG_DATA_HOME"/qutebrowser/userscripts

error() {
    local exit_code="$1"
    shift
    echo -e "$@\n" >&2
    usage >&2
    exit "$exit_code"
}

containerdir() {
    if [ -z "$XDG_DATA_HOME" ]; then
        echo ".qutebrowser/containers"
    else
        echo "$XDG_DATA_HOME"/qb_containers
    fi
}

list() {
    containers=("default" "temp" $(ls $(containerdir)))
    echo ${containers[@]}
}

create_container() {
    local path=$1
    local color=$2

    mkdir "$path"
    [ -z "$color" ] || echo "$color" >"$container"/color.txt

    mkdir -p "$path"/data
    ln -s "$USERSCRIPTS" "$container"/data
}

add() {
    ([ "$1" == "default" ] || [ "$1" == "temp" ]) && error 1 \
        "Can't name container reserved name \"$1\"."

    local container=$(containerdir)/"$1"
    [ -d "$container" ] &&
        echo "Container \"$1\" already exists. Nothing to do." >&2 &&
        exit 1

    create_container "$container" "$2"
}

delete() {
    [ -d $(containerdir)/"$1" ] || {
        echo "Container \"$1\" does not exist. Nothing to do." >&2
        exit 1
    }

    rm -rf $(containerdir)/"$1"
}

for arg in "$@"; do
    shift
    case "$arg" in
    '--basedir') set -- "$@" '-b' ;;
    '--ls' | '--list') set -- "$@" '-l' ;;
    '--color') set -- "$@" '-c' ;;
    '--add') set -- "$@" '-a' ;;
    '--delete') set -- "$@" '-d' ;;
    '--help') set -- "$@" '-h' ;;
    *) set -- "$@" "$arg" ;;
    esac
done

color=""
[ -d $(containerdir) ] || mkdir -p $(containerdir)
while getopts 'blc:a:d:h' arg; do
    case "$arg" in
    b)
        containerdir
        exit 0
        ;;
    l)
        list
        exit 0
        ;;
    c)
        color="$OPTARG"
        ;;
    a)
        add "$OPTARG" "$color"
        exit 0
        ;;
    d)
        delete "$OPTARG"
        exit 0
        ;;
    h)
        usage
        exit 0
        ;;
    ?)
        usage >&2
        exit 1
        ;;
    esac
done
shift $(($OPTIND - 1))

[ "$#" -gt 0 ] || error 1 "Must provide a container name."

if [ -d $(containerdir)/"$1" ]; then
    container=$(containerdir)/"$1"
elif [ "$1" == "temp" ]; then
    container=$(mktemp --directory)
    create_container "$container" "darkgray"
elif [ "$1" == "default" ]; then
    container="$1"
else
    error 1 "Container \"$1\" does not exist." \
        "Add with:\n\t $(basename $0) --add $1"
fi
shift

if [ $container == "default" ]; then
    qutebrowser "$@"
else
    if [ -z "$color" ] && [ -f "$container"/color.txt ]; then
        color=$(cat "${container}"/color.txt)
    fi

    set_color=""
    if [ ! -z "$color" ]; then
        set_color="--set colors.tabs.selected.odd.bg $color"
    fi

    qutebrowser \
        -B "$container" \
        -C "$CONFIG" \
        --set tabs.title.format "{audio} $(basename $container): {current_title}" \
        $set_color \
        "$@"
fi
