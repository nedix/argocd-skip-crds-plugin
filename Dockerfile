ARG ALPINE_VERSION=3.20
ARG TOOLS_VERSION=v0.64.0

FROM --platform=$BUILDPLATFORM ghcr.io/nedix/kubernetes-tools-docker:${TOOLS_VERSION} as tools

FROM --platform=$BUILDPLATFORM alpine:${ALPINE_VERSION}

COPY --link --from=tools /usr/local/bin/helm /usr/bin/helm
COPY --link --from=tools /usr/local/bin/kfilt /usr/bin/kfilt
COPY --link --from=tools /usr/local/bin/kubectl /usr/bin/kubectl
COPY --link --from=tools /usr/local/bin/kustomize /usr/bin/kustomize

RUN apk add \
        bash \
    && mkdir -p /home/argocd/.kube \
    && touch /home/argocd/.kube/config \
    && chown 999 /home/argocd/.kube/config

COPY --chown=nobody rootfs /

USER 999

WORKDIR /home/argocd/

ENV HOME=/home/argocd/

ENTRYPOINT ["/var/run/argocd/argocd-cmp-server"]
