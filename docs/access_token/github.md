<!-- markdownlint-enable -->
# Create Access Token

## Note

It is not a good practice to provide Personal Access Token for any public/general usage.

So it is advised to create separate user called `obmondo-<service>-user` and
provide its Personal Access Token.

## Steps to create Personal Access Token

- Verify your email address, if it hasn't been verified yet.

- In the upper-right corner of any page, click your profile photo, then click Settings.
- In the left sidebar, click  Developer settings.
- In the left sidebar, click Personal access tokens.
- Click Generate new token.
- Give your token a descriptive name.
- To give your token an expiration, select the Expiration drop-down menu,
then click a default or use the calendar picker.
- Select the scopes, or permissions, you'd like to grant this token.
(To use your token to access repositories from the command line, select repo.)
- Click Generate token.
- Save the generated token at safe place. As it will be visible only once after creation.

Warning: Treat your tokens like passwords and keep them secret.
When working with the API, use tokens as environment variables instead of hardcoding them into your programs.

> Refer official Github
[doc](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
for more information.
