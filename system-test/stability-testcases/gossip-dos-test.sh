#!/usr/bin/env bash

set -e
cd "$(dirname "$0")"
PANOPTIS_ROOT="$(cd ../..; pwd)"

logDir="$PWD"/logs
rm -rf "$logDir"
mkdir "$logDir"

solanaInstallDataDir=$PWD/releases
solanaInstallGlobalOpts=(
  --data-dir "$solanaInstallDataDir"
  --config "$solanaInstallDataDir"/config.yml
  --no-modify-path
)

# Install all the safecoin versions
bootstrapInstall() {
  declare v=$1
  if [[ ! -h $solanaInstallDataDir/active_release ]]; then
    sh "$PANOPTIS_ROOT"/install/panoptis-install-init.sh "$v" "${solanaInstallGlobalOpts[@]}"
  fi
  export PATH="$solanaInstallDataDir/active_release/bin/:$PATH"
}

bootstrapInstall "edge"
panoptis-install-init --version
panoptis-install-init edge
panoptis-gossip --version
panoptis-dos --version

killall panoptis-gossip || true
panoptis-gossip spy --gossip-port 10015 > "$logDir"/gossip.log 2>&1 &
solanaGossipPid=$!
echo "panoptis-gossip pid: $solanaGossipPid"
sleep 5
panoptis-dos --mode gossip --data-type random --data-size 1232 &
dosPid=$!
echo "panoptis-dos pid: $dosPid"

pass=true

SECONDS=
while ((SECONDS < 600)); do
  if ! kill -0 $solanaGossipPid; then
    echo "panoptis-gossip is no longer running after $SECONDS seconds"
    pass=false
    break
  fi
  if ! kill -0 $dosPid; then
    echo "panoptis-dos is no longer running after $SECONDS seconds"
    pass=false
    break
  fi
  sleep 1
done

kill $solanaGossipPid || true
kill $dosPid || true
wait || true

$pass && echo Pass
