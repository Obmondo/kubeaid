FROM harbor.obmondo.com/obmondo/dockerfiles/jammy-generic-build@sha256:2145c7adffd30bc0d38f32c2b814fd60a537c7886a749e799daa9848707fd51f

LABEL org.opencontainers.image.authors="Ashish Jaiswal <ashish@enableit.dk>"

ENV GOPATH="/root/go"
ENV PATH="/usr/lib/go-1.19/bin:${GOPATH}/bin:${PATH}"

WORKDIR /tmp

RUN apt-get update                                          \
    && apt-get install software-properties-common -y        \
    && add-apt-repository ppa:rmescandon/yq -y              \
    && add-apt-repository ppa:longsleep/golang-backports -y \
    && apt-get update                                       \
    && apt-get install -y                                   \
        shellcheck                                          \
        prometheus                                          \
        golang-1.19                                         \
        yq                                                          

# jsonnet
RUN go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@v0.5.1
RUN go install github.com/brancz/gojsontoyaml@latest
RUN go install github.com/google/go-jsonnet/cmd/jsonnet@v0.20.0
RUN go install github.com/google/go-jsonnet/cmd/jsonnetfmt@latest

# helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
RUN chmod +x get_helm.sh
RUN ./get_helm.sh --version v3.9.1

# OPA
RUN wget https://github.com/open-policy-agent/opa/releases/download/v0.43.0/opa_linux_amd64_static -O /usr/local/bin/opa
RUN chmod +x /usr/local/bin/opa
