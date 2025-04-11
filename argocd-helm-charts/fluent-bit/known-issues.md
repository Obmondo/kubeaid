# Known Issues in Fluent Bit

## Fluent Bit Unable to send logs

```
[2025/04/11 06:56:52] [ warn] [net] getaddrinfo(host='graylog-input.example.com.', err=12): Timeout while contacting DNS servers
```

Verify if the DNS is correct and reachable from your machine for the output of fluent bit

```
faizan@ThinkPad:~$ dig +short graylog-input.example.com
10.2.119.118
10.2.78.221
10.2.39.178
```

Verify if the graylog port is open and reachable from your machine. Connect to the VPN if
graylog is running in an internal private network.

```
faizan@ThinkPad:~$ nc -zv graylog-input.example.com 5555
Connection to graylog-input.example.com (10.2.78.221) 5555 port [tcp/*] succeeded!
```

Create a test ubuntu pod in the same namespace and try the `dig` and `netcat` command above from inside the pod.

If the DNS is not resolved, or the netcat times out, check if there are any network policies blocking the fluent-bit pod.
The default netpol should at least allow the UDP on port 53 for DNS lookup, and the TCP on graylog port(5555 in this case).

Despite this, if the fluent bit pods cannot do the DNS lookup, then try restarting one of the pods.
This is sometimes necessary, as the CNI pods (Calico, Cilium, etc) handle the network connections to the graylog target.

To debug from inside the pod, you will need to change the image of fluent bit to `-debug`, as the default image does not support
an interactive shell. Add -debug to the end of the image, like `fluent/fluent-bit:4.0-debug`.
Then you should be able to see if the pod can connect to the target graylog.