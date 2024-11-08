## Website terraform insfrastructure

```
repo/
├── terraform/
│   ├── modules/
│   │   ├── compute_instance/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   └── oke_cluster/
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
│   │
│   ├── provider.tf
│   └── README.md
│
├── startup-files/
│   └── startup-script.sh
│
├── .gitignore
└── README.md
```