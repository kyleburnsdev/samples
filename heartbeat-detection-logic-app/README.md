# Azure API Management Heartbeat Loss Detection

This is a sample Logic App demonstrating a number of concepts:

- Use of Authenticated calls to Azure REST apis
- Emission of custom metrics to Azure Monitor

## How to use

1. Clone the repository
1. Edit the parameters file to specify appropriate values for your environment
1. Deploy the template using az cli, PowerShell Az module, or Azure Portal
1. In the Azure Portal, assign your Logic App's Managed Identity the "Monitoring Metrics Publisher" and "API Management Service Reader" roles
