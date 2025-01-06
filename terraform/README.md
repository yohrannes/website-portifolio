## Website terraform insfrastructure

```
repo/
├── terraform/
│   ├── modules/
│   │   ├── compute_instance/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   │   │   └── scripts/
│   │   │       └── startup-script.sh    # Coloque o script aqui
│   │   └── oke_cluster/
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
│   │
│   ├── provider.tf
│   └── README.md
│
├── .gitignore
└── README.md
```

```
docker run -it \
-v ~/.oci:/root/.oci \
-v ~/.aws:/root/.aws \
-v ~/.ssh:/root/.ssh \
-v ~/.gcp:/root/.gcp \
-v $PWD:/app \
-w /app \
-e GOOGLE_APPLICATION_CREDENTIALS="/root/.gcp/credentials.json" \
--entrypoint "" hashicorp/terraform:latest sh -c "terraform init && sh"
```
