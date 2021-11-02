#
# THIS SAMPLE IS FOR DEMONSTRATION PURPOSES ONLY AND NOT INTENDED TO 
# BE A COMPLETE PRODUCTION SOLUTION. IT IS INTENDED TO BE DEMONSTRATE
# HOW TO INVOKE THE REST API TO INITIATE AN APIM BACKUP TO STORAGE
# ACCOUNT USING MANAGED IDENTITY FOR ACCESS CONTROL AND STORAGE FIREWALL
# TO PREVENT PUBLIC INTERNET ACCESS TO THE STORAGE ACCOUNT
#

#
# THIS SAMPLE ASSUMES AN AUTHENTICATED SESSION HAS BEEN
# ESTABLISHED FOR USE OF THE az CLI COMMAND. IT DEPENDS
# ON THE FOLLOWING PACKAGES:
# - azure-cli (https://docs.microsoft.com/en-us/cli/azure/)
#

RESOURCE_GROUP=**YOUR_RESOURCE_GROUP_NAME**
APIM_NAME=**YOUR_APIM_INSTANCE_NAME*
STORAGE_ACCOUNT_NAME=**YOUR_STORAGE_ACCOUNT_NAME**
CONTAINER_NAME=**YOUR_BACKUP_CONTAINER_NAME**
BACKUP_NAME="${APIM_NAME}-$(date +"%Y%m%d%H%m")"

az rest --method POST \
        --uri https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/${RESOURCE_GROUP}/providers/Microsoft.ApiManagement/service/${APIM_NAME}/backup?api-version=2021-04-01-preview \
        --headers Content-Type="application/json" \
        --body "{
            \"storageAccount\": \"$STORAGE_ACCOUNT_NAME\",
            \"containerName\": \"$CONTAINER_NAME\",
            \"backUpName\": \"$BACKUP_NAME\",
            \"accessType\": \"SystemAssignedManagedIdentity\",
        }" \
        --verbose
