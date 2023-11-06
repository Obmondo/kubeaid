package cronjobforbidconcurrency

violation[{"msg": msg}] {
    input.kind == "CronJob"
    not input.spec.concurrencyPolicy
    msg := sprintf("CronJob <%v> is missing the concurrencyPolicy field", [input.metadata.name])
}

violation[{"msg": msg, "actual": actual, "expected": "Forbid"}] {
    input.kind == "CronJob"
    actual := input.spec.concurrencyPolicy
    actual != "Forbid"

    msg := sprintf("CronJob <%v> has concurrencyPolicy set to <%v> instead of 'Forbid'", [input.metadata.name, actual])
}