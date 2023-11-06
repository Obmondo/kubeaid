package cronjobforbidconcurrency

test_forbid_concurrency_policy {
    input := {
        "kind": "CronJob",
        "metadata": {"name": "forbid-concurrency-cronjob"},
        "spec": {"concurrencyPolicy": "Forbid"}
    }
    violations := violation with input as input
    count(violations) == 0
}

test_allow_concurrency_policy {
    input := {
        "kind": "CronJob",
        "metadata": {"name": "allow-concurrency-cronjob"},
        "spec": {"concurrencyPolicy": "Allow"}
    }
    violations := violation with input as input
    count(violations) == 1
}

test_replace_concurrency_policy {
    input := {
        "kind": "CronJob",
        "metadata": {"name": "replace-concurrency-cronjob"},
        "spec": {"concurrencyPolicy": "Replace"}
    }
    violations := violation with input as input
    count(violations) == 1
}

test_empty_concurrency_policy {
    input := {
        "kind": "CronJob",
        "metadata": {"name": "empty-concurrency-cronjob"},
        "spec": {"concurrencyPolicy": ""}
    }
    violations := violation with input as input
    count(violations) == 1
}

test_null_concurrency_policy {
    input := {
        "kind": "CronJob",
        "metadata": {"name": "null-concurrency-cronjob"},
        "spec": {"concurrencyPolicy": null}
    }
    violations := violation with input as input
    count(violations) == 1
}
