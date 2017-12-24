# Must also update expected Content-Length in compression tests
bundleBase="/vendor.e1cafb2f73707a2b414e"

requestUrl() {
  local url="$1"

  run curl --silent --show-error \
    --head --request GET \
    --header "$2" \
    --resolve "react-starter.localhost:80:127.0.0.1" \
    --resolve "react-starter.localhost:443:127.0.0.1" \
    --resolve "www.react-starter.localhost:80:127.0.0.1" \
    --resolve "www.react-starter.localhost:443:127.0.0.1" \
    --resolve "unknown.react-starter.localhost:80:127.0.0.1" \
    --resolve "unknown.react-starter.localhost:443:127.0.0.1" \
    --insecure \
    $url
  headers="$output"

  if [ "$status" -ne 0 ]; then
    echo "Error requesting $url"
    echo "$output" | indent
    return 1
  fi
}

request() {
  requestUrl "https://react-starter.localhost$1" "$2" "$3" "$4" "$5"
}

requestOk() {
  request "$@"
  expectOk
}
