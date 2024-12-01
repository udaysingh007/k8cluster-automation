provider "aws" {
  region                      = "us-east-1"
  access_key                  = "11a42c59-2655-442b-80db-722c8e7699af"
  secret_key                  = "11a42c59-2655-442b-80db-722c8e7699af"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  # Use the 'endpoints' block for Localstack
  endpoints {
    s3       = "http://localhost:4566"
    dynamodb = "http://localhost:4566"
    ec2      = "http://localhost:4566"
    sts      = "http://localhost:4566" # Redirect STS calls to Localstack
    # Add other services as needed
  }
}

resource "aws_instance" "control_plane" {
  count         = 3
  ami           = "ami-0c2b8ca1dad447f8a" # Amazon Linux 2 (replace with your AMI)
  instance_type = "t2.medium"
  tags = {
    Name = "k8s-control-plane-${count.index}"
  }
}

resource "aws_instance" "worker" {
  count         = 5
  ami           = "ami-0c2b8ca1dad447f8a" # Amazon Linux 2 (replace with your AMI)
  instance_type = "t2.medium"
  tags = {
    Name = "k8s-worker-${count.index}"
  }
}

output "control_plane_ips" {
  value = aws_instance.control_plane[*].private_ip
}

output "worker_ips" {
  value = aws_instance.worker[*].private_ip
}

