# curl-to-email

`curl-to-email` is a tool you can use to send yourself an email from the command-line.

It has two parts:

1. A web app that sends an email when it receives an HTTP request (this part is implemented as a [Google Apps Script](https://www.google.com/script/start/))
2. A shell command that send an HTTP request to that web app (this part is implemented as a [shell function](https://github.com/rothgar/mastering-zsh/blob/master/docs/helpers/functions.md))

I use it to have my computer send me an email when a long-running process finishes; for example, a database dump or Python script.

## One-time setup

### Prerequisites

- `curl` is installed (i.e. `curl --version` shows version info)
- `zsh` is the current shell (i.e. [`ps -p $$`](https://askubuntu.com/a/590903) shows something that contains `zsh` and not `bash`)

### Procedure

#### 1. Deploy the `GoogleAppsScript` web app to Google Apps Script.

1. Visit https://script.google.com/home/projects/create to create a new Google Apps Script project
1. In the Google Apps Script editor that appears, rename the project to "`curl-to-email`" (by clicking on "Untitled project" at the top of the page)
1. Delete the contents of the `Code.gs` file
1. Copy the contents of the `GoogleAppsScript/Code.gs` file in this repository, and paste it into that empty `Code.gs` file in the Google Apps Script editor
1. In the Google Apps Script editor, add a new file of type "Script" and enter its name as "`Config`" (Google Apps Script will automatically append a `.gs` to its name)
1. Delete the contents of the newly-created `Config.gs` file
1. Copy the contents of the `GoogleAppsScript/Config.gs` file in this repository, and paste it into that empty `Config.gs` file in the Google Apps Script editor
1. Visit https://bitwarden.com/password-generator/ and generate a password
1. In `Config.gs`, update the `SHARED_SECRET` variable so it contains the password you generated
1. In the Google Apps Script editor, click the "Deploy" > "New deployment"
1. In the "Select type" section, click the gear icon and select "Web app"
1. In the "Description" section, populate the fields like this:
    1. Description: `v1.0.0`
    1. Execute as: `Me (...)`
    1. Who has access: `Anyone` (you'll rely on the password you created earlier—instead of on Google—to restrict access)
1. Click the disk icon to save the project
1. Click the "Deploy" button
1. Allow the Google Apps Script project to send email as you:
    1. Click the "Authorize access" button
    1. In the "Sign in - Google Accounts" window that appears, select your Google account
    1. In the "`curl-to-email` wants to access your Google Account" window, click the "Allow" button
1. In the "Deployment successfully updated" window, click the "Done" button

#### 2. Add the `curl_to_email` command to your shell.

1. Issue the following command to create a file named `define_curl_to_email.sh` in your home folder
    ```shell
    touch ~/define_curl_to_email.sh
    ```
1. Copy the contents of the `client/define_curl_to_email.sh` file in this repository, and—using a text editor—paste it into that newly-created `define_curl_to_email.sh` file
1. Update the following values in the `define_curl_to_email.sh` file:
    - `CURL_TO_EMAIL_WEB_APP_URI` - Update this to contain "Web app" URL shown on Google Apps Script, under "Deploy" > "Manage Deployments" > (the active deployment)
    - `CURL_TO_EMAIL_SHARED_SECRET` - Update this to contain the `SHARED_SECRET` value you put in the `Config.gs` file on Google Apps Script
1. Save the file
1. Update your shell initialization script (e.g. `~/.zshrc`) to run the code in that file during the shell initialization process
    1. (Optional) Make a backup copy of `~/.zshrc` before modifying it
        ```shell
        cp ~/.zshrc ~/.zshrc.bak
        ```
    1. Issue the following commands, which will append four lines to the bottom of your `~/.zshrc` file
       ```shell
        echo ''                                 >> ~/.zshrc
        echo '# <curl-to-email>'                >> ~/.zshrc
        echo 'source ~/define_curl_to_email.sh' >> ~/.zshrc
        echo '# </curl-to-email>'               >> ~/.zshrc
        ```
    1. (Optional) Verify the lines were appended
        ```shell
        tail -4 ~/.zshrc
        ```
1. Re-initialize your current shell
    ```shell
    source ~/.zshrc
    ```
1. Issue the `curl_to_email` command and check your email
    ```shell
    curl_to_email "This is a test"
    ```
    > If the command and the web app are both set up, you will receive an email containing the message, "This is a test", within a few seconds.

#### 3. (Optional) Clean up

1. Close the Google Apps Script editor (web page)
1. Close the terminal window (exit the shell)

### Usage

TODO