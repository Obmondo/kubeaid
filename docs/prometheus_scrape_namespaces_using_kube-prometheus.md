# Configuring Prometheus to Scrape Namespaces with Kube-prometheus

This guide will walk you through the process of configuring Prometheus to scrape specific namespaces in your Kubernetes
cluster using kube-prometheus and the `vars.jsonnet` file.

## Prerequisites

Before proceeding with the configuration, ensure you have completed the following prerequisites:

1. Install kube-prometheus: Follow the installation guide for kube-prometheus to set up Prometheus, Grafana, and other
required components in your cluster.

2. JSONnet Vars File: Ensure you have the `vars.jsonnet` file, which contains the configuration variables for
kube-prometheus. Modify it according to your requirements.

## Configuration Steps

1. Open the `vars.jsonnet` file:
   - Locate the `kubeaid-config/k8s/<clustername>/<clustername>-vars.jsonnet` file for your Kubernetes cluster.
   - Open the file in a text editor.

2. Set the Prometheus Scrape Namespaces:
   - In the `kubeaid-config/k8s/<clustername>/<clustername>-vars.jsonnet` file, locate the `prometheus_scrape_namespaces`
   field.
   - Modify the field to include the namespaces you want Prometheus to scrape.
   - For example, if you want Prometheus to scrape the `rook-ceph` and `logging` namespaces, update the field as follows:

     ```jsonnet
     prometheus_scrape_namespaces: [
       'rook-ceph',
       'logging',
     ],
     ```

3. Save the changes:
   - Save the `kubeaid-config/k8s/<clustername>/<clustername>-vars.jsonnet` file after making the necessary modifications.

4. Regenerate kube-prometheus YAML:
   - Run the script to regenerate the kube-prometheus YAML files using the
   `kubeaid-config/k8s/<clustername>/<clustername-vars>.jsonnet` file.
   - Use the following command:

     ```bash
     kubeaid/build/kube-prometheus/build.sh /path/to/kubernetes-config-company/k8s/production.company.io/production.company.io-vars.jsonnet
     ```

   - Replace the paths with the appropriate locations for your setup.

5. Commit and Sync:
   - Commit the changes made to the `kubeaid-config/k8s/<clustername>/<clustername>-vars.jsonnet` file to your cluster
   configuration repository.
   - Sync the changes to apply the new configurations.

6. Verify the Configuration:
   - Ensure that the Prometheus server is scraping the desired namespaces.
   - Access the Prometheus UI using port forwarding or any other method.
   - Navigate to the "Status" menu in the Prometheus UI.
   - Verify that the listed targets include the services and pods from the specified namespaces.
   - If the targets are correctly scraped, Prometheus is successfully configured to monitor the selected namespaces.

You have now successfully configured Prometheus to scrape specific namespaces using kube-prometheus and the `vars.jsonnet`
file. Prometheus will now collect metrics from the specified namespaces and make them available for monitoring and analysis.

Remember to adjust the paths and namespaces based on your actual configuration.
