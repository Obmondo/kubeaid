# Oncall

## User Telegram setup

- Make sure user has correct role (setting is on keycloak)
- Requirements
  - Download telegram from play/app store
  - Download telegram webapp on your desktop/laptop

  ```sh
  sudo snap install telegram-desktop
  ```

  - Login on web.telegram.org and link it

- Click on left hand side icon
  - Alerts & IRM
  - Users
  - Click on your username and Edit
  - Telegram Connection tab
  - Click on this [link](https://t.me/obmondo_bot)
  - It should open in new tab and click on `Send Message`
  - The above will ask you a prompt and click on "Open Telegram Desktop"
  - You will be on telegram desktop app and then you can see a message "Start"
  - Click on it and you should see a message, something like

  ```raw
  Hi!

  This is Grafana oncall notification bot.
  blah blah
  ```

  - Go back to grafana and copy the verification code and post it on the same
  thread with `obmondo_bot` on telegram and you see a message

  ```raw
  Done! This telegram account is now linked to
  ```

  - Refresh the page and click again on Edit on your username and
  add a `Default Notications`
  - Notify By -> Telegram
