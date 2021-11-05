# Azure API Management Heartbeat Loss Detection

This is a sample Logic App demonstrating a number of concepts:

- Use of Authenticated calls to Azure REST apis
- Emission of custom metrics to Azure Monitor

## How to use

1. Clone the repository
1. Edit the parameters file to specify appropriate values for your environment
1. Deploy the template using az cli, PowerShell Az module, or Azure Portal
1. In the Azure Portal, assign your Logic App's Managed Identity the "Monitoring Metrics Publisher" and "API Management Service Reader" roles

## Further Reading

For further information on the concepts and APIs used in this sample, see the following

- [Azure Logic Apps Documentation](https://docs.microsoft.com/en-us/azure/logic-apps/)
- [Azure API Management REST Documentation](https://docs.microsoft.com/en-us/rest/api/apimanagement/apimanagementrest/api-management-rest)
- [Send custom metrics for an Azure resource to the Azure Monitor metric store by using a REST API](https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-store-custom-rest-api)
