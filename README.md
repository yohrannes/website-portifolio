# Website Portfolio - Yohrannes Santos Bigoli 🌐

This project is a practical and robust demonstration of how to build, monitor, and operate a modern application using the best practices in **DevOps**, **web development**, and **cloud infrastructure**. It is designed to be highly scalable, secure, and easy to integrate into production environments.

---

## 🚀 **Overview**

The Website Portfolio combines:
- **Backend in Flask**: A lightweight and efficient Python framework.
- **Monitoring and Observability**: With **Prometheus**, **Grafana**, and **cAdvisor**.
- **Infrastructure Automation**: Using **Terraform** and **GitLab CI/CD**.
- **Advanced Security**: Configured **Fail2Ban** to protect against malicious attacks.

This project is ideal for professionals who want to learn or implement modern development and operational solutions.

---

## 🛠️ **Technologies Used**

### **Backend**
- **Flask**: Python framework for web development.
- **Gunicorn**: WSGI server for production.

### **Frontend**
- HTML, CSS (with custom animations), and JavaScript.

### **DevOps and Infrastructure**
- **Docker**: Containers for all services.
- **Docker Compose**: Local orchestration.
- **Kubernetes**: Deployments in managed clusters.
- **Terraform**: Infrastructure automation.
- **GitLab CI/CD**: Pipelines for automated builds, tests, and deployments.

### **Monitoring**
- **Prometheus**: Metrics collection.
- **Grafana**: Interactive dashboards.
- **cAdvisor**: Container monitoring.

### **Security**
- **Fail2Ban**: Protection against brute force and malicious injection attacks.

---

## 📂 **Repository Structure**

- **`build-app/`**: Dockerfile and scripts for the Flask backend.
- **`docker-compose/`**: Configuration for Docker Compose and NGINX.
- **`pipelines/`**: GitLab CI/CD pipeline configurations.
- **`kubernetes/`**: Kubernetes manifests for deployment.
- **`iac/`**: Terraform configurations for infrastructure provisioning.
- **`static/`**: Static files (CSS, JS, images).
- **`templates/`**: HTML templates for the website.

---

## 🌟 **Key Features**

### **1. Monitoring and Observability**
- Real-time container metrics with **cAdvisor**.
- Interactive dashboards in **Grafana**.
- Configurable alerts in **Prometheus**.

### **2. CI/CD Automation**
- GitLab pipelines for:
  - Building and deploying Docker images.
  - Provisioning infrastructure with Terraform.
  - Automated deployments to Kubernetes.

### **3. Security**
- **Fail2Ban** configured to protect against:
  - Malicious HTTP/HTTPS requests.
  - Brute force attacks.

### **4. Kubernetes Deployment**
- Managed deployments in OKE clusters.
- Ingress configuration with **NGINX** and **cert-manager**.

---

## 🖥️ **How to Run Locally**

### **Prerequisites**
To run this project locally, you will need:
- **Docker**: [Install Docker](https://docs.docker.com/get-docker/)
- **Docker Compose**: [Install Docker Compose](https://docs.docker.com/compose/install/)
- **Python 3.8+**: [Install Python](https://www.python.org/downloads/) (optional for development).
- **Terraform**: [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- **GitLab Runner**: [Install GitLab Runner](https://docs.gitlab.com/runner/install/)

### **Steps**
1. Clone the repository:
   ```bash
   git clone https://gitlab.com/yohrannes/website-portifolio.git
   cd website-portifolio
2. Start the containers using Docker Compose:
   ```bash
   docker compose up -d
3. Access the website in your browser:
   ```bash
   http://localhost
4. View the latest Docker logs:
   ```bash
   docker logs -f $(docker ps -lq)

## 🌐 **Deploying to Production**

### **1. Kubernetes Deployment**
- Ensure your Kubernetes cluster is configured.
- Apply the manifests:
  ```bash
  kubectl apply -f kubernetes/

---

## 🔍 **How to Contribute**

Contributions are welcome! Follow these steps to collaborate:

1. Fork the repository.
2. Create a branch for your feature or fix:
   ```bash
   git checkout -b my-feature
3. Make your changes and commit them:
   ```bash
   git commit -m "Add new feature"
4. Push your changes:
   ```bash
   git push origin my-feature
5. Open a Pull Request.

---

## 📄 **License**

This project is licensed under the [MIT License](LICENSE).

---

## 📞 **Contact**

- **LinkedIn**: [Yohrannes Santos Bigoli](https://www.linkedin.com/in/yohrannes)
- **GitHub**: [@yohrannes](https://github.com/yohrannes)
- **GitLab**: [@yohrannes](https://gitlab.com/yohrannes)

---

**Explore, contribute, and learn!** 🚀