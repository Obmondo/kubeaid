# Create one master per AZ
{{range .availability_zones.value}}
apiVersion: kops/v1alpha2
kind: InstanceGroup
metadata:
  labels:
    kops.k8s.io/cluster: {{$.cluster_name.value}}
  name: master-{{.}}
spec:
  additionalUserData:
  - content: |
      #!/bin/sh
      # Alienvault
      echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDgjmqOC7ghLNqK6CkD7YTpCw4rpC5CblAndACCpZ+3xXnT8qrNDxzCVj1O2QnWQw8w0J4WUBKhePClAlF3HUnXPxvBzAFGlxrkdfS6ndAy4T/Ew1healjxDF7mOcuDwoBPuLVEXwPYJ3OFUrOKajRcvP85AGO0MYAbVyVg/ANsiTmVp+T70UfHtYG6MQdTIO+wpcHAgHFV/yotaQTKNA5HpvbxP5qdjrlas1T5XXBoKV9HVXL0ipTBj4OFNFYF+FDKVfdM4MvrktFXzzGHGWtn/QkWxMvPOrnKFRhxvFse0YyKOV5wLtsdjdX23NKgC6skayAFiY/+T2Y5mcnIz3zOm0hCOtdVpaajWfJyIrSKz4UmuGtCfdyX4jqLOgtqByHGwMzHtkjfr3m+eqDvxyRLlEIEpITYdkIe2t5emeBTKHl2NrrC7btvL4Awz4azKkdTDgdXl7FUgL2537N8EYnQ8DHZrImsJkpV+hIwwSuZAGr6enfrObYTzyWbEo0HttXbot9iNWNjcf5aLZTNoPSM+gE/C3BTJs4ykjM9Aq1SC9qQwqeXvvv3x529tOW0SnrohVnNFn/Z41+nfYK6TC5ZNihBdKXkBQUi9YaLJs0jlYg9aDA0fhYDYr8OJOT1xRUwm/zfM7Je6QykS2fqAQRUEWknmfshVHrzY61IeSbWhQ== cardno:000606305931 Klavs' >> /home/ubuntu/.ssh/authorized_keys
      echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDAhxkaT6cj+uRLA/wWu5d+5yun6NQXeUOE0tqGi6H8Dn3ZqC6wlYK7uHwOxZILJGa4X/kzGWHlZ6wfZw6lgbqunkJHLf3oXXI1cJGBkzPVBYkCnJItSP19fAty5C//SxNYlngicf+vowWdlq6O4ECkH7NdmVne4MHYz2DpRMjobjKDB1OW/0ESBlZhxzevwNnNqVdwXoz8852PQqo41w/uUAx5393Wj/VF2WB20HDWy97Ye6m3eV+ZMGiTJkumaNQ7JPdRTeNpl8zPwLJ0X0FS4H8z7wGfrUpVzlGuXjSGN3TxTewEW2WnD5yL0XRZznVBGARH71ut23VtFS8Fo8xsPn1ePjHho2BBviAxQ2ACp4UkzMt40lQNR7jtNZY/e2ZYMRVfJ+3cJgGfiwBfDjo6fgdPZowmGMJa0ydKT/WTt5LjEIiACFUMrMwn8yauXHybZCnUCduY/9AqSqh3ut0fKOsUS4tjj6/UUGDOjHE60nOvv3P7vCHQZqoznxC6oirYbTCCqQAK4Gm7vyNvzA5ep/4xMcp3vJVIKMj9z3sCSuvQYD2NsuC3H128FUYNjQMt2Z8dFO0oWme/x8Ghj9KEPLHGk452gif0JNzAgRRsXVmvGClx5XrrTa0jBAn7uT9DOZYMRPKYM7bluR2RtjHY1creHuH1DXTY3xaoUX65lw== cardno:000604694743 Ashish' >> /home/ubuntu/.ssh/authorized_keys
      echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDHZiRXdzE7ksg9FB52pL3QtB2DwzGpHUTTboilue7aT3XX4EojmCa7XJQyzX7s/q/ZBpUAhjXmz+avOLrm1HtS8FZQqB6FypDIxjcydNVqMBZKgFq788DBzfHAg06LNbNhr1rwDmHHOblivUm5OtTPnwBF1DXy0gScoTHGs0zWWjloDtCbQCoEcXoqtZIYUFKL1h0G+/sKfqwK8Oai3QYDq8OQ620UgfpyLh8FdlMRthuaeVH5dvPXACxbxXVuBo2PxzXtZkUvWe1E7VL2FzQg2yZEkjSMvBAkRrbWS6Dy4ox2rEsuz77HdVcurmSPTWzrU9XjUPoliAfek7yXdHdzGZbZKnO1K8MZe2CXQlmHlvP4iNQetS5kWdGNYB+nliSt7scD7YMF+3XE3aOad0YzqJ6oD1GpjVShIFpfimK7/hX2TrnWiutMEOdAZmCYrDSHClMjUlbpcZ7LPgBZfCQ3Q0JWelHTUKkbuUmh6PLN69GcCQvvJd8JH8+gytH3+h+exHo9YxDhO7SnfWc0C1JkW46+hnjvdSx3sxKthY0aN8dRtqYVtDRBx1ePRQ1G9JqGpJiWrKdopxP4T82uAt/z/687TIOSSHN5HCPz2pawDMdyp93m1Z3jz7wE1B9o40iJtFN9+I4Qj36XdiktcFhvTWa5XoTyx+TDYu7sbf1GXQ== cardno:000606305901 Rune' >> /home/ubuntu/.ssh/authorized_keys
      echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQD0xNXDwqOd7g394DitNlxz4YLJ8c8aPEZfPWskuF1s0IC5TLW/ymWtWpgfktU1BgkQWF5xE3QirqEZHdrLPFyBn7EgHq+IdPWUxxfoAHuH1FG7+xkRmfN+HPqgoDSi7PJefJ82NIepCiS78WBgFmgTJTKcF1CRaXangJSKoly5B6rQA8sk+MkotSAhjZhQYBxFbVB6BNjiC6Ui5p2h81crR5MLsPo8RHB4Dk9JkSzC++x+QwgSWCxztuR936h/gP+q6utsRqYT9vRr+BYmgN58uWbDeT1uUWVmQKyN3iWyEDjFa9Z8ZscdQqekb6NaxxUquRVVEhCDho244y7PR4pzHafISiMgaR/MShX2Yh5pAnKGRR5hyNm9bwjtQnXR7+7lTIzKsFgxgqg6DJTxkvqLPCT15MXDKK2SBGZUo9aIRwmPZeA8rLxTYC50adm2Cdn1KgfjtYvomupxBtxQkzNPsaEDiivRbLjMx2uovkXaRfNRr0BX73Of6iBTrzuhnI5iUcRO/lP0x/3aWNl38w4qRtCcWywyf1ugaphG7a6f3NHtvUeYPA3YMpV45tM1cqSQ3lM3qCz9oeH/3JrLNU36PBL0PRPKGDjNhtEALUY7R0GpDDsY6OYtXNAv1cGbOkr+q4rZg1qwOjAnm0q/0//yiocxxiH3Z4cZSPTUX95Q== cardno:000606914847 Aman' >> /home/ubuntu/.ssh/authorized_keys
    name: addPublicKey.sh
    type: text/x-shellscript
  image: {{$.master_image_id.value}}
  machineType: {{$.master_machine_type.value}}
  maxSize: {{$.master_max_size.value}}
  minSize: {{$.master_min_size.value}}
  role: Master
  nodeLabels:
    kops.k8s.io/instancegroup: master-{{.}}
    instancegroup: master-{{.}}
    lifecycle: normal
  subnets:
  - {{.}}
---
{{end}}
