Matomo + MariaDB con Terraform (kind)

Requisitos:
- kind + kubectl + Terraform
- Contexto Kubernetes: kind-kind
- StorageClass 'standard' (kind lo trae por defecto)

Pasos:
1) terraform init
2) terraform apply
3) Verifica:
   kubectl get deploy,svc,pvc,pod

Acceso desde el host:
- Opción 1 (recomendada): port-forward
  kubectl port-forward svc/service-matomo 8082:80
  -> http://localhost:8082

- Opción 2 (si creaste el clúster kind con extraPortMappings para 30003):
  http://localhost:30003

Notas:
- Variables y credenciales están en texto plano (simplificación para el ejercicio).
- PVCs: 512Mi para MariaDB y Matomo (persistencia local en kind).
