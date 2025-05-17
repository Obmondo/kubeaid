# ERPNext

## Adding modules that are not in standard image

To run erpnext with the Employee module included -you override values,see details for erpnext values (<https://helm.erpnext.com/faq.html#how-do-i-customize-values-for-the-erpnext-helm-chart>) and use an image that includes the module.

For HRMS module - its image resides here: (<https://github.com/frappe/hrms/pkgs/container/hrms>)

Example:

image:
  repository: ghcr.io/frappe/hrms
  tag: v15.41.0
