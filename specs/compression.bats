#!/usr/bin/env bats
source ./assertions.sh
source ./helpers.sh

@test "compression: uncompressed by default, js" {
  request "$bundleBase.js"

  expectOk
  expectHeaderAbsent "Content-Encoding"
  expectHeader "Content-Length: 202315"
}

@test "compression: uncompressed by default, source map" {
  request "$bundleBase.js.map"

  expectOk
  expectHeaderAbsent "Content-Encoding"
  expectHeader "Content-Length: 694307"
}

@test "compression: gzip when requested, js" {
  request "$bundleBase.js" "Accept-Encoding: gzip"

  expectOk
  expectHeader "Content-Encoding: gzip"
  expectHeader "Content-Length: 61077"
}

@test "compression: gzip when requested, source map" {
  request "$bundleBase.js.map" "Accept-Encoding: gzip"

  expectOk
  expectHeader "Content-Encoding: gzip"
  expectHeader "Content-Length: 188252"
}

@test "compression: preserves original content type, js" {
  request "$bundleBase.js" "Accept-Encoding: gzip"

  expectOk
  expectHeader "Content-Encoding: gzip"
  expectHeader "Content-Type: application/javascript"
}

@test "compression: preserves original content type, source map" {
  request "$bundleBase.js.map" "Accept-Encoding: gzip"

  expectOk
  expectHeader "Content-Encoding: gzip"
  expectHeader "Content-Type: application/json"
}
