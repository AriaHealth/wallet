source "amazon-ebs" "main" {
  ami_name = "rolling_update_{{timestamp}}"
  region   = "eu-west-1"

  instance_type = "t3.small"

  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "amzn2-ami-hvm-2.0.*-x86_64-gp2"
      root-device-type    = "ebs"
    }
    owners      = ["amazon"]
    most_recent = true
  }

  communicator = "ssh"
  ssh_username = "ec2-user"

  vpc_filter {
    filters = {
      isDefault = true
    }
  }

  subnet_filter {
    random = false
  }
}

build {
  name = "rolling_update_{{timestamp}}"

  sources = [
    "source.amazon-ebs.main"
  ]

  provisioner "shell" {
    script = "infrastructure/packer/scripts/basic-website.sh"
    environment_vars = [
      "COLOR=${var.color}",
      "AWS_SECRET_ACCESS_KEY=${var.aws_secret_access_key}",
      "AWS_ACCESS_KEY_ID=${var.aws_access_key_id}",
      "AWS_BUCKET=${var.aws_bucket}",
      "GITHUB_SHA=${var.github_sha}",
    ]
    execute_command = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
  }
}

variable "color" {
  default = "red"
}

variable "aws_secret_access_key" {
  default = ""
}

variable "aws_access_key_id" {
  default = ""
}

variable "aws_bucket" {
  default = ""
}

variable "github_sha" {
  default = ""
}