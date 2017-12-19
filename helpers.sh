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
