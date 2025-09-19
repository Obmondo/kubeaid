<!--
SPDX-FileCopyrightText: 2023 Bundesministerium des Innern und für Heimat, PG ZenDiS "Projektgruppe für Aufbau ZenDiS"
SPDX-License-Identifier: Apache-2.0
-->

<h1>Debugging</h1>

<!-- TOC -->
* [Disclaimer](#disclaimer)
* [Enable debugging](#enable-debugging)
* [Adding containers to a pod for debugging purposes](#adding-containers-to-a-pod-for-debugging-purposes)
  * [Adding a container to a pod/deployment - Dev/Test only](#adding-a-container-to-a-poddeployment---devtest-only)
  * [Temporary/ephemeral containers](#temporaryephemeral-containers)
* [Components](#components)
  * [Helmfile](#helmfile)
  * [MariaDB](#mariadb)
  * [Nextcloud](#nextcloud)
  * [OpenProject](#openproject)
  * [PostgreSQL](#postgresql)
  * [Keycloak](#keycloak)
    * [Setting the log level](#setting-the-log-level)
    * [Accessing the Keycloak admin console](#accessing-the-keycloak-admin-console)
<!-- TOC -->

# Disclaimer

This document collects information on how to go about debugging an openDesk deployment.

It will be extended over time as we deal with debugging cases.

We for sure do not want to reinvent the wheel, so we might link to external sources that contain helpful
information where available.

> **Warning**<br>
> You should never enable the debug option in production environments! By looking up `debug.enabled` in the deployment, you
will find the various places changes are applied when enabling debugging. So, outside of development and test
environments, you should use them thoughtfully and carefully if needed.

# Enable debugging

Check the openDesk [`debug.yaml.gotmpl`](../helmfile/environments/default/debug.yaml.gotmpl) and configure it for your deployment
```
debug:
  enabled: true
```

This will result in:
- setting most component's log level to debug
- making the Keycloak admin console available by default at `https://id.<your_domain>/admin/`
- ingress for `http://minio-console.<your_domain>` being configured

> **Note**<br>
> When enabling debug mode and updating your deployment, you must manually delete all jobs before updating. In debug mode, we keep the jobs, and some job fields are immutable, leading to a deployment failure.

> **Note**<br>
> All containers should write their log output to STDOUT; if you find (valuable) logs inside a container which were not in STDOUT, please let us know!

# Adding containers to a pod for debugging purposes

During testing or development, you may need to execute tools, browse, or even change things in the filesystem of another container.

This can be a challenge the more security-hardened the container images are because there are no debugging tools available, and sometimes, there is not even a shell.

Adding a container to a Pod can ease the pain.

Below are some brief notes on debugging openDesk by adding debug containers. Of course, there are many more detailed resources out there.

## Adding a container to a pod/deployment - Dev/Test only

You can add a container by editing and updating an existing deployment, which is quite comfortable with tools like [Lens](https://k8slens.dev/).

- Select the container you want to use as a debugging container; in the example below, it is `registry.opencode.de/bmi/opendesk/components/platform-development/images/opendesk-debugging-image:latest`.
- Ensure the `shareProcessNamespace` option is enabled for the Pod.
- Reference the selected container within the `containers` array of the deployment.
- If you want to access another container's filesystem, ensure both containers' user/group settings match.
- Save & update the deployment.

The following example can be used to debug the `openDesk-Nextcloud-PHP` container; if you want to modify files, remember to set `readOnlyRootFilesystem` to `true` on the PHP container.

```yaml
      shareProcessNamespace: true
      containers:
        - name: debugging
          image: registry.opencode.de/bmi/opendesk/components/platform-development/images/opendesk-debugging-image:latest
          command: ["/bin/bash", "-c", "while true; do echo 'This is a temporary container for debugging'; sleep 5 ; done"]
          securityContext:
            capabilities:
              drop:
                - ALL
            privileged: false
            runAsUser: 65532
            runAsGroup: 65532
            runAsNonRoot: true
            readOnlyRootFilesystem: false
            allowPrivilegeEscalation: false
            seccompProfile:
              type: RuntimeDefault
```

- After the deployment has been reloaded, open the shell of the debugging container.
- When you've succeeded, you will see the processes of both/all containers in the Pod when executing `ps aux`.
- To access other containers' filesystems, select the PID of a process from the other container and do a `cd /proc/<selected_process_id>/root`.

## Temporary/ephemeral containers

An interesting read from which we picked most of the details below from: https://iximiuz.com/en/posts/kubernetes-ephemeral-containers/

Sometimes, you do not want to add a container permanently to your existing deployment. In that case, you could use [ephemeral containers](https://kubernetes.io/docs/concepts/workloads/pods/ephemeral-containers/).

For the commands further down this section, we need to set some environment variables first:
- `NAMESPACE`: The namespace in which the Pod you want to inspect is running.
- `DEPLOYMENT_NAME`: The deployment's name responsible for spawning the Pod you want to inspect within the aforementioned namespace.
- `POD_NAME`: The name of the Pod you want to inspect within the aforementioned namespace.
- `EPH_CONTAINER_NAME`: The name of your debugging container, "debugging" seems obvious.
- `DEBUG_IMAGE`: The image you want to use for debugging purposes.

e.g.

```shell
export NAMESPACE=my_test_deployment
export DEPLOYMENT_NAME=opendesk-nextcloud-php
export POD_NAME=opendesk-nextcloud-php-6686d47cfb-7642f
export EPH_CONTAINER_NAME=debugging
export DEBUG_IMAGE=registry.opencode.de/bmi/opendesk/components/platform-development/images/opendesk-debugging-image:latest
```

You still need to ensure that your deployment supports process namespace sharing:

```shell
kubectl -n ${NAMESPACE} patch deployment ${DEPLOYMENT_NAME} --patch '
spec:
  template:
    spec:
      shareProcessNamespace: true'
```

Now, you can add the ephemeral container with:
```shell
kubectl -n ${NAMESPACE} debug -it --attach=false -c ${EPH_CONTAINER_NAME} --image={DEBUG_IMAGE} ${POD_NAME}
```
and open its interactive terminal with
```shell
kubectl -n ${NAMESPACE} attach -it -c ${EPH_CONTAINER_NAME} ${POD_NAME}
```

# Components

## Helmfile

When refactoring the Helmfile structure, you want to ensure that there are no unintended edits by executing e.g. `diff` and
comparing the output of Helmfile from before and after the change by calling:

```shell
helmfile template -e dev >output_to_compare.yaml
```

## MariaDB

When using the openDesk bundled MariaDB, you can explore the database(s) using the MariaDB interactive terminal from the Pod's command line: `mariadb -u root -p`. On the password prompt, provide the value for `MARIADB_ROOT_PASSWORD` which can be found in the Pod's environment.

While you will find all the details for the CLI tool in the [MariaDB documentation](https://mariadb.com/kb/en/mariadb-command-line-client/), some commonly used commands are:

- `help`: Get help on the psql command set
- `show databases`: Lists all databases
- `use <databasename>`: Connect to `<databasename>`
- `show tables`: Lists tables within the currently connected database
- `quit`: Quit the client

## Nextcloud

`occ` is the CLI for Nextcloud; all the details can be found in the [upstream documentation](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/occ_command.html).

You can run occ commands in the `opendesk-nextcloud-aio` pod like this: `php /var/www/html/occ config:list`

## OpenProject

OpenProject is a Ruby on Rails application. Therefore, you can make use of the Rails console from the Pod's command line `bundle exec rails console`
and run debug code like this:

```
uri = URI('https://nextcloud.url/apps/integration_openproject/check-config')
Net::HTTP.start(uri.host, uri.port,
 :use_ssl => uri.scheme == 'https') do |http|
 request = Net::HTTP::Get.new uri
 response = http.request request # Net::HTTPResponse object
end
```

## PostgreSQL

Using the openDesk bundled PostgreSQL, you can explore database(s) using the PostgreSQL interactive terminal from the Pod's command line: `psql -U postgres`.

While you will find all details about the cli tool `psql` in the [PostgreSQL documentation](https://www.postgresql.org/docs/current/app-psql.html)), some commonly used commands are:

- `\?`: Get help on the psql command set
- `\l`: Lists all databases
- `\c <databasename>`: Connect to `<databasename>`
- `\dt`: List (describe) tables within the currently connected database
- `\q`: Quit the client

## Keycloak

### Setting the log level

Keycloak is the gateway to integrate other authentication management systems or applications. It is undesirable to enable debug mode for the whole platform if you just need to look into Keycloak.

Enabling debugging mode for Keycloak can easily be achieved in two steps:

1. Updating the value for `KC_LOG_LEVEL` in the related configmap `ums-keycloak`.
```shell
export NAMESPACE=<your_namespace>
export CONFIGMAP_NAME=ums-keycloak
kubectl patch -n ${NAMESPACE} configmap ${CONFIGMAP_NAME} --type merge -p '{"data":{"KC_LOG_LEVEL":"DEBUG"}}'
```

2. Restart the Keycloak Pod(s).

> **Note**<br>
> Because the `ums-keycloak-extensions-handler` is sending frequent requests (one per second) to Keycloak for retrieval of the Keycloak event history, you might want to stop/remove the deployment while debugging/analysing Keycloak to not get your debug output spammed by these requests.

### Accessing the Keycloak admin console

Deployments set to `debug.enable: true` expose the Keycloak admin console at `http://id.<your_opendesk_domain>/admin/`. This can also be achieved by updating the Ingress `ums-keycloak-extensions-proxy` with an additional path that allows access to `/admin/`.

The admin console login is using the default Keycloak admin account `kcadmin` and the password from the secret `ums-opendesk-keycloak-credentials`.
