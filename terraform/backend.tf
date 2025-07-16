terraform {
    backend "s3" {
        bucket = "terraform-state-flywheel-assessment-dev"
        key = "envs/dev/terraform.tfstate"
        region = "ca-central-1"
        dynamodb_table = "terraform-locks-flywheel-assessment-dev"
        encrypt = true
    }
}