#!/usr/bin/env bats
source ./assertions.sh
source ./helpers.sh

@test "caching: index page must always be revalidated, uncompressed version" {
  requestOk ""

  expectHeader "Cache-Control: no-cache"
}

@test "caching: index page must always be revalidated, gzipped version" {
  requestOk "" "Accept-Encoding: gzip"

  expectHeader "Content-Encoding: gzip"
  expectHeader "Cache-Control: no-cache"
}

@test "caching: bundles are cacheable effectively forever, js, uncompressed version" {
  requestOk "$bundleBase.js"

  expectHeader "Cache-Control: public, max-age=31536000"
}

@test "caching: bundles are cacheable effectively forever, js, gzipped version" {
  requestOk "$bundleBase.js" "Accept-Encoding: gzip"

  expectHeader "Content-Encoding: gzip"
  expectHeader "Cache-Control: public, max-age=31536000"
}

@test "caching: bundles are cacheable effectively forever, source map, uncompressed version" {
  requestOk "$bundleBase.js.map"

  expectHeader "Cache-Control: public, max-age=31536000"
}

@test "caching: bundles are cacheable effectively forever, source map, gzipped version" {
  requestOk "$bundleBase.js.map" "Accept-Encoding: gzip"

  expectHeader "Content-Encoding: gzip"
  expectHeader "Cache-Control: public, max-age=31536000"
}
