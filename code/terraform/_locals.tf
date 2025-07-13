locals {
  region                        = "eu-west-1"
  terraform_storage_bucket_name = "tf-anaoum-lab-terraform-storage"
  server_amount                 = "2"
  vpc_id                        = "vpc-0081185452584c726"
  ansible_ssh_public_key        = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGIcacE+5Ytg06wR9VvsLEneJEGixcu8g7kaQj76vQ7i ansible-deploy"
}