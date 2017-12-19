resolve="react-starter.localhost:80:127.0.0.1"

# Must also update expected Content-Length in compression tests
bundleBase="/vendor.e1cafb2f73707a2b414e"

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
