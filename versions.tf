# Configure the minimum required providers supported

terraform {

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~>0.51"
    }
  }

  required_version = "> 1.6.0"

}