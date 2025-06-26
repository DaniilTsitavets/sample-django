# Deployment Documentation

## Deployment Steps

1. **Kubernetes Cluster Setup**
    - Deployed on AWS EKS.
    - Used EC2 instances as worker nodes.
    - Checked pods distribution on nodes with:
     ```bash
     kubectl get pods -A -o wide
     ```


2. **NGINX Ingress Controller Installation**
    - Installed via Helm from the official repo.
    - Service type: LoadBalancer, providing external access.
    - Installed via Helm:
     ```bash
     helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
     helm repo update
     helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace
     ```
    - Verified the service and external IP with:
     ```bash
     kubectl get svc -n ingress-nginx
     ```

3. **Application Deployment with Helm**
    - Created a Helm chart including Deployment, Service, and Ingress.
    - Added readiness and liveness probes.
    - Configured HorizontalPodAutoscaler to scale replicas from 2 to 4 based on CPU usage (80% threshold).
    - Deployed the application using:
     ```bash
     helm upgrade --install django ./helm_chart -n default
     ```
    - Or with helmfile:
     ```bash
     helmfile apply
     ```

   
4. **CertManager Setup**
    - Added CertManager and ClusterIssuer templates to the Helm chart.
    - Disabled CertManager activation since a domain name was not available, so no certificate was issued or tested.


5. **Deployment with helmfile**
    - Used `helmfile` to automate Helm releases management and environment deployment.

---


## Why Kubernetes and Helm?

- **Kubernetes**  
  Provides automated scaling, self-healing, and declarative management of containerized apps, allowing robust production-grade deployments.


- **Helm**  
  Simplifies managing Kubernetes manifests by templating, parameterization, and packaging.

  Integration with sops provides solution for encrypting secrets, but ESO is anyway better.

---

## Notes

- Probes (readiness/liveness) use `/` as endpoint.
- As far as a domain is not available CertManager can not be used.
