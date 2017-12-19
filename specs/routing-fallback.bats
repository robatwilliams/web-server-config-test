#!/usr/bin/env bats
source ./assertions.sh
source ./helpers.sh

@test "client-side routing: unknown path returns index page" {
  request "/someClientSideRoute"

  expectOk
  expectHeader "Content-Type: text/html"
}

@test "client-side routing: unknown path with file extension returns 404" {
  request "/doesNotExist.css"

  expectHeader "HTTP/1.1 404 Not Found"
}
