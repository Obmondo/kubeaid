# Crossplane Azure Integration

## Overview

This project provides a set of Helm templates for managing Azure and AWS resources using
Crossplane. It enables the creation and management of Azure Virtual Networks (VNet) and
associated resource groups through declarative configuration.

## Prerequisites

- **Crossplane**: You must have [Crossplane](https://crossplane.io/docs/) installed in your Kubernetes cluster.

## Configuration

### Values File

Edit the `values.yaml` file to specify your Azure resources:

- **location**: The Azure region where the resources will be created.
- **defaultSubscription**: The default Azure subscription to use if no specific providerConfigRef is provided.
- **defaultRgName**: The default resource group name.
- **vnet**: Define your Virtual Networks here resource group associations.

**Example `values.yaml`:**

```yaml
location: North Europe
subscription: default
defaultRgName: rgcrossplane
resourceGroup:
  rgcrossplane:
    location: North Europe
  rgcrossplane1:
    location: North Europe
vnet:
  vnet-crossplane1:
    cidrBlock: 10.0.0.0/16
    rgName: rgcrossplane1
    providerConfigRef:
      name: default
  vnet-crossplane2:
    cidrBlock: 10.0.0.0/16
```
