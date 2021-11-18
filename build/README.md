I have added the kube-prometheus that contains the build.sh, example.jsonnet and obmondo.jsonnet(with our config)

For the Makefile, run ```make setup``` to install jb, initialize it and fetch the build.sh, vendor and other files, although they have been created in the ```kube-prometheus``` folder. ```make build``` compiles the manifests 

The command ```./build.sh example.jsonnet``` when run, will build the manifest(yaml) files. "obmondo.jsonnet" is where our config is being added to the default one. A ```./build.sh obmondo.jsonnet``` should build it but it isn't reflecting yet, still working on it.

Any ideas/suggestions are welcomed...
