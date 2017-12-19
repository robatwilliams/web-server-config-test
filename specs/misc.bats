#!/usr/bin/env bats
source ./assertions.sh
source ./helpers.sh

@test "root returns index page" {
  requestOk ""

  expectHeader "Content-Type: text/html"
}
