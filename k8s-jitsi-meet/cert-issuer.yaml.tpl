apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: ${cluster_issuer_name}
  namespace: ${namespace_name}
spec:
  acme:
    email: ${email}
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: ${cluster_issuer_private_key_name}
    solvers:
    - http01:
        ingress:
          class: ${ingress_class_name}