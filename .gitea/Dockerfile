FROM harbor.obmondo.com/obmondo/dockerfiles/noble-generic-build@sha256:7db3fa938fb169b94c60599665ba9f740a1c7a1223dd47092dcf082469d8c24b

LABEL org.opencontainers.image.authors="Ashish Jaiswal <ashish@enableit.dk>"

ENV GOPATH="/root/go"
ENV PATH="/usr/lib/go-1.19/bin:${GOPATH}/bin:${PATH}"
ENV PROMTOOL_VERSION="2.55.0"

WORKDIR /tmp

RUN apt-get update                                          \
    && apt-get install software-properties-common -y        \
    && add-apt-repository ppa:longsleep/golang-backports -y \
    && apt-get update                                       \
    && apt-get install -y                                   \
    shellcheck                                              \
    golang

# jsonnet
RUN go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@v0.5.1
RUN go install github.com/brancz/gojsontoyaml@latest
RUN go install github.com/google/go-jsonnet/cmd/jsonnet@v0.20.0
RUN go install github.com/google/go-jsonnet/cmd/jsonnetfmt@latest
RUN go install github.com/monitoring-mixins/mixtool/cmd/mixtool@main

# promtool
RUN wget https://github.com/prometheus/prometheus/releases/download/v${PROMTOOL_VERSION}/prometheus-${PROMTOOL_VERSION}.linux-amd64.tar.gz
RUN tar -xvzf prometheus-${PROMTOOL_VERSION}.linux-amd64.tar.gz
RUN mv prometheus-${PROMTOOL_VERSION}.linux-amd64/promtool /usr/local/bin/

# helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
RUN chmod +x get_helm.sh
RUN ./get_helm.sh --version v3.9.1

# OPA
RUN wget https://github.com/open-policy-agent/opa/releases/download/v0.43.0/opa_linux_amd64_static -O /usr/local/bin/opa
RUN chmod +x /usr/local/bin/opa

# YQ
RUN wget https://github.com/mikefarah/yq/releases/download/v4.44.3/yq_linux_amd64 -O /usr/local/bin/yq
RUN chmod +x /usr/local/bin/yq

# Add kubeaid argocd app update script
COPY bin/update-kubeaid-argocd-app.sh /usr/bin/update-kubeaid-argocd-app.sh

WORKDIR /workspace
