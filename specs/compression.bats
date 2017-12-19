#!/usr/bin/env bats
source ./assertions.sh
source ./helpers.sh

@test "compression: uncompressed by default, js" {
  request "/vendor.e1cafb2f73707a2b414e.js"

  expectOk
  expectHeaderAbsent "Content-Encoding"
  expectHeader "Content-Length: 202315"
}

@test "compression: uncompressed by default, source map" {
  request "/vendor.e1cafb2f73707a2b414e.js.map"

  expectOk
  expectHeaderAbsent "Content-Encoding"
  expectHeader "Content-Length: 694307"
}

@test "compression: gzip when requested, js" {
  request "/vendor.e1cafb2f73707a2b414e.js" "Accept-Encoding: gzip"

  expectOk
  expectHeader "Content-Encoding: gzip"
  expectHeader "Content-Length: 61077"
}

@test "compression: gzip when requested, source map" {
  request "/vendor.e1cafb2f73707a2b414e.js.map" "Accept-Encoding: gzip"

  expectOk
  expectHeader "Content-Encoding: gzip"
  expectHeader "Content-Length: 188252"
}

@test "compression: preserves original content type, js" {
  request "/vendor.e1cafb2f73707a2b414e.js" "Accept-Encoding: gzip"

  expectOk
  expectHeader "Content-Encoding: gzip"
  expectHeader "Content-Type: application/javascript"
}

@test "compression: preserves original content type, source map" {
  request "/vendor.e1cafb2f73707a2b414e.js.map" "Accept-Encoding: gzip"

  expectOk
  expectHeader "Content-Encoding: gzip"
  expectHeader "Content-Type: application/json"
}
