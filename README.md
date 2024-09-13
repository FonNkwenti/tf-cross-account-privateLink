# Using Terraform to build Cross-Account Service Integrations with AWS PrivateLink
This project demonstrates how to use Terraform to Cross-Account Service Integrations with AWS PrivateLink

## Prerequisites
Before you begin, ensure you have the following:

- 2 AWS accounts
- Terraform installed locally
- AWS CLI installed and configured with appropriate access credentials profiles for the 2 AWS accounts

<!-- ## Architecture
![Diagram](private-rest-api-part2-white.webp) -->

---

## Project Structure
```bash
|- service_producer/
|- same_account_service_consumer/
|- cross_account_service_consumer/
```
---
## Getting Started

1. Clone this repository:

   ```bash
   git clone https://github.com/FonNkwenti/tf-cross-account-privateLink.git
   ```


1. Navigate to the service_provider directory:
   ```bash
   cd service_producer
   ```
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Review and modify `variables.tf` if required
4. Create a `terraform.tfvars` file in the root directory and pass in values for `region`, `account_id`, `tag_environment` and `tag_project`
   ```bash
    region               = "eu-west-1"
    account_id           = <<AWS ACCOUNT ID FOR SERVICE PROVIDER>>
    tag_environment      = "dev"
    tag_project          = "tf-cross-account-privateLink"
   ```
5. Apply the Terraform configure:
   ```bash
   terraform apply
   ```
6. Copy the VPC Endpoint Service Link from the outputs and export as a variable
   ```bash

   ```
8. 



---

<!-- ## Clean up
Remove all resources created by Terraform.
   ```
   terraform destroy
   ```

---

<!-- ## Tutorials
[Private Serverless REST API with API Gateway: Lambda, DynamoDB, VPC Endpoints & Terraform - Part 1](https://www.serverlessguru.com/blog/private-serverless-rest-api-with-api-gateway-lambda-dynamodb-vpc-endpoints-terraform---part-1) --> -->

## License

This project is licensed under the MIT License - see the `LICENSE` file for details.
