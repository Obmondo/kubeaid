# CISO Assistant

## NOTES:

* needs a domain, without it won't work

## Recovery superuser account

```
root@ciso-assistant-backend-59cc756849-fzmqx:/code# poetry run python manage.py createsuperuser
2025-05-23T14:57:58.115338Z [info     ] BASE_DIR: /code                [ciso_assistant.settings] ciso_assistant_url=https://ciso.demo.example.net
2025-05-23T14:57:58.115595Z [info     ] VERSION: v2.5.4                [ciso_assistant.settings] ciso_assistant_url=https://ciso.demo.example.net
2025-05-23T14:57:58.115699Z [info     ] BUILD: c47fb2d8a               [ciso_assistant.settings] ciso_assistant_url=https://ciso.demo.example.net
2025-05-23T14:57:58.115775Z [info     ] SCHEMA_VERSION: 2              [ciso_assistant.settings] ciso_assistant_url=https://ciso.demo.example.net
2025-05-23T14:57:58.115961Z [info     ] DEBUG mode: False              [ciso_assistant.settings] ciso_assistant_url=https://ciso.demo.example.net
2025-05-23T14:57:58.116041Z [info     ] CISO_ASSISTANT_URL: https://ciso.demo.example.net [ciso_assistant.settings] ciso_assistant_url=https://ciso.demo.example.net
2025-05-23T14:57:58.116114Z [info     ] ALLOWED_HOSTS: ['localhost', '127.0.0.1', 'ciso-assistant-backend', 'ciso.demo.example.net'] [ciso_assistant.settings] ciso_assistant_url=https://ciso.demo.example.net
2025-05-23T14:57:58.116266Z [info     ] SQLITE_FILE: /tmp/ciso-assistant.sqlite3 [ciso_assistant.settings] ciso_assistant_url=https://ciso.demo.example.net
2025-05-23T14:57:58.116375Z [info     ] DATABASE ENGINE: django.db.backends.sqlite3 [ciso_assistant.settings] ciso_assistant_url=https://ciso.demo.example.net
Email: foo@example.net
Password:
Password (again):
The password is too similar to the username.
This password is too short. It must contain at least 8 characters.
This password is too common.
Bypass password validation and create user anyway? [y/N]: y
2025-05-23T14:59:02.670994Z [info     ] creating superuser             [iam.models] ciso_assistant_url=https://ciso.demo.example.net email=foo@example.net
2025-05-23T14:59:02.782662Z [info     ] user saved                     [iam.models] ciso_assistant_url=https://ciso.demo.example.net user=<User: foo@example.net>
2025-05-23T14:59:02.800710Z [info     ] user created sucessfully       [iam.models] ciso_assistant_url=https://ciso.demo.example.net user=<User: foo@example.net>
Superuser created successfully.
```
