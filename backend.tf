terraform {
  backend "s3" {
    bucket = "a.khalilau-terraform"
    key    = "statefiles/k8s.tfstate"
    region = "eu-central-1"
  }
}
