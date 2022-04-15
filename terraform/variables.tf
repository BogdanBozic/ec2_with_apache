variable "account_id" {
  type        = number
  description = "AWS Account ID where the services will be deployed."
}

variable "subscriber_email" {
  type        = string
  description = "Email to send the SNS notifications to and check if my setup is working."
}