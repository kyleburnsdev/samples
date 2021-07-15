#
# THIS SAMPLE ASSUMES AN AUTHENTICATED SESSION HAS BEEN
# ESTABLISHED FOR USE OF THE az CLI COMMAND. IT DEPENDS
# ON THE FOLLOWING PACKAGES:
# - kubectl (https://kubernetes.io/docs/reference/kubectl/)
# - azure-cli (https://docs.microsoft.com/en-us/cli/azure/)
# - jq (https://stedolan.github.io/jq/)
#
RESOURCE_GROUP=**YOUR_RESOURCE_GROUP_NAME**
APIM_NAME=**YOUR_APIM_INSTANCE_NAME**
GATEWAY_NAME=**NAME_OF_GATEWAY_IN_PORTAL**

#
# THE FOLLOWING TWO LINES WOULD BE OMITTED IF NOT USING
# AKS OR THE kubectl CONTEXT IS ALREADY ESTABLISHED
#
AKS_NAME=**YOUR_AKS_INSTANCE_NAME**
az aks get-credentials --name ${AKS_NAME} --resource-group ${RESOURCE_GROUP}

# obtain subscription id to build uri for the REST call
ID=$(az account show -o tsv --query id)

uri="https://management.azure.com/subscriptions/${ID}/resourceGroups/${RESOURCE_GROUP}/providers/Microsoft.ApiManagement/service/${APIM_NAME}/gateways/${GATEWAY_NAME}/generateToken?api-version=2019-12-01"
echo "uri for token generation is ${uri}"

# query K8s to determine most recently used key
CURRENT_KEY_TYPE=$(kubectl get configmap ${GATEWAY_NAME}-token-type -o "jsonpath={.data.value}")
KEY_TYPE="secondary"

if [ "${CURRENT_KEY_TYPE}" == "${KEY_TYPE}" ]
then
  KEY_TYPE="primary"
fi

echo "Current key type is: ${CURRENT_KEY_TYPE}"
echo "New key type is: ${KEY_TYPE}"

# maximum configurable expiry is 30 days
NEW_EXP=$(date +"%Y-%m-%dT%H:%m:00Z" -d "+30 days")
# generate the key using ARM REST api
TOKEN=$(az rest --method POST --uri "${uri}" --body "{ \"expiry\": \"${NEW_EXP}\", \"keyType\": \"${KEY_TYPE}\" }" | jq .value | tr -d "\"" )

if [ "${TOKEN}" == "" ]
then
  echo "ERROR RETRIEVING TOKEN. ABORTING"
  exit 1
fi

# update the secret
kubectl create secret generic ${GATEWAY_NAME}-token --from-literal=value="GatewayKey ${TOKEN}" --dry-run=client -o yaml \
    | kubectl apply -f -
# update the key type to rotate on next run
kubectl create configmap ${GATEWAY_NAME}-token-type --from-literal=value=${KEY_TYPE} --dry-run=client -o yaml \
    | kubectl apply -f -

# ensure gateway picks up new secret
kubectl rollout restart deployment ${GATEWAY_NAME}
