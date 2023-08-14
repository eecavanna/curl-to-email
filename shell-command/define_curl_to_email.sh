#! /bin/zsh

# The URL of the `curl-to-email` web service.
CURL_TO_EMAIL_WEB_APP_URL='__REPLACE_ME__'

# A secret value shared between this client and the `curl-to-email` web service.
CURL_TO_EMAIL_SHARED_SECRET='__REPLACE_ME__'

curl_to_email() {
  # If no arguments were passed in, display a help string and exit.
  if [ $# -eq 0 ]; then
      echo 'Summary: Sends an HTTP request to the "curl-to-email" web service.'
      echo 'Usage: curl_to_email MESSAGE'
      echo '  Parameters:'
      echo '  - MESSAGE: a string you want the email subject and body to contain'
      echo 'Example: curl_to_email "Something happened"'
      echo ''
      return 1
  fi

  # Store the first argument as the message.
  message=$1

  # Submit an HTTP POST request to the `curl-to-email` web service.
  # Note: Because the "-d" option is present, curl will use the "POST" method
  #       for the initial request ("initial", as in, before any redirects).
  curl -L "${CURL_TO_EMAIL_WEB_APP_URL}" \
       -H 'Content-Type: application/json' \
       -d '{
             "secret": "'${CURL_TO_EMAIL_SHARED_SECRET}'",
             "message": "'${message}'"
           }'
}