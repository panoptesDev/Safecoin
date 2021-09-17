#!/usr/bin/env bash
#
# Downloads and runs the latest stake-o-matic binary
#
set -e

solana_version=edge
curl -sSf https://raw.githubusercontent.com/fair-exchange/safecoin/v1.0.0/install/panoptis-install-init.sh \
    | sh -s - $solana_version \
        --no-modify-path \
        --data-dir ./panoptis-install \
        --config ./panoptis-install/config.yml

PATH="$(realpath "$PWD"/panoptis-install/releases/"$solana_version"*/solana-release/bin/):$PATH"
echo PATH="$PATH"

set -x
safecoin --version
exec panoptis-stake-o-matic "$@"
