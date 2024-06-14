ARG ALPINE_VERSION=3.20
ARG KUBERNETES_TOOLS_VERSION=v2.0.1-scratch

FROM --platform=$BUILDPLATFORM ghcr.io/nedix/kubernetes-tools-docker:${KUBERNETES_TOOLS_VERSION} as tools

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
