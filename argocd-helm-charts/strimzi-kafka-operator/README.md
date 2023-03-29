# Strimzi kafka operator

## operational tips

- Many configuration changes requires a rolling restart, and
  during a rolling restart the controller that is elected the controller MUST be rolled last.
- Between each roll, the cluster must be fully in-sync to satisfy min.in-sync.replicas.
- Every kafka broker (pod) must be directly reachable by clients.
