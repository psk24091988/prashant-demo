credentials        = "${{ secrets.prashant_creds}}"
project_id         = "prashant-terraform"
region             = "us-central1"
zones              = ["<region>-a", "<region>-b", "<region>-c"]
name               = "prashant-gke"
machine_type       = "g1-small"
min_count          = 3
max_count          = 5
disk_size_gb       = 25
service_account    = "prashant-terraform@prashant-terraform.iam.gserviceaccount.com"
initial_node_count = 3
gh_token = "${{ secrets.prashant_creds}"
repo_url = "https://github.com/psk24091988/prashant-demo"
repo_name = "prashant-demo"
repo_owner = "psk24091988"
region     = "us-central1"
