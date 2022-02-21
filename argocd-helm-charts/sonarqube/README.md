# Sonarqube

## summary

SonarQube is a Code Quality Assurance tool that collects and analyzes source code, and provides reports for the code quality of your project.

It needs to be integrated with your CI pipelines and will then send code to this application to do its work.

NB. This application is by default setup to REQUIRE postgres-operator application on the cluster.

-   The pgsql user to be created is stated in the ```postgres.yaml``` in ```sonarqube/templates``` as ```sonarqube_admin```.

Backup of this applications data, is handled via postgres-operator application.