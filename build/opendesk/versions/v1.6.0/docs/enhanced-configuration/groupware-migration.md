<!--
SPDX-FileCopyrightText: 2024 Zentrum für Digitale Souveränität der Öffentlichen Verwaltung (ZenDiS) GmbH
SPDX-License-Identifier: Apache-2.0
-->

<h1>Migration from M365 with audriga migration service and master authentication</h1>

<!-- TOC -->
* [Prerequisites](#prerequisites)
  * [Prepare M365 tenant for access](#prepare-m365-tenant-for-access)
  * [Provisioning user accounts in openDesk](#provisioning-user-accounts-in-opendesk)
  * [Deploy openDesk with master authentication](#deploy-opendesk-with-master-authentication)
* [Migration configuration](#migration-configuration)
  * [Select the source provider and configure your openDesk instance](#select-the-source-provider-and-configure-your-opendesk-instance)
  * [Adding accounts](#adding-accounts)
    * [Add user accounts individually](#add-user-accounts-individually)
    * [Add multiple user accounts via CSV file](#add-multiple-user-accounts-via-csv-file)
  * [Start the migration](#start-the-migration)
  * [Monitor migration status](#monitor-migration-status)
* [Appendix](#appendix)
  * [Validating master authentication](#validating-master-authentication)
<!-- TOC -->

Most organizations already have email accounts on various platforms that need to be migrated to openDesk. This document describes the migration from M365 accounts to openDesk using the [audriga Migration Service](https://www.audriga.com) in combination with the master authentication option in openDesk. Other source platforms are also supported, and their migrations work in a similar manner.

The migration can be configured on audriga's self-service website, accessed with most common web browsers (e.g. IE, Firefox, Safari or Chrome). No software needs to be installed on your machine. The service connects to your mailbox similarly to what your email client does. Emails, attachments, folders, and, depending on the source systems, contacts, tasks, notes, and calendar data are copied to your destination account. See [M365 to OX Migration Guide](https://audriga.com/fileadmin/guides/en/MS365-OX.pdf) for the scope and limitations of the process.

The data in the source mailbox will not be deleted or altered. To configure a migration, only three simple steps in audriga's self-service portal have to be completed. After the migration has started, its status can be continuously monitored on the website.

It may not be possible to complete especially large or complex migrations with only this guide. If you identify issues related to I/O, bandwidth, time constraints, or anything else that makes the migration more complicated than you are comfortable handling on your own using the self-service, please contact [audriga's support](mailto:support@audriga.com).

# Prerequisites

## Prepare M365 tenant for access

The following instructions provide information on how to authenticate Microsoft 365 / Exchange Online accounts in the audriga migration service with "modern authentication" using a service account without the need to provide a username and password for each mailbox that will be migrated.

You will have to select an existing user account that will be used as a service account for the migration. You have to register the audriga application and create an M365 email group known only to you, as described in the following steps:

***1. Select one account to serve as a service account***

Please note that the account that shall serve as the service account requires a Microsoft 365/Exchange online license (mailbox).

> **Note**<br>
> If you want to designate your admin account as a service account, you have to provide the admin with a license.

***2. Register the audriga app in your tenant***

To register the audriga app in your tenant, log into your admin account and access the following URL:

 https://login.microsoftonline.com/organizations/v2.0/adminconsent?client_id=3cd27a72-a19e-4945-9715-fc24d940428f&redirect_uri=https://umzug.audriga.com/SMESwitchWebApp/oauth_complete.jsp&scope=https://outlook.office.com/.default

- Accept the App "audriga CloudMovr migration"
- You will be redirected to an audriga page, which you can close - it does not require additional interaction.

> **Note**<br>
> The audriga application is created under the "Enterprise application" tab in the AzureAD console.

***3. Create a "secret" group in the M365 tenant***

Create a "secret" group in the customer tenant.

- Go to <https://aad.portal.azure.com> > Azure Active Directory > Groups > New Group
- Choose a group name and group email address that includes the word "audriga" in lowercase ("Audriga" will not work), like *audriga-migration@your-maildomain.tld*
- Choose the group type "Microsoft 365"
- Appoint your service account (see 1.) as the owner of this group


## Provisioning user accounts in openDesk

In openDesk, you have to have all user accounts with mailboxes pre-defined before running the migration. You can either manually create your accounts using an IAM administrator or use the [user import tool](https://gitlab.opencode.de/bmi/opendesk/components/platform-development/images/user-import) to batch import user accounts to your openDesk deployment.

## Deploy openDesk with master authentication

With openDesk 1.0 Enterprise, you can set openDesk's email components (OX AppSuite and OX Dovecot) to master authentication mode to run the migration as described in this document using the following two settings for your deployment. This is NOT available in openDesk Community deployments:

```
secrets:
  oxAppSuite:
    adminPassword: "your_temporary_master_password"
functional:
  migration:
    oxAppSuite:
      enabled: true
```

1. You must specify a master password, it will be referenced later in this document.
2. You need to enable the actual master authentication mode.

To validate the master authentication mode please read the appendix section at the end of the document.

Updating your deployment with these settings will allow you to continue with the migration scenario. Once the migration is completed, you can remove `secrets.oxAppSuite.adminPassword` and need to turn off the migration mode by setting `functional.migration.oxAppSuite.enabled` to `false` or removing that setting, as `false` is the default before you update your deployment once again.

> **Note**<br>
> For the changes to take effect, it is sufficient to re-deploy the `open-xchange` component alone. But you have to restart the Dovecot Pod(s) manually when switching to/from the master authentication mode for the changes to take effect.

> **Note**<br>
> While in master authentication mode, regular users cannot log in to the webmail module of openDesk or access the mail using IMAP, as it is not recommended that users interact with the target mail infrastructure during the migration scenario described in this document.

# Migration configuration

The migration is configured in 3 steps using the [audriga migration self-service](https://umzug.audriga.com/SMESwitchWebApp/?client=groupware).

Ensure you meet the prerequisites. For example, this document does not support using the standard username/password-based authentication option for M365.

## Select the source provider and configure your openDesk instance

Choose [Microsoft 365 / Exchange Online (Admin)](https://umzug.audriga.com/SMESwitchWebApp/?client=groupware#src=onmicrosoft.com) as your current provider.

> **Note**<br>
> You may need to start typing in "Microsoft Office 365/Exchange Online" for it to appear in the list.

Configure openDesk as your destination server:
- Select "Configure provider or server" in the provider selection box of the migration application.
- In the following dialog, select "Open-Xchange" as protocol.
- On the tab "IMAP"
  - For "Mailserver (host name or IP address)" enter your IMAP host, e.g. "webmail.your-opendesk-domain.tld".
  - If your IMAP server is not running on default port 993, enter your nonstandard IMAP port under Details -> Port.
  - Press check.
- On the tab "Open-Xchange"
  - Set the hostname of your OX AppSuite installation, e.g. "webmail.your-opendesk-domain.tld".
  - Press check.
- If you receive a green checkmark on both tabs, click "Save". Otherwise, check your settings until you get the green checkmark.

## Adding accounts

You can add accounts one by one, which seems only feasible for test scenarios, or when you migrate a handful of mailboxes, or you can add accounts using CSV upload. Both options are described in the following subsections.

### Add user accounts individually

By default, you will enter the "Add Mailbox" tab where you can add individual accounts for M365:

```
Username:             enter the username of the service account, e.g. eva@your-maildomain.tld
Password:             enter the particular group email address, e.g. audriga-migration@your-maildomain.tld
Details -> mailbox:   enter the user's mailbox you want to migrate, e.g. pia@your-maildomain.tld
```

On the openDesk site, please provide:
```
Username:             enter the username of the mailbox you want to migrate to, e.g. pia@your-maildomain.tld
Password:             enter the master password
```

Click on check to verify the credentials. If the data is correct, a green checkmark will appear. A red cross will be displayed if the credentials need to be corrected.

After checking and confirming, you can use the same procedure to add further mailboxes.

Alternatively, you can add multiple accounts via CSV upload. More info on that below.

### Add multiple user accounts via CSV file

Prepare a CSV file with all necessary information. Unsurprisingly, this is the same information as described in the "Add User Accounts Individually" section above.

The CSV requires the following column order with a closing semicolon after the last value - but no headline is expected; the first line must be your migration data already:
```
M365ServiceAccount;M365GroupEmailAddress;M365Mailbox;openDeskMailbox;openDeskMasterPassword;
```

Example CSV:
```
eva@your-maildomain.tld;audriga-migration@your-maildomain.tld;eva@your-maildomain.tld;eva;YourMasterPassword;
eva@your-maildomain.tld;audriga-migration@your-maildomain.tld;max@your-maildomain.tld;max;YourMasterPassword;
eva@your-maildomain.tld;audriga-migration@your-maildomain.tld;pia@your-maildomain.tld;pia;YourMasterPassword;
eva@your-maildomain.tld;audriga-migration@your-maildomain.tld;ida@your-maildomain.tld;ida;YourMasterPassword;
```

Select the "Add multiple accounts" tab to configure up to 50 user accounts by uploading a CSV file. If you need to migrate more accounts, you can execute the migration multiple times.

Click "Check" and save afterwards.

## Start the migration

You will see a summary of the migration, including the number of accounts and the amount of data. Even if the analysis of the source accounts has not yet been completed, you can proceed.

Ensure you have a valid voucher; otherwise, you must complete the payment process.

Press "Start Migration" to proceed.

## Monitor migration status

The migration process may take some time to start. For large amounts of data, it may take a couple of hours.

Click on "Details" to get further information about the migration.

You can access a detailed log for each account by clicking "Protocol" on the right-hand side. Here, you can see detected duplicates or encountered errors (e.g., if emails cannot be transferred due to your provider's size limitations).

You will receive status emails for the migration job's submission and start, as well as when the migration job is finished. The emails are sent to the email address you have entered during the configuration. Those emails include a link to the status website so you can easily track and monitor your migration. Once the migration has been started, you can safely close the status website and shut down your computer; the migration will continue. You can re-open the status website anytime.

# Appendix

## Validating master authentication

Below are details in case you want to verify master authentication for Dovecot and OX AppSuite.

Set a few variables first:

```shell
export MIG_DOMAIN=your-opendesk-domain.tld
export MIG_WEBMAIL_HOST=webmail
export MIG_USERNAME=eva
export MIG_MASTER_PASSWORD=YourMasterPassword
export MIG_IMAP_PORT=31123
```

Ensure that you have defined a (your) default context for the migration where the account (in this example `eva`) can be found. The following should be executed in OX App Suite's `open-xchange-core-mw-default-0` container, in the example we set the default context to `1`:

```shell
/opt/open-xchange/sbin/changecontext -c 1 -L defaultcontext -A $MASTER_ADMIN_USER -P $MASTER_ADMIN_PW
```

With the preparation from above you should be able to successfully authenticate to both components:

**OX App Suite**

```shell
curl -X POST -d "name=${MIG_USERNAME}&password=${MIG_MASTER_PASSWORD}" "https://${MIG_WEBMAIL_HOST}.${MIG_DOMAIN}/appsuite/api/login?action=login"
```

**Dovecot**

```shell
echo "a001 LOGIN ${MIG_USERNAME} ${MIG_MASTER_PASSWORD}" | openssl s_client -ign_eof -connect ${MIG_DOMAIN}:${MIG_IMAP_PORT}
```
