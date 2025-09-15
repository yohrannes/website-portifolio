# Website Portfolio - Yohrannes Santos Bigoli 🌐

Este repositório é um blueprint funcional e de nível de produção para a construção, implantação e observabilidade de um ecossistema de aplicações web modernas. O projeto foi arquitetado para demonstrar práticas de engenharia de software e DevOps em um cenário real, com foco em automação, resiliência e segurança.

## Arquitetura e Filosofia

O objetivo deste projeto vai além de um simples portfólio. Ele serve como uma demonstração prática de um ciclo de vida de desenvolvimento de software completo, desde o provisionamento da infraestrutura até o monitoramento contínuo em produção.

A filosofia é simples: **automação em tudo**. A infraestrutura é declarativa (IaC), os deploys são automatizados (CI/CD), e a observabilidade é integrada nativamente para permitir a detecção proativa de falhas e a análise de performance.

---

## Stack de Tecnologia

A seleção de tecnologias foi feita para refletir um ambiente de produção moderno, priorizando ferramentas open-source, maduras e amplamente adotadas pela indústria.

| Categoria | Ferramenta | Propósito |
| :--- | :--- | :--- |
| **Aplicação** | Flask (Python), Gunicorn | Backend leve, performático e escalável para servir a API e as páginas web. |
| **Proxy Reverso & Load Balancer** | Nginx | Ponto de entrada para todo o tráfego, com terminação SSL, caching e métricas de alta performance. |
| **Infraestrutura como Código** | Terraform, Packer | Provisionamento e gerenciamento declarativo da infraestrutura na OCI. O Packer é usado para criar imagens de máquina imutáveis. |
| **Containerização** | Docker, Docker Compose | Empacotamento da aplicação e suas dependências em contêineres para garantir consistência entre ambientes. |
| **Orquestração** | Kubernetes (OKE) | Implantação em um ambiente de contêineres orquestrado para alta disponibilidade e escalabilidade. |
| **CI/CD** | GitLab CI/CD | Automação completa do ciclo de build, teste e deploy, com pipelines modulares e dinâmicos. |
| **Observabilidade** | Prometheus, Grafana, cAdvisor, OpenTelemetry | Coleta de métricas, logs e traces para uma visão holística da saúde e performance do sistema. |
| **Segurança** | Fail2Ban, Cloudflare | Proteção ativa contra ataques de força bruta e injeção (Fail2Ban) e gerenciamento de DNS/WAF (Cloudflare). |

---

## Destaques da Arquitetura

Este projeto implementa soluções para desafios comuns em engenharia de software e operações.

#### 1. **Infraestrutura como Código (IaC) com Terraform Cloud**
Toda a infraestrutura na Oracle Cloud (OCI) é gerenciada via Terraform. O uso do **Terraform Cloud** para o gerenciamento do *state file* e para a execução dos *runs* garante um fluxo de trabalho colaborativo, seguro e auditável, desacoplando a execução da máquina local do desenvolvedor.

#### 2. **Pipeline de CI/CD Automatizado**
A pipeline no GitLab CI/CD orquestra todo o processo de deploy. Para a implantação em VM, o fluxo é:
- **Provisionamento**: Aciona um *run* no Terraform Cloud para criar ou atualizar a instância.
- **Validação**: Aguarda o *startup script* da VM finalizar, garantindo que as dependências estejam prontas.
- **Deploy**: Conecta-se via SSH, clona o repositório e sobe a stack de serviços com `Docker Compose`.
- **DNS**: Atualiza dinamicamente os registros DNS no Cloudflare para apontar para a nova infraestrutura.

#### 3. **Observabilidade Integrada**
A pilha de monitoramento foi projetada para fornecer visibilidade completa:
- **Métricas de Infraestrutura e Aplicação**: **Prometheus** coleta métricas do `cAdvisor` (performance de contêineres), `nginx-vts-exporter` (throughput, latências no Nginx) e da própria aplicação Flask.
- **Dashboards Interativos**: **Grafana** consome os dados do Prometheus para exibir dashboards em tempo real, permitindo a análise de tendências e a identificação de anomalias.
- **Tracing Distribuído**: **OpenTelemetry** está integrado na aplicação Flask para permitir o rastreamento de requisições através dos serviços.

#### 4. **Segurança Ativa**
O **Fail2Ban** é configurado para monitorar os logs do Nginx em tempo real. Ele bane automaticamente endereços de IP que demonstram comportamento malicioso (ex: scanning de vulnerabilidades, tentativas de injeção), adicionando uma camada de segurança essencial diretamente no *edge* da infraestrutura.

---

## Modelos de Implantação

O repositório suporta dois modelos de implantação, demonstrando flexibilidade para diferentes ambientes.

- **Modelo 1: VM Automatizada (Implantação Principal)**
  - **Descrição**: Uma pipeline de CI/CD provisiona uma VM na OCI e implanta a stack completa de serviços usando Docker Compose.
  - **Ideal para**: Cenários onde a simplicidade de uma única VM é preferível, mas com automação completa.

- **Modelo 2: Orquestração com Kubernetes**
  - **Descrição**: Os manifestos na pasta `/kubernetes` definem os recursos para implantar a aplicação em um cluster Kubernetes (como o OKE).
  - **Ideal para**: Ambientes que exigem alta disponibilidade, auto-scaling e gerenciamento avançado de contêineres.

---

## Estrutura do Repositório

```
/
├── docker-compose/     # Orquestração local dos serviços (app, nginx, monitoramento)
├── iac/                # Infraestrutura como Código (Terraform, Packer)
├── kubernetes/         # Manifestos para deploy em Kubernetes
├── pipelines/          # Definições das pipelines de CI/CD do GitLab
├── usefull-scripts/    # Scripts utilitários para automação e troubleshooting
└── docker-compose/webport/ # Código-fonte da aplicação Flask e Dockerfile
```

---

## Executando o Ambiente Localmente

### Pré-requisitos
- Docker & Docker Compose
- Git

### Passos
1.  **Clone o repositório:**
    ```bash
    git clone https://gitlab.com/yohrannes/website-portifolio.git
    cd website-portifolio
    ```

2.  **Suba os contêineres:**
    ```bash
    docker compose up -d --build
    ```
    Este comando irá construir as imagens e iniciar todos os serviços em background.

3.  **Acesse os serviços:**
    - **Website**: `http://localhost`
    - **Grafana**: `http://localhost:3000`
    - **Métricas do Nginx**: `http://localhost/status`

---

## Contato

- **LinkedIn**: [Yohrannes Santos Bigoli](https://www.linkedin.com/in/yohrannes)
- **GitHub**: [@yohrannes](https://github.com/yohrannes)
- **GitLab**: [@yohrannes](https://gitlab.com/yohrannes)
