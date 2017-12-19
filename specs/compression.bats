#!/usr/bin/env bats
source ./assertions.sh
source ./helpers.sh

@test "compression: uncompressed by default, js" {
  requestOk "$bundleBase.js"

  expectHeaderAbsent "Content-Encoding"
  expectHeader "Content-Length: 202315"
}

@test "compression: uncompressed by default, source map" {
  requestOk "$bundleBase.js.map"

  expectHeaderAbsent "Content-Encoding"
  expectHeader "Content-Length: 694307"
}

@test "compression: gzip when requested, js" {
  requestOk "$bundleBase.js" "Accept-Encoding: gzip"

  expectHeader "Content-Encoding: gzip"
  expectHeader "Content-Length: 61077"
}

@test "compression: gzip when requested, source map" {
  requestOk "$bundleBase.js.map" "Accept-Encoding: gzip"

  expectHeader "Content-Encoding: gzip"
  expectHeader "Content-Length: 188252"
}

@test "compression: preserves original content type, js" {
  requestOk "$bundleBase.js" "Accept-Encoding: gzip"

  expectHeader "Content-Encoding: gzip"
  expectHeader "Content-Type: application/javascript"
}

@test "compression: preserves original content type, source map" {
  requestOk "$bundleBase.js.map" "Accept-Encoding: gzip"

  expectHeader "Content-Encoding: gzip"
  expectHeader "Content-Type: application/json"
}
