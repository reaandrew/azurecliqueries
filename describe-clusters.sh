#!/bin/bash

# Subscription name filter
filter=${1:-""}

# Get all subscriptions and filter by the provided name
subscriptions=$(az account list --query "[?contains(name, '$filter')].id" -o tsv)

# Check if any subscriptions matched the filter
if [ -z "$subscriptions" ]; then
    exit 0
fi

# Loop through each filtered subscription
for subscription in $subscriptions; do
    # Set the current subscription
    az account set --subscription $subscription
    
    # Get all AKS clusters in the current subscription in JSON format
    clusters=$(az aks list --output json)

    # Check if there are any clusters and output each as a JSON line
    if [ "$clusters" != "[]" ]; then
        echo "$clusters" | jq -c '.[]'
    fi
done

