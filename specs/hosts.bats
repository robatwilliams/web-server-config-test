#!/usr/bin/env bats
source ./assertions.sh
source ./helpers.sh

@test "hosts: unknown is forbidden, http" {
    requestUrl "http://unknown.react-starter.localhost"

    expectHeader "HTTP/1.1 403 Forbidden"
}

@test "hosts: unknown is forbidden, https" {
    requestUrl "https://unknown.react-starter.localhost"

    expectHeader "HTTP/1.1 403 Forbidden"
}

@test "hosts: redirects http to https, domain" {
    requestUrl "http://react-starter.localhost"

    expectHeader "HTTP/1.1 301 Moved Permanently"
    expectHeader "Location: https://react-starter.localhost/"
}

@test "hosts: redirects http to https, www subdomain" {
    requestUrl "http://www.react-starter.localhost"

    expectHeader "HTTP/1.1 301 Moved Permanently"
    expectHeader "Location: https://react-starter.localhost/"
}

@test "hosts: preserves path when redirecting http to https" {
    requestUrl "http://react-starter.localhost/somewhere"

    expectHeader "HTTP/1.1 301 Moved Permanently"
    expectHeader "Location: https://react-starter.localhost/somewhere"
}

@test "hosts: accepts https, domain" {
    requestUrl "https://react-starter.localhost"
    expectOk
}

@test "hosts: redirects http to https, www subdomain" {
    requestUrl "https://www.react-starter.localhost"
    expectOk
}
