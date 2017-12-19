#!/usr/bin/env bats
source ./assertions.sh
source ./helpers.sh

@test "content types: js" {
  request "$bundleBase.js"

  expectOk
  expectHeader "Content-Type: application/javascript"
}

@test "content types: source map" {
  request "$bundleBase.js.map"

  expectOk
  expectHeader "Content-Type: application/json"
}
