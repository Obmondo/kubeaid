# How-To Instruction for Using Your Pre-Generated Puppet Certs

Please archive the contents of your `/etc/puppetlabs/puppet/ssl/*` of your bare-metal Puppet Server master and `/opt/puppetlabs/server/data/puppetdb/certs/*` of your bare-metal PuppetDB instance into two separate `.gz` files and place them respectively into the `puppet-certs/puppetserver` and `puppet-certs/puppetdb` directories.

> **NOTE**: Please keep only your archive files in each `puppet-certs/` subdir.

The content of the two archives should be very similar to:

```console
root@puppet:/# ll /etc/puppetlabs/puppet/ssl/
total 36
drwxr-x--- 4 puppet puppet 4096 Nov 26 20:21 ca/
drwxr-xr-x 2 puppet puppet 4096 Nov 26 20:21 certificate_requests/
drwxr-xr-x 2 puppet puppet 4096 Nov 26 20:21 certs/
-rw-r----- 1 puppet puppet  950 Nov 26 20:21 crl.pem
drwxr-x--- 2 puppet puppet 4096 Nov 26 20:21 private/
drwxr-x--- 2 puppet puppet 4096 Nov 26 20:21 private_keys/
drwxr-xr-x 2 puppet puppet 4096 Nov 26 20:21 public_keys/

root@puppetdb:/opt/puppetlabs/server/data/puppetdb/certs# ls -l
total 20
drwxr-xr-x 2 puppetdb puppetdb 4096 Dec  5 21:49 certificate_requests
drwx------ 2 puppetdb puppetdb 4096 Dec  5 22:36 certs
-rw-r--r-- 1 puppetdb puppetdb  950 Dec  5 21:49 crl.pem
drwx------ 2 puppetdb puppetdb 4096 Dec  5 22:36 private_keys
drwxr-xr-x 2 puppetdb puppetdb 4096 Dec  5 21:49 public_keys
```

The content of the `init/puppet-certs/puppetserver` and `init/puppet-certs/puppetdb` chart's dirs should be similar to:

```console
/repos/xtigyro/puppetserver-helm-chart # ll init/puppet-certs/puppetserver/
total 24
drwxrws--- 2 xtigyro-samba sambashare  4096 Dec  5 22:00 ./
drwxrws--- 4 xtigyro-samba sambashare  4096 Dec  5 21:45 ../
-rw-rw---- 1 xtigyro-samba sambashare    71 Dec  5 21:45 .gitignore
-rw-r--r-- 1 xtigyro-samba sambashare 10013 Dec  5 22:00 puppetserver-certs.gz

/repos/xtigyro/puppetserver-helm-chart # ll init/puppet-certs/puppetdb/
total 24
drwxrws--- 2 xtigyro-samba sambashare  4096 Dec  5 22:00 ./
drwxrws--- 4 xtigyro-samba sambashare  4096 Dec  5 21:45 ../
-rw-rw---- 1 xtigyro-samba sambashare    71 Dec  5 21:45 .gitignore
-rw-r--r-- 1 xtigyro-samba sambashare 10158 Dec  5 22:00 puppetdb-certs.gz
```
