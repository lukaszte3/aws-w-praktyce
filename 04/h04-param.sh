#!/bin/bash

PROJECT="website"
STAGE="dev"
REGION="eu-central-1"


echo ' '
echo ' Deploying log stack'
echo ' '

COMPONENT="parametrized"
STACK="homework-param-log-bucket"
TEMPLATE="homework-param-log-bucket"
PARAMETERS="homework-param-log-bucket"


TEMPLATE_FILE="$PROJECT/$COMPONENT/templates/$TEMPLATE.yaml"
PARAM_FILE="$PROJECT/$COMPONENT/parameters/$PARAMETERS-$STAGE.json"


echo "TEMPLATE_FILE=$TEMPLATE_FILE"
echo "PARAM_FILE=$PARAM_FILE"


PARAMS=$(cat $PARAM_FILE | jq -jr 'map("\(.ParameterKey)=\(.ParameterValue)") | join (" ")')
echo "PARAMS=$PARAMS"
echo ' '

deploy="aws cloudformation deploy \
    --template-file $TEMPLATE_FILE \
    --stack-name $PROJECT-$COMPONENT-$STACK-$STAGE \
    --capabilities CAPABILITY_NAMED_IAM \
    --no-fail-on-empty-changeset \
    --parameter-overrides $PARAMS \
    --region $REGION \
    --tags Project=$PROJECT Stage=$STAGE Component=$COMPONENT"

echo $deploy

$deploy


echo ' '
echo ' '
echo ' Deploying website stack'
echo ' '


COMPONENT="parametrized"
STACK="homework-param-website"
TEMPLATE="homework-param-website"
PARAMETERS="homework-param-website"


TEMPLATE_FILE="$PROJECT/$COMPONENT/templates/$TEMPLATE.yaml"
PARAM_FILE="$PROJECT/$COMPONENT/parameters/$PARAMETERS-$STAGE.json"
echo "TEMPLATE_FILE=$TEMPLATE_FILE"
echo "PARAM_FILE=$PARAM_FILE"

PARAMS=$(cat $PARAM_FILE | jq -jr 'map("\(.ParameterKey)=\(.ParameterValue)") | join (" ")')
echo "PARAMS=$PARAMS"
echo ' '


deploy2="aws cloudformation deploy \
    --template-file $TEMPLATE_FILE \
    --stack-name $PROJECT-$COMPONENT-$STACK-$STAGE \
    --capabilities CAPABILITY_NAMED_IAM \
    --no-fail-on-empty-changeset \
    --parameter-overrides $PARAMS \
    --region $REGION \
    --tags Project=$PROJECT Stage=$STAGE Component=$COMPONENT"

echo $deploy2



$deploy2


echo " "