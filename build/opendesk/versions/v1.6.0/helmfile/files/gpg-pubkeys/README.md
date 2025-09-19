# GPG public keys

Place GPG public keys in binary format into this directory and reference them in the respective `helmfile.yaml.gotmpl`.

In case you have only an ASCII Armored file you can just base64 decode the payload of that file, but remember to
**not include** the 4-letter checksum that is prefixed with an `=` sign at the end of the payload.
