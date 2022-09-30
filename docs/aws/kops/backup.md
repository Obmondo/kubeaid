# Dump the sealed secret certs

  1. Export the certs and keys of sealed secrets in case you want to apply/use the secrets of an existing cluster

     ```sh
     kubectl -n system get secret -l sealedsecrets.bitnami.com/sealed-secrets-key=active -o yaml | kubectl neat > ../../terraform/helm/allsealkeys.yml
     ```
