kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.10.1/cert-manager.yaml

kubectl -n whrr create -f - <<EOF
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt-prod
  namespace: whrr
spec:
  acme:
    email: shuxx@zkturing.com
    privateKeySecretRef:
      name: letsencrypt-prod
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
    - http01:
        ingress:
          class: nginx
EOF

kubectl -n whrr create -f - <<EOF
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: staging-kubesphere-io
  namespace: whrr
spec:
  commonName: ruiran119.cn
  dnsNames:
  - ruiran119.cn
  duration: 2160h
  issuerRef:
    name: letsencrypt-prod
  renewBefore: 360h
  secretName: staging-kubesphere-io
EOF



kubectl create -f - <<EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: shuxx@zkturing.com
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: nginx
EOF	


kubectl create -f - <<EOF
kind: Ingress
apiVersion: extensions/v1beta1
metadata:
  name: qxyj
  namespace: tmc-v2-test
  annotations:
    kubesphere.io/alias-name: 站点注册1
    kubesphere.io/creator: duanqq
    kubesphere.io/description: qxyj.iot.store
    cert-manager.io/cluster-issuer: letsencrypt-prod #自动更新证书
spec:
  tls:
    - hosts:
        - qxyj.iot.store
      secretName: tmc-v2-tls
  rules:
    - host: qxyj.iot.store
      http:
        paths:
          - path: /
            pathType: ImplementationSpecific
            backend:
              serviceName: turingcloud-web
              servicePort: 80
EOF	
	  
