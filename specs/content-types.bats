#!/usr/bin/env bats
source ./assertions.sh
source ./helpers.sh

@test "content types: js" {
  request "/vendor.e1cafb2f73707a2b414e.js"

  expectOk
  expectHeader "Content-Type: application/javascript"
}

@test "content types: source map" {
  request "/vendor.e1cafb2f73707a2b414e.js.map"

  expectOk
  expectHeader "Content-Type: application/json"
}
