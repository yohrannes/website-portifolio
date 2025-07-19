#terraform {
#  backend "s3" {
#    bucket  = "port-bucket-tfstate"
#    key     = "port.tfstate"
#    region  = "us-east-1"
#    encrypt = true
#    # --- ENABLE TF STATE LOCK -- 
#    use_lockfile = true
#    #dynamodb_table = "tf-state-lock"
#    # --- OBS: firstly provide the aws_dynamodb_table, and then uncomment --- 
#    # --- See modules/dynamodb_lock_state folder ---
#  }
#}
