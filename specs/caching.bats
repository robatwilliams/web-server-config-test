#!/usr/bin/env bats
source ./assertions.sh
source ./helpers.sh

@test "caching: index page must always be revalidated, uncompressed version" {
  request ""

  expectOk
  expectHeader "Cache-Control: no-cache"
}

@test "caching: index page must always be revalidated, gzipped version" {
  request "" "Accept-Encoding: gzip"

  expectOk
  expectHeader "Content-Encoding: gzip"
  expectHeader "Cache-Control: no-cache"
}

@test "caching: bundles are cacheable effectively forever, js, uncompressed version" {
  request "$bundleBase.js"

  expectOk
  expectHeader "Cache-Control: public, max-age=31536000"
}

@test "caching: bundles are cacheable effectively forever, js, gzipped version" {
  request "$bundleBase.js" "Accept-Encoding: gzip"

  expectOk
  expectHeader "Content-Encoding: gzip"
  expectHeader "Cache-Control: public, max-age=31536000"
}

@test "caching: bundles are cacheable effectively forever, source map, uncompressed version" {
  request "$bundleBase.js.map"

  expectOk
  expectHeader "Cache-Control: public, max-age=31536000"
}

@test "caching: bundles are cacheable effectively forever, source map, gzipped version" {
  request "$bundleBase.js.map" "Accept-Encoding: gzip"

  expectOk
  expectHeader "Content-Encoding: gzip"
  expectHeader "Cache-Control: public, max-age=31536000"
}
