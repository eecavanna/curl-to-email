curl_to_email() {
  # If no arguments were passed in, display a help string and exit.
  if [ $# -eq 0 ]; then
      echo "Summary: Sends an HTTP request to the \"http-to-email\" web service."
      echo "Usage: curl_to_email message"
      echo "Parameters:\n- message: a string you want included in the email subject and body"
      echo "Example: curl_to_email \"Something happened.\""
      return 1
  fi

  # Set user-specific values.
  HTTP_TO_EMAIL_URI="https://script.google.com/macros/s/AKfycbyPEPmM6Isr-h_Qmv94lvn0wISXP2t82lhSOmfZ9ues0ceQr_lsx3X9okyR7foGbtZf/exec"
  HTTP_TO_EMAIL_SHARED_SECRET="apple-banana-carrot-daikon-egg"

  # Submit an HTTP POST request to the `http-to-email` web service.
  # Note: Because the "-d" option is present, curl will use the "POST" method
  #       for the initial request ("initial", as in, before any redirects).
  curl -L "${HTTP_TO_EMAIL_URI}" \
       -H "Accept: application/json" \
       -H "Content-Type: application/json" \
       -d '{
             "secret": "'${HTTP_TO_EMAIL_SHARED_SECRET}'",
             "message": "'${message}'"
           }'
}