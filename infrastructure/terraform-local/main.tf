terraform {
  required_version = ">= 1.6.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

variable "student_name" {
  description = "Name to write into the local practice file"
  type        = string
  default     = "DevOps learner"
}

resource "local_file" "practice_note" {
  filename = "${path.module}/generated/devops-practice.txt"

  content = <<EOT
Hello, ${var.student_name}!

This file was created by Terraform.
Terraform is tracking it in state.
EOT
}

output "practice_file_path" {
  description = "Path of the file Terraform created"
  value       = local_file.practice_note.filename
}
