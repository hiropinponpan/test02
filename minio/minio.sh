#!/bin/bash

if [ $# -ne 2 ]; then
  echo "usage: ${0##*/}  <env> <num>"
  echo "  env      : dev/stg/pro"
  echo "  num      : 1,2,3.."
  echo "example: ${0##*/} dev 1"
  exit 0
fi

set -eo pipefail
set -u

export env=$1
export num=$2

if [ $1 = "dev" ] || [ $1 = "stg" ]; then
  export repo="devmspksharbor.in.staffservice.co.jp"
elif [ $1 = "pro" ]; then
  export repo="promspksharbor.in.staffservice.co.jp"
else
  echo "env verify error!"
  exit 1
fi

export WORKDIR=./${env}${num}

kubectl apply -f storage-class-vsan.yml

mkdir -p $WORKDIR

cat << EOF > $WORKDIR/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
bases:
- ../base
images:
  - name: minio
    newName: ${repo}/install-packages/minio/minio
patchesStrategicMerge:
  - ingress.yml
generatorOptions:
  disableNameSuffixHash: true
EOF

cat << EOF > $WORKDIR/ingress.yml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: minio-ingress
spec:
  tls:
    - secretName: ${env}-ingress-cert
  rules:
  - host: ${env}0${num}.in.staffservice.co.jp
    http:
      paths:
      - path: /minio(/|$)(.*)
        backend:
          serviceName: minio-service
          servicePort: 9000
EOF

kubectl apply -k $WORKDIR
