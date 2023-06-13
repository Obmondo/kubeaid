# Fluent Bit

Fluent bit is a tool to send logs from a variety of platforms to a target log destination
in commonly supported formats like GELF, JSON, MessagePack, etc.

## Kubernetes

Fluent bit runs on Kubernetes as a Daemonset on all nodes. It can send node metrics
as well as container logs from docker or containerd.

## Troubleshooting

Fluent bit pods sometimes get stuck in `CrashLoopBackOff` state. Describing the pod
will often reveal a `OOMKilled` error. This can happen due to long log lines or stacktraces
being logged in the pods. This goes to the `/var/log/<container-name-id>.log` on the underlying
node, from which the fluent bit reads the logs using a combination of Tail + Kubernetes filter.

When pods on a node start logging too much in their `STDOUT` and `STDERR` streams, these logs
start flooding fluent bit. This creates a backpressure as the speed of log generation is
faster than the flush to a specific log destination. This can occur due to network disruptions
too, as fluent bit would not be able to flush out its memory buffer to the log destination
while new logs are being constantly generated. This eventually forces fluent bit to stop
ingesting new logs and wait for the flush. So, log messages would be lost in this scenario.

Fluent bit offers a hybrid mode for data handling - `memory` or `filesystem`.
`Mem_Buf_Limit` setting on the Input plugin offers a limit on how much memory can all the
logs take up. It will discard the remaining data once the limit is reached.
Setting `storage.type` as `filesystem` offers a solution by persisting the data on the
filesystem if the memory has reached its limit.

Nuances: Fluent bit has an internal binary representation to process the data. However,
the target destination often needs a JSON, GELF or a similar format before sending the
data to servers. In this scenario, we must account for the memory usage of fluent bit
as it will be almost 1x-2x times the memory limit of the Input plugin.
Remembering the above helps in allocating correct memory requests and limits when running on k8s.

Usually, increasing the pod limits and input plugin memory limits fix the fluent bit
deployment. Take a look at the [Known Issues](#known-issues) and the Github discussions to
identify what might be incorrectly set in the fluent bit config.

## Known issues

- [Increasing Buffer size in fluent bit](https://github.com/fluent/fluent-bit/issues/3857#issuecomment-888938054)
- [Fluent bit stops automatically](https://github.com/fluent/fluent-bit/issues/4155/#issuecomment-1045189618)
- [Tail input paused](https://github.com/fluent/fluent-bit/issues/1903#issuecomment-1122130428)

## Docs

- https://docs.fluentbit.io/manual/
- https://docs.fluentbit.io/manual/pipeline/inputs/tail
- https://docs.fluentbit.io/manual/pipeline/filters/kubernetes
- https://docs.fluentbit.io/manual/pipeline/outputs/gelf
- https://docs.fluentbit.io/manual/local-testing/logging-pipeline
- https://docs.fluentbit.io/manual/administration/troubleshooting

## References

- [Buffering and Storage](https://docs.fluentbit.io/manual/administration/buffering-and-storage)
- [Log Backpressure](https://docs.fluentbit.io/manual/administration/backpressure)
- [Memory Management](https://docs.fluentbit.io/manual/administration/memory-management)
- [Amazon Cloudwatch Sample for Fluent bit](https://github.com/aws-samples/amazon-cloudwatch-container-insights/blob/main/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/fluent-bit/fluent-bit.yaml)
