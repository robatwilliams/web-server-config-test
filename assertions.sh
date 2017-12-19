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

indent() { sed 's/^/    /'; }
