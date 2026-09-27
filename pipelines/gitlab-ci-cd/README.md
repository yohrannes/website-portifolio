## Autentication needed
 - google cloud + locally cli - instance creation
 - oracle cloud + locally cli - instance + cluster creation
 - terraform cloud + locally cli - provision token + workspace config
 - gitlab + locally cli + tokens for manage variables and create gitlab runners
 - hashicorp (packer) + locally binary - authenticate with oci, google and hashicorp
 - cloudfare (if needed) - token to to update your domain DNS

## Infrastructure and Deployment provison - full cycle.

- 1st step - runner1.yml - create google cloud instance and configure as a gitlab-runner.
- 2nd step - infra-webapp-failover.yml - create oracle cloud instance to be used as a failover if cluster goes down.
- 3rd step - runner2.yml - configure instance also as a gitlab-runner.
- 4th step - infra-webapp.yml - create oracle cloud cluster to host portifolio website.
- 5th step - runner3.yml - configure cluster also as a gitlab-runner.
- 6th step - dev.yml - develop website and deploy docker images to your registry.
- 7th step - prod.yml - deploy website to instance (docker compose) and cluster (kubernetes).


```
pipelines
└── gitlab-ci-cd
    ├── cloud-auth
    │   └── oci-oke-auth.yml
    ├── dev.yml
    ├── docker-images
    │   └── docker-registry.yml
    ├── infra-gitlab-runners
    │   ├── runner1.yml
    │   ├── runner2.yml
    │   ├── runner3.yml
    │   └── runner-controler.yml
    ├── infra-webapp
    │   ├── infra-webapp-failover.yml
    │   └── infra-webapp.yml
    ├── packer
    │   └── build-instance-image.yml
    ├── prod.yml
    ├── README.md
    ├── terraform
    │   ├── apply.yml
    │   ├── get-output.yml
    │   ├── note.txt
    │   └── trigger-run.yml
    └── tests
        └── infra-webapp
            └── infra-webapp.yml
```