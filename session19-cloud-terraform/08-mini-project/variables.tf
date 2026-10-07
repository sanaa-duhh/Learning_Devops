variable "aws_region" {
  description = "AWS region for the Session 19 mini project."
  type        = string
  default     = "ap-south-1"
}

variable "bucket_suffix" {
  description = "Unique suffix to make the S3 bucket name globally unique."
  type        = string
  default     = "sanaa-24bcs10304"
}
