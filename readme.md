# Uptime Kuma in Azure App Service

This template shows how to deploy [Uptime Kuma](https://github.com/louislam/uptime-kuma) as an Docker Container in Azure App Service with Terraform.

It consists of the following Azure resources:

- Resource Group
- Azure Storage Account and File Share to store the Uptime Kuma data
- Azure App Service Plan and Web App

The names of Azure Store Account and Azure Web App must be unique globaly. Set them in the `terraform.tfvar` file.

After applying the Terraform configuration, you can access Uptime Kuma at `https://<your-web-app-name>.azurewebsites.net`. After the first deployment, wait a few minutes until the Uptime Kuma container is downloaded and started.
