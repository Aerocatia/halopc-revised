#!/bin/bash

dir="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

# Defaults
TAGS_DIRS=('tags')
DATA_DIR="data"
MAPS_DIR="maps"
BUILD_NEW_CE_RESOURCE_MAPS=0
BUILD_CAMPAIGN=1
USE_RESOURCE_MAPS=0
ENGINE_TARGET="none"

__usage="Usage: $(basename $0) -e <engine> [OPTIONS]

Options:
  -d <dir>      Change the data directory used for scripts.
  -e <engine>   Engine target (required) Valid options are: gbx-custom,
                gbx-demo, gbx-retail.
  -h            Show this help text.
  -l <lang>     Build a localization. Valid options are: de, es, fr, it, jp, kr,
                tw, en (default).
  -m <dir>      Change the output maps directory.
  -n            Make and use new resource maps when building for Custom Edition.
  -p            Do not build the campaign maps.
  -q            Make invader-build be quiet.
  -r            Build against existing resource maps.
  -t            Prefix an extra tags directory (can be used more than once).
"

# Scenario basenames
CAMPAIGN=('a10' 'a30' 'a50' 'b30' 'b40' 'c10' 'c20' 'c40' 'd20' 'd40')

MULTIPLAYER_XBOX=('beavercreek' 'bloodgulch' 'boardingaction' 'carousel' 'chillout'
         'damnation' 'hangemhigh' 'longest' 'prisoner' 'putput' 'ratrace'
         'sidewinder' 'wizard')

MULTIPLAYER_PC=('dangercanyon' 'deathisland' 'gephyrophobia' 'icefields'
        'infinity' 'timberland')

MULTIPLAYER=("${MULTIPLAYER_XBOX[@]}" "${MULTIPLAYER_PC[@]}")

# Options
lang_set=0
while getopts ":d:he:l:m:npqrt:" arg; do
    case "${arg}" in
        d)
            DATA_DIR="${OPTARG}"
        ;;
        e)
            case "${OPTARG}" in
                gbx-custom)
                ;&
                gbx-demo)
                ;&
                gbx-retail)
                    ENGINE_TARGET="${OPTARG}"
                ;;
                *)
                    echo "Error: Unknown target engine \"$OPTARG\""
                    exit 1
                ;;
            esac
        ;;
        h)
            echo "$__usage"
            exit
        ;;
        l)
            if [[ $lang_set != 1 ]]; then
                case "${OPTARG}" in
                    de)
                    ;&
                    es)
                    ;&
                    fr)
                    ;&
                    it)
                    ;&
                    jp)
                    ;&
                    kr)
                    ;&
                    tw)
                        TAGS_DIRS=("loc/tags_${OPTARG}" "${TAGS_DIRS[@]}")
                    ;;
                    en)
                        true
                    ;;
                    *)
                        echo "Error: Unknown Language \"$OPTARG\""
                        exit 1
                    ;;
                esac
                lang_set=1
            else
                echo "Error: The language can only be set once"
                exit 1
            fi
        ;;
        m)
            MAPS_DIR="${OPTARG}"
        ;;
        n)
            BUILD_NEW_CE_RESOURCE_MAPS=1
            USE_RESOURCE_MAPS=1
        ;;
        p)
            BUILD_CAMPAIGN=0
        ;;
        q)
            INVADER_QUIET=1
        ;;
        r)
            USE_RESOURCE_MAPS=1
        ;;
        t)
            TAGS_DIRS=("${OPTARG}" "${TAGS_DIRS[@]}")
        ;;
        *)
            echo "Error: Unkown option. use -h for supported options"
            exit 1
        ;;
    esac
done

if [[ "$ENGINE_TARGET" == "none" ]]; then
    echo "Error: A target engine was not given. Use -h for help"
    exit 1
fi

# Find Invader
if command -v invader-build &> /dev/null; then
    CACHE_BUILDER=invader-build
elif command -v invader-build.exe &> /dev/null; then
    CACHE_BUILDER=invader-build.exe
elif command -v ./invader-build.exe &> /dev/null; then
    CACHE_BUILDER=./invader-build.exe
else
    echo "Could not find invader-build in \$PATH or next to this script"
    exit 1
fi

if command -v invader-resource &> /dev/null; then
    RESOURCE_BUILDER=invader-resource
elif command -v invader-resource.exe &> /dev/null; then
    RESOURCE_BUILDER=invader-resource.exe
elif command -v ./invader-resource.exe &> /dev/null; then
    RESOURCE_BUILDER=./invader-resource.exe
else
    echo "Could not find invader-resource in \$PATH or next to this script"
    exit 1
fi

# Make sure this exists
mkdir -p "${MAPS_DIR}"

# Build tags directory arguments
TAGS_DIR_ARGS=()
for T_PATH in "${TAGS_DIRS[@]}"; do
    TAGS_DIR_ARGS+=("--tags" "${T_PATH}")
done

# Make new resource maps if custom edition
if [[ $BUILD_NEW_CE_RESOURCE_MAPS == 1 && $ENGINE_TARGET == "gbx-custom" ]]; then
    for i in bitmaps sounds loc; do
        $RESOURCE_BUILDER --game-engine gbx-custom --type $i "${TAGS_DIR_ARGS[@]}"
    done
fi

# Use resource maps if enabled.
if [[ $USE_RESOURCE_MAPS == 1 ]]; then
        BASE_ARGS=("--game-engine" "$ENGINE_TARGET" "--resource-usage" "check")
    else
        BASE_ARGS=("--game-engine" "$ENGINE_TARGET" "--resource-usage" "none")
fi

# Quiet?
if [[ $INVADER_QUIET == 1 ]]; then
    BASE_ARGS=("${BASE_ARGS[@]}" "--quiet")
fi

# Campaign
if [[ $BUILD_CAMPAIGN == 1 ]]; then
    for s in "${CAMPAIGN[@]}"; do
        $CACHE_BUILDER levels/$s/$s \
            --data "${DATA_DIR}" \
            --maps "${MAPS_DIR}" \
            "${TAGS_DIR_ARGS[@]}" \
            "${BASE_ARGS[@]}"
    done
fi

# MP (Stock Compat)
for m in "${MULTIPLAYER[@]}"; do
    $CACHE_BUILDER levels/test/$m/$m \
        --auto-forge \
        --data "${DATA_DIR}" \
        --maps "${MAPS_DIR}" \
        "${TAGS_DIR_ARGS[@]}" \
        "${BASE_ARGS[@]}"
done

# UI
$CACHE_BUILDER levels/ui/ui \
    --data "${DATA_DIR}" \
    --maps "${MAPS_DIR}" \
    --forge-crc 0x73EE7229 \
    "${TAGS_DIR_ARGS[@]}" \
    "${BASE_ARGS[@]}"
