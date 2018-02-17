function install() {
    local src=`getPath source src`
    local dist=`getPath dist dist`

    test -d "$src" || error "Source not found"

    buildProperties "$dist"
    compile "$src" "$dist" "$properties"
}

function getConfig() {
    local result=`cat "$CONFIG" | jq -r ".$1"`
    if [ "$result" == "null" ]; then
        echo "$2"
    else
        echo "$result"
    fi
}

function getPath() {
    local path=`getConfig "$1" "$2"`
    echo "$PWD/$path"
}

function safeProp() {
    echo "__$1__"
}

function defaultProperties() {
    echo "`safeProp "ROOT"` = $1"
    echo "`safeProp "STARTER"` = $1/utils/starter/scriptStarter"
    cat "config.properties"
}

function buildProperties() {
    createTmpFile properties
    defaultProperties "$1" > "$properties"
}

function compile() {
    local src="$1"
    local dst="$2"
    local properties="$3"

    safeMkdir "$dst"

    for file in "$src/"*; do
        local fileC="$dst/$(basename "$file")"
        if [ -d "$file" ]; then
            compile "$file" "$fileC" "$properties"
        else
            verboseR "$file"
            cat "$file" | applyProperties "$properties" > "$fileC"
            chmod +x "$fileC"
        fi
    done
}

function applyProperties() {
	eval $(buildSed "$1")
}

function trim() {
	sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

function escape() {
	sed 's/[^-A-Za-z0-9_]/\\&/g'
}

function buildSed() {
	sedsLine=""

	while read -r line; do
		if [ -n "$line" ]; then
	        local key=$(echo "$line" | cut -d '=' -f 1 | trim | escape)
	        local value=$(echo "$line" | cut -d '=' -f 2- | trim | escape)

	        test -z "$sedsLine" || sedsLine="$sedsLine | "
        	sedsLine="${sedsLine}sed -r s/'$key'/'$value'/g"
	    fi
    done < "$1"

    echo "$sedsLine"
}

CONFIG=".wxrc"

function declareConstants() {
    return 0
}
function printHelp() {
    return 0
}
function loadOptions() {
    return 0
}
function run() {
    install
}

source "./src/utils/starter/scriptStarter@v1"
