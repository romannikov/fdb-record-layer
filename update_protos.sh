#!/usr/bin/env bash
set -euo pipefail

mkdir -p tests/go/store

protoc -I proto \
  --go_out=proto --go_opt=paths=source_relative \
  proto/fdb-record-layer/annotations.proto

PLUGIN_GO="$(mktemp)"
trap 'rm -f "$PLUGIN_GO"' EXIT

go build -o "$PLUGIN_GO" ./compiler/cmd/protoc-gen-fdb-go

protoc -I proto -I tests/proto \
  --plugin=protoc-gen-fdb-go="$PLUGIN_GO" \
  --go_out=. --go_opt=module=github.com/romannikov/fdb-record-layer \
  --fdb-go_out=. --fdb-go_opt=module=github.com/romannikov/fdb-record-layer \
  tests/proto/store.proto
