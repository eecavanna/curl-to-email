/**
 * This script presents an HTTP endpoint people can use to send an email.
 * 
 * It was designed to send brief notification emails via curl. For example:
 * 
 * $ curl -X POST https://{url-of-this-script} \
 *     -H "Content-Type: application/json" \
 *     -d '{ "secret": "...", "message": "Program ran OK." }'
 */

/**
 * Handles incoming POST requests.
 * 
 * Reference: https://developers.google.com/apps-script/guides/web#request_parameters
 */
function doPost(event) {
  // Parse the POST data as a JSON string.
  const data = JSON.parse(event.postData.contents); // throws SyntaxError if invalid JSON

  // Validate the POST data.
  if (data.secret !== config.SHARED_SECRET) {
    throw Error("Shared secret does not match.");
  } else if (typeof data.message !== "string") {
    throw Error("message must be a string.");
  }

  // Build the email.
  // Reference: https://developers.google.com/apps-script/reference/base/session#getEffectiveUser()
  const email = {
    to: Session.getEffectiveUser().getEmail(), // send to the owner of this script
    subject: `${config.EMAIL_SUBJECT_PREFIX}${data.message}`,
    body: data.message,
  };
  
  // Send the email.
  // Reference: https://developers.google.com/apps-script/reference/mail/mail-app
  MailApp.sendEmail(email);

  // Respond with the email object.
  return ContentService
    .createTextOutput(JSON.stringify({ email: email, status: "OK" }))
    .setMimeType(ContentService.MimeType.JSON);
};