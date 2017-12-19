#!/usr/bin/env bats
source ./assertions.sh
source ./helpers.sh

@test "content types: js" {
  requestOk "$bundleBase.js"

  expectHeader "Content-Type: application/javascript"
}

@test "content types: source map" {
  requestOk "$bundleBase.js.map"

  expectHeader "Content-Type: application/json"
}
