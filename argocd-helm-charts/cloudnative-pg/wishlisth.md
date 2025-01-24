Improvements wishlist:
- Document how to do backups, via a seperate instance - created from PV snapshot.
  This helps with larger databases, where a full backup locks tables for hours and slows down queries in that period.
- Document and setup monitoring using the cloudnative monitoring metrics set and add the grafana dashboard in a mixin and maybe even build alerts
- Document how to add the cnpg plugin to kubectl (on your local machine) to more easily do DBA work with cnpg operator instances
