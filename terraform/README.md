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
-v $PWD:/app \
-v ~/.ssh:/root/.ssh \
-w /app \
--entrypoint "" hashicorp/terraform:light sh
```
