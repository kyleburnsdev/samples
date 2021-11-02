#
# THIS SAMPLE IS FOR DEMONSTRATION PURPOSES ONLY AND NOT INTENDED TO 
# BE A COMPLETE PRODUCTION SOLUTION. IT IS INTENDED TO BE A "RECIPE STARTER"
# USED TO ENSURE THERE IS VISIBILITY IF AN AZURE API MANAGEMENT SELF HOSTED
# GATEWAY HAS PERSISTENTLY LOST ITS ABILITY TO SYNC WITH ITS APIM SERVICE
#

#
# THIS SAMPLE ASSUMES AN AUTHENTICATED SESSION HAS BEEN
# ESTABLISHED FOR USE OF THE az CLI COMMAND. IT DEPENDS
# ON THE FOLLOWING PACKAGES:
# - azure-cli (https://docs.microsoft.com/en-us/cli/azure/)
# - jq (https://stedolan.github.io/jq/)
#
RESOURCE_GROUP=**YOUR_RESOURCE_GROUP_NAME**
APIM_NAME=**YOUR_APIM_INSTANCE_NAME**
MIN_HEARTBEAT=$(date +"%Y-%m-%dT%H:%m:00Z" -d "-30 minutes") #adjust to your tolerance
RESULT=$(az rest --method GET --uri /subscriptions/{subscriptionId}/resourceGroups/${RESOURCE_GROUP}/providers/Microsoft.ApiManagement/service/${APIM_NAME}/gateways?api-version=2021-01-01-preview --query "value[?properties.heartbeat[-1].timestamp > '${MIN_HEARTBEAT}'].{name: name, lastHeartbeat: properties.heartbeat[-1].timestamp}")
MISSED_COUNT=$(echo $RESULT | jq length)

if [ $(($MISSED_COUNT)) > 0 ]
then
    echo "$MISSED_COUNT is greater than 0"
    # THIS IS WHERE YOU WOULD DO SOMETHING USEFUL WITH THE RESULT SUCH AS RAISING ALERTS OR CREATING TROUBLE TICKETS
    # NOT DEMONSTRATED IN THIS SCRIPT BECAUSE IT WILL VARY GREATLY BY ENVIRONMENT
else
    echo "no heartbeats missed"
fi
