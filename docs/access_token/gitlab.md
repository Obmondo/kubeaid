<!-- markdownlint-enable -->
# Create Access Token

## Steps to create Project Access Token

> Project access tokens are part of self hosted and enterprise Gitlab only

- On the top bar, select Menu > Projects and find your project.
- On the left sidebar, select Settings > Access Tokens.
- Enter a name. The token name is visible to any user with permissions to view the project.
- Optional. Enter an expiry date for the token. The token expires on that date at midnight UTC.
An instance-wide maximum lifetime setting can limit the maximum allowable lifetime in self-managed instances.
- Select a role for the token.
- Select the desired scopes.
- Select Create project access token.

<!-- markdownlint-disable -->
### Scopes

|Scope|Description|
|---|---|
|api|Grants complete read and write access to the scoped project API, including the Package Registry.|
|read_api|Grants read access to the scoped project API, including the Package Registry.|
|read_registry|Allows read access (pull) to the Container Registry images if a project is private and authorization is required.|
|write_registry|Allows write access (push) to the Container Registry.|
|read_repository|Allows read access (pull) to the repository.|
|write_repository|Allows read and write access (pull and push) to the repository.|

<!-- markdownlint-enable -->
> Refer official Gitlab
[doc](https://docs.gitlab.com/ee/user/project/settings/project_access_tokens.html)
for more information.

If you are unable to create the Project Access Token, please create a separate user called
`obmondo-<service>-user` and provide Personal Access Token of that user.
Check how to create PAT [here](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html).
