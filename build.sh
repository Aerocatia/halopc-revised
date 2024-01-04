#!/bin/bash

dir="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

# Defaults.
TAGS_DIRS=('tags')
EXTRA_TAGS_DIRS=()
DATA_DIR="data"
MAPS_DIR="maps"
ENGINE_TARGET="none"
BUILD_NEW_RESOURCE_MAPS=0
BUILD_EXTENDED_CE_RESOURCE_MAPS=0
BUILD_CAMPAIGN=1
USE_EXISTING_RESOURCE_MAPS=0
USE_HD_BITMAPS=0
USE_HD_HUD=0
USE_DIRTY_TAG_WORKAROUNDS=0
INVADER_QUIET=0

echoerr() { printf "%s\n" "$*" >&2; }

__usage="Usage: $(basename $0) -e <engine> [OPTIONS]

Options:
  -b            Use high resolution transparency and rasterizer bitmaps.
  -d <dir>      Change the data directory used for scripts.
  -e <engine>   Engine target (required) Valid options are: gbx-custom,
                gbx-demo, gbx-retail, mcc-cea.
  -h            Show this help text.
  -j            Use the high resolution Halo HUD.
  -l <lang>     Build a localization. Valid options are: de, es, fr, it, jp, kr,
                tw, en (default).
  -m <dir>      Change the output maps directory.
  -n            Make and use new resource maps for shared data.
                WARNING: Compatibility will break with other maps that use
                resource maps on engines other than Custom Edition.
  -p            Do not build the campaign maps.
  -q            Make invader-build be quiet.
  -r            Build against existing resource maps.
  -t            Prefix an extra tags directory (can be used more than once).
  -x            Make extended resource maps for Custom Edition when using -n.
                Warning: Campaign maps built this way will ONLY work with
                these exact resource maps.
  -z            Use BROKEN tags to work around incorrect tag functionality on the
                Gearbox engines. These tags rely on gearbox engine bugs and *will*
                break on an engine or mod that fixes them, like MCC running in
                Custom Edition mode. If we ever escape this purgatory where MCC is
                broken and worse feature-wise while the Gearbox port is also still
                riddled with bugs, then this option and the associated tags should
                be blasted into the sun."

# Scenario basenames.
CAMPAIGN=('a10' 'a30' 'a50' 'b30' 'b40' 'c10' 'c20' 'c40' 'd20' 'd40')

MULTIPLAYER_XBOX=('beavercreek' 'bloodgulch' 'boardingaction' 'carousel' 'chillout'
         'damnation' 'hangemhigh' 'longest' 'prisoner' 'putput' 'ratrace'
         'sidewinder' 'wizard')

MULTIPLAYER_PC=('dangercanyon' 'deathisland' 'gephyrophobia' 'icefields'
        'infinity' 'timberland')

MULTIPLAYER=("${MULTIPLAYER_XBOX[@]}" "${MULTIPLAYER_PC[@]}")

# Options.
lang_set=0
while getopts ":bd:he:jl:m:npqrt:xz" arg; do
    case "${arg}" in
        b)
            USE_HD_BITMAPS=1
        ;;
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
                ;&
                mcc-cea)
                    ENGINE_TARGET="${OPTARG}"
                ;;
                *)
                    echoerr "Error: Unknown target engine \"$OPTARG\""
                    exit 1
                ;;
            esac
        ;;
        h)
            echo "$__usage"
            exit
        ;;
        j)
            USE_HD_HUD=1
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
                        echoerr "Error: Unknown Language \"$OPTARG\""
                        exit 1
                    ;;
                esac
                lang_set=1
            else
                echoerr "Error: The language can only be set once"
                exit 1
            fi
        ;;
        m)
            MAPS_DIR="${OPTARG}"
        ;;
        n)
            BUILD_NEW_RESOURCE_MAPS=1
        ;;
        p)
            BUILD_CAMPAIGN=0
        ;;
        q)
            INVADER_QUIET=1
        ;;
        r)
            USE_EXISTING_RESOURCE_MAPS=1
        ;;
        t)
            # Flip it
            EXTRA_TAGS_DIRS+=("${OPTARG}")
        ;;
        x)
            BUILD_EXTENDED_CE_RESOURCE_MAPS=1
        ;;
        z)
            USE_DIRTY_TAG_WORKAROUNDS=1
        ;;
        *)
            echoerr "Error: Incorrect usage. use -h for supported options"
            exit 1
        ;;
    esac
done

if [[ "$ENGINE_TARGET" == "none" ]]; then
    echoerr "Error: A target engine was not given. Use -h for help"
    exit 1
fi

# Find Invader.
if command -v invader-build &> /dev/null; then
    CACHE_BUILDER=invader-build
    W32_CB=0
elif command -v invader-build.exe &> /dev/null; then
    CACHE_BUILDER=invader-build.exe
    W32_CB=1
elif command -v ./invader-build.exe &> /dev/null; then
    CACHE_BUILDER=./invader-build.exe
    W32_CB=1
else
    echoerr "Error: Could not find invader-build in \$PATH or next to this script"
    exit 1
fi

if command -v invader-resource &> /dev/null; then
    RESOURCE_BUILDER=invader-resource
    W32_RB=0
elif command -v invader-resource.exe &> /dev/null; then
    RESOURCE_BUILDER=invader-resource.exe
    W32_RB=1
elif command -v ./invader-resource.exe &> /dev/null; then
    RESOURCE_BUILDER=./invader-resource.exe
    W32_RB=1
else
    echoerr "Error: Could not find invader-resource in \$PATH or next to this script"
    exit 1
fi

if [[ $W32_CB != $W32_RB ]]; then
    echoerr "Error: Mixed Windows and non-Windows invader tools are not supported by this script"
    exit 1
fi

if [[ $W32_CB == 1 ]]; then
    if command -v wslpath &> /dev/null; then
        MAPS_DIR_NIX=$(wslpath "${MAPS_DIR}")
    else
        echoerr "Error: Usage of the windows tools are only supported on WSL"
        exit 1
    fi
else
    MAPS_DIR_NIX="${MAPS_DIR}"
fi

# Make sure this exists.
mkdir -p "${MAPS_DIR_NIX}"

# Set common build args.
BUILD_ARGS=("--maps" "${MAPS_DIR}" "--game-engine" "$ENGINE_TARGET")

#
# Build tags directory arguments.
# Load order matters here, tags for the the HD HUD must be loaded over top of tags
# for things like engine workarounds.
#

# User provided tags directories.
for ET_PATH in "${EXTRA_TAGS_DIRS[@]}"; do
    BUILD_ARGS+=("--tags" "${ET_PATH}")
done

# Main tags for HD HUD.
if [[ $USE_HD_HUD == 1 ]]; then
    BUILD_ARGS+=("--tags" "extra/tags_highres_hud")
fi

# Load these in if building for MCC.
if [[ "$ENGINE_TARGET" == "mcc-cea" ]]; then
    if [[ $USE_HD_HUD == 1 ]]; then
        echoerr "Error: Support for the HD HUD on the MCC build target is not implemented in this tagset"
        exit 1
    else
        BUILD_ARGS+=("--tags" "extra/tags_mcc_compatibility")
    fi
fi

# Base Gearbox tag workarounds.
if [[ $USE_DIRTY_TAG_WORKAROUNDS == 1 ]]; then
    BUILD_ARGS+=("--tags" "extra/tags_engine_workarounds")
fi

# Simple HD bitmaps.
if [[ $USE_HD_BITMAPS == 1 ]]; then
    BUILD_ARGS+=("--tags" "extra/tags_highres_bitmaps")
fi

for MT_PATH in "${TAGS_DIRS[@]}"; do
    BUILD_ARGS+=("--tags" "${MT_PATH}")
done

# Split these off here because "--quiet" is not a valid argument for invader-resource.
RESOURCE_BUILD_ARGS=("${BUILD_ARGS[@]}")

# Quiet?
if [[ $INVADER_QUIET == 1 ]]; then
    BUILD_ARGS+=("--quiet")
fi

# Use existing resource maps if enabled.
if [[ $USE_EXISTING_RESOURCE_MAPS == 1 && $BUILD_NEW_RESOURCE_MAPS != 1 ]]; then
        RESOURCE_ARGS=("--resource-usage" "check")
    else
        RESOURCE_ARGS=("--resource-usage" "none")
fi

# If making new resource maps for Custom Edition we make ones directly compatible
# with stock unless stated otherwise. This is less efficient than full resource
# maps, but by default we want to ensure that new maps built against them can still
# load with the original Gearbox resource maps.

BUILD_FULL_RESOURCE_MAPS=0
if [[ $BUILD_NEW_RESOURCE_MAPS == 1 ]]; then
    if [[ $ENGINE_TARGET == "gbx-custom" && $BUILD_EXTENDED_CE_RESOURCE_MAPS != 1 ]]; then
        for i in bitmaps sounds loc; do
            $RESOURCE_BUILDER --type $i "${RESOURCE_BUILD_ARGS[@]}"
        done
        RESOURCE_ARGS=("--resource-usage" "check")
    else
        BUILD_FULL_RESOURCE_MAPS=1
    fi
fi

run_build() {
    # Campaign.
    if [[ $BUILD_CAMPAIGN == 1 ]]; then
        for s in "${CAMPAIGN[@]}"; do
            $CACHE_BUILDER levels/$s/$s \
                --data "${DATA_DIR}" \
                "${BUILD_ARGS[@]}" \
                "${RESOURCE_ARGS[@]}"
        done
    fi

    # MP (Stock Compat)
    for m in "${MULTIPLAYER[@]}"; do
        $CACHE_BUILDER levels/test/$m/$m \
            --auto-forge \
            --data "${DATA_DIR}" \
            "${BUILD_ARGS[@]}" \
            "${RESOURCE_ARGS[@]}"
    done

    # UI
    $CACHE_BUILDER levels/ui/ui \
        --forge-crc 0x73EE7229 \
        --data "${DATA_DIR}" \
        "${BUILD_ARGS[@]}" \
        "${RESOURCE_ARGS[@]}"
}

# Build here.
run_build

# If requested we make new resource maps using the maps we just built as a source
# for used tags. We then compile everything again against these with a second pass.
# The maps created here will hard-depend on these exact resource maps to run, so by
# default we do not do this for Halo Custom Edition.

if [[ $BUILD_FULL_RESOURCE_MAPS == 1 ]]; then
    BUILT_MAPS=("${MULTIPLAYER[@]}" "ui")
    if [[ $BUILD_CAMPAIGN == 1 ]]; then
        BUILT_MAPS+=("${CAMPAIGN[@]}")
    fi

    MAP_ARGS=()
    for MAPNAME in "${BUILT_MAPS[@]}"; do
        MAP_ARGS+=("--with-map" "${MAPS_DIR}/${MAPNAME}.map")
    done

    RESOURCE_TYPES=("bitmaps" "sounds")
    if [[ $ENGINE_TARGET == "gbx-custom" ]]; then
        RESOURCE_TYPES+=("loc")
    fi

    for RESOURCE_TYPE in "${RESOURCE_TYPES[@]}"; do
        $RESOURCE_BUILDER --type "$RESOURCE_TYPE" "${RESOURCE_BUILD_ARGS[@]}" "${MAP_ARGS[@]}"
    done

    RESOURCE_ARGS=("--resource-usage" "check")

    # Second pass.
    run_build
fi
