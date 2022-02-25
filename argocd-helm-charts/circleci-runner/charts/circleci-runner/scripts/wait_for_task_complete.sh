#!/bin/bash
while true;
do
  job_status=$(curl --request GET --url "https://circleci.com/api/v2/workflow/$CIRCLE_WORKFLOW_ID/job" --header "Circle-Token: $CCI_API_TOKEN" | jq -c '.items[] | select (.name | contains("runner-job")).status')

  echo "Test job status is $job_status"

  if [[ "$job_status" == '"success"' ]]; then
    exit 0
  else
    sleep 10
  fi
done
