#!/usr/bin/env bats
source ./assertions.sh
source ./helpers.sh

setup() {
  requestOk ""
}

@test "security headers: deny iframing" {
  expectHeader "X-Frame-Options: DENY"
}

@test "security headers: block page render when XSS attack detected" {
  expectHeader "X-XSS-Protection: 1; mode=block"
}

@test "security headers: do not sniff content types" {
  expectHeader "X-Content-Type-Options: nosniff"
}

@test "security headers: allow content only from own origin, allow inline styles" {
  # style-src to allow Webpack style-loader to work
  expectHeader "Content-Security-Policy: default-src 'self'; style-src 'unsafe-inline'"
}

@test "security headers: disclose referrer path only on same origin and HTTPS" {
  expectHeader "Referrer-Policy: strict-origin-when-cross-origin"
}

@test "security headers: require HTTPS" {
  expectHeader "Strict-Transport-Security: max-age=15768000"
}
