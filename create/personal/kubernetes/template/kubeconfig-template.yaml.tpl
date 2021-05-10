apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${cluster_ca_cert}
    server: https://${cluster_endpoint}
  name: ${context}
contexts:
- context:
    cluster: ${context}
    user: ${context}
  name: ${context}
current-context: ${context}
kind: Config
preferences: {}
users:
- name: ${context}
  user:
