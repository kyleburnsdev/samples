# Azure API Management Heartbeat Loss Detection

This is a sample Logic App demonstrating a number of concepts:

- Use of Authenticated calls to Azure REST apis
- Emission of custom metrics to Azure Monitor

> NOTE: THIS SAMPLE USES HEARTBEAT INFORMATION THAT IS INCLUDED IN THE [GET Gateways](https://docs.microsoft.com/en-us/rest/api/apimanagement/2021-04-01-preview/gateway/get)
> REST API RESPONSE, BUT NOT INCLUDED IN THE API DOCUMENTATION AT THE TIME OF THIS WRITING.

## How to use

1. Clone the repository
1. Edit the parameters file to specify appropriate values for your environment
1. Deploy the template using az cli, PowerShell Az module, or Azure Portal
1. In the Azure Portal, assign your Logic App's Managed Identity the "Monitoring Metrics Publisher" and "API Management Service Reader" roles

### Parameters

Parameter name | Required? | Default | Description
-------------- | --------- | ------- | -----------
`logicAppName` | Yes | | The name of the logic app to be deployed. Must adhere to the [naming restrictions for Microsoft.Logic/workflows](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules#microsoftlogic)
`logAppLocation` | No | `resourceGroup().location` | The Azure region where the logic app is to be deployed
`RecurrenceInterval` | No | 15 | Specifies the time in minutes to be used for timing executions of the logic app. After deployment, can be updated on the deployment trigger
`paramSUBSCRIPTION_ID` [^1] | Yes | | The subscription containing the APIM instance to be monitored
`paramRESOURCE_GROUP` [^1] | Yes | | The resource group containing the APIM instance to be monitored
`paramAPIM_NAME` [^1] | Yes | | The name of the APIM instance to be monitored
`paramHEARTBEAT_THRESHOLD_MINUTES` [^1] | No | 15 | The maximum time interval (in minutes) considered within tolerance to have not received a heartbeat

[^1]: All parameters prefixed with `param` can be modified post-deployment by updating the associated parameter within the logic app workflow

## How it works

### Program flow

The deployed logic app uses the Azure Management REST api to retrieve information about the APIM service instance and its associated [self-hosted gateway](https://docs.microsoft.com/en-us/azure/api-management/self-hosted-gateway-overview) instances.

For each self-hosted gateway instance returned by the API call, the logic app checks the heartbeats collection to determine whether its most recent heartbeat is within the range of tolerance specific by the workflow's `HEARTBEAT_THRESHOLD_MINUTES` parameter. After checking, the Azure Monitor Custom Metrics REST api is used to emit a metric indicating success or failure.

### Emitted metric information

The emitted metric is attached to the APIM instance, but put into a custom namespace to avoid conflicting with potential future metrics to be emitted by the product itself

Metric name | HeartbeatDetection
Metric namespace | custom
Dimension 1 name | GatewayName
Dimension 2 name | Result
Dimension 2 possible values | Success, Failure

### What next

By design, this logic app doesn't take any action beyond detecting missed heartbeat and producing metrics that can be consumed within Azure Monitor. The metrics can be viewed by going to your APIM instance in the Azure portal and selecting the Metrics blade. You will need to filter for a namespace of "custom" in the Metrics blade to see the data charted. This data can be used to create an Alert rule and associated actions. See [Overview of alerts in Azure Monitor](https://docs.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview) for more details and Alerts, Action Groups, and how to create them.

## Further Reading

For further information on the concepts and APIs used in this sample, see the following

- [Azure Logic Apps Documentation](https://docs.microsoft.com/en-us/azure/logic-apps/)
- [Authenticating Outbound HTTP Requests in Logic Apps](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-securing-a-logic-app?tabs=azure-portal#add-authentication-outbound)
- [Azure API Management REST Documentation](https://docs.microsoft.com/en-us/rest/api/apimanagement/apimanagementrest/api-management-rest)
- [Send custom metrics for an Azure resource to the Azure Monitor metric store by using a REST API](https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-store-custom-rest-api)
- [Overview of alerts in Azure Monitor](https://docs.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview)
