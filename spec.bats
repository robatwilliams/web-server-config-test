#!/usr/bin/env bats

resolve="react-starter.localhost:80:127.0.0.1"

request() {
  local url="http://react-starter.localhost$1"

  run curl --silent --show-error \
    --head --request GET \
    --header "$2" \
    --resolve $resolve \
    $url
  headers="$output"

  if [ "$status" -ne 0 ]; then
    echo "Error requesting $url"
    echo "$output" | indent
    return 1
  fi
}

expectOk() {
  expectHeader "HTTP/1.1 200 OK"
}

expectHeader() {
  run grep --fixed-strings --line-regexp "$1" <<< "$headers"

  if [ "$status" -ne 0 ]; then
    echo "Did not find expected $1 in"
    echo "$headers" | indent
    echo "$output" | indent
    return 1
  fi
}

expectHeaderAbsent() {
  run grep "$1" <<< "$headers"

  if [ "$status" -ne 1 ]; then
    echo "Found unexpected $1 in"
    echo "$headers" | indent
    echo "$output" | indent
    return 1
  fi
}

@test "root returns index page" {
  request ""

  expectOk
  expectHeader "Content-Type: text/html"
}

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

@test "client-side routing: unknown path returns index page" {
  request "/someClientSideRoute"

  expectOk
  expectHeader "Content-Type: text/html"
}

@test "client-side routing: unknown path with file extension returns 404" {
  request "/doesNotExist.css"

  expectHeader "HTTP/1.1 404 Not Found"
}

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
  request "/vendor.e1cafb2f73707a2b414e.js"

  expectOk
  expectHeader "Cache-Control: public, max-age=31536000"
}

@test "caching: bundles are cacheable effectively forever, js, gzipped version" {
  request "/vendor.e1cafb2f73707a2b414e.js" "Accept-Encoding: gzip"

  expectOk
  expectHeader "Content-Encoding: gzip"
  expectHeader "Cache-Control: public, max-age=31536000"
}

@test "caching: bundles are cacheable effectively forever, source map, uncompressed version" {
  request "/vendor.e1cafb2f73707a2b414e.js.map"

  expectOk
  expectHeader "Cache-Control: public, max-age=31536000"
}

@test "caching: bundles are cacheable effectively forever, source map, gzipped version" {
  request "/vendor.e1cafb2f73707a2b414e.js.map" "Accept-Encoding: gzip"

  expectOk
  expectHeader "Content-Encoding: gzip"
  expectHeader "Cache-Control: public, max-age=31536000"
}


indent() { sed 's/^/    /'; }
