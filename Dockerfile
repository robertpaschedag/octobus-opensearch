ARG OPENSEARCH_VERSION=3.9.0

FROM opensearchproject/opensearch:${OPENSEARCH_VERSION}

ARG OPENSEARCH_VERSION
ARG TARGETARCH
ARG YQ_VERSION=v4.44.3
ARG PLUGIN_VERSION=${OPENSEARCH_VERSION}.0

USER root

# Install yq
RUN curl -fsSL \
      "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_${TARGETARCH}" \
      -o /usr/local/bin/yq \
    && chmod +x /usr/local/bin/yq

USER opensearch

# Install snapshot repository plugins
RUN opensearch-plugin install --batch repository-s3 \
    && opensearch-plugin install --batch repository-azure \
    && opensearch-plugin install --batch repository-gcs

# Install Prometheus exporter plugin
RUN opensearch-plugin install --batch \
      "https://github.com/opensearch-project/opensearch-prometheus-exporter/releases/download/${PLUGIN_VERSION}/prometheus-exporter-${PLUGIN_VERSION}.zip"
