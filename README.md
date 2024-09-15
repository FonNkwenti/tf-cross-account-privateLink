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

Clone this repository:

   ```bash
   git clone https://github.com/FonNkwenti/tf-cross-account-privateLink.git
   ```


### Set up the PrivateLink Endpoint Service in the Service Producer's account
1. Navigate to the service-provider directory:
   ```bash
   cd service_producer
   ```
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Review and modify `variables.tf` if required
4. Create a `terraform.tfvars` file in the root directory and pass in values for the variables.
   ```bash
      region               = "eu-west-1"
      account_id           = <<aws_account_id_for_service_producer>>
      cross_account_id     = <<aws_account_id_for_cross_account_service_consumer>>
      environment          = "dev"
      project_name         = "tf-cross-account-privateLink"
      service_name         = "privateLink-service"
      cost_center          = "237"
   ```
5. Apply the Terraform configure:
   ```bash
   terraform apply --auto-approve
   ```
6. Copy the VPC Endpoint Service Link from the outputs 
   ```bash

   ```
7.   


### Set up the VPC Interface Endpoint in the Service Consumer's account
1. Navigate to the cross-account-service-consumer directory:
   ```bash
   cd cross-account-service-consumer
   ```
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Review and modify `variables.tf` if required
4. Create a `terraform.tfvars` file in the root directory and pass in values for the variables. Make sure you update the value of the `privateLink_service_name` copied from the Terraform output of Endpoint service deployment.
   ```bash
      region               = "eu-west-1"
      account_id           = <<aws_account_id_for_service_producer>>
      cross_account_id     = <<aws_account_id_for_cross_account_service_consumer>>
      privateLink_service_name    = "com.amazonaws.vpce.eu-west-1.vpce-svc-0aa398ea0d6f8741a"
      environment          = "dev"
      project_name         = "tf-cross-account-privateLink"
      service_name         = "privateLink-service"
      cost_center          = "237"
   ```
5. Apply the Terraform configure:
   ```bash
   terraform apply --auto-approve
   ```
6. Copy the value of the `session_manager_link` from the Terraform output. Paste it in your broswer to open up an SSM Session Manager session to the EC2 instance in the cross account service consumer's account. 
   ```bash


   ```
7. Copy the value of the `interface_endpoint_dns_name` from the Terraform output. Use `curl` to verify if you can access the service.   
   ```bash


   ```




---

## Clean up

### Remove all resources created by Terraform in the Service Consumer's account
1. Navigate to the cross-account-service-consumer directory:
   ```bash
   cd cross-account-service-consumer
   ```
2. Destroy all Terraform resources:
   ```bash
   terraform destroy --auto-apply
   ```
---
### Remove all resources created by Terraform in the Service Producers's account
1. Navigate to the service-producer directory:
   ```bash
   cd service-producer
   ```
2. Destroy all Terraform resources:
   ```bash
   terraform destroy --auto-apply
   ```
---

<!-- ## Tutorial
[Private Serverless REST API with API Gateway: Lambda, DynamoDB, VPC Endpoints & Terraform - Part 1](https://www.serverlessguru.com/blog/private-serverless-rest-api-with-api-gateway-lambda-dynamodb-vpc-endpoints-terraform---part-1) --> -->

## License

This project is licensed under the MIT License - see the `LICENSE` file for details.
