#!/usr/bin/env sh

getEnvVars() {
    cat "$1" | grep -v -e '^[[:space:]]*$' -e '^#'
}

prefillEnvFile() {
    exampleEnv="$1"
    prefilledEnv="$2"

    getEnvVars "$exampleEnv" \
        | sed -E 's/^(.+)=.*$/\1=__PREFILLED_\1__/' \
        > "$prefilledEnv"
}

resolvePrefilledVars() {
    prefilledEnv="$1"
    distDir="$2"

    varNames=$(getEnvVars "$prefilledEnv" | sed -E 's/^(.+)=.*$/\1/')

    for varName in $varNames; do
        envValue=$(printenv $varName)
        find "$distDir" -type f -print0 \
            | xargs -0 -n 1 \
                sed -e "s/__PREFILLED_${varName}__/$envValue/g" -i
    done
}

if [[ "$1" == "prefill" ]]; then
    prefillEnvFile "$2" "$3"
elif [[ "$1" == "resolve" ]]; then
    resolvePrefilledVars "$2" "$3"
fi
