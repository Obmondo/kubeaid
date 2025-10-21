#!/bin/bash

# Runs in interactive mode by default (asks for input)
RESTORE_MODE=${RESTORE_MODE:="interactive"}

function read_input {
    read -p "Storage provider (s3/azure): " STORAGE_PROVIDER
    if [[ "$STORAGE_PROVIDER" == "s3" ]]; then
        read_aws_credentials
    else
        read_azure_credentials
    fi

    read_database_credentials
}

function read_aws_credentials {
    read -p "AWS Access Key ID: " AWS_ACCESS_KEY_ID
    read -s -p "AWS Secret Access Key: " AWS_SECRET_ACCESS_KEY
    echo
    read -p "S3 Bucket Name: "  LOGICAL_BACKUP_S3_BUCKET
    read -p "Backup file path: " BACKUP_FILE_PATH
    read -p "S3 endpoint: " LOGICAL_BACKUP_S3_ENDPOINT 
}

function read_azure_credentials {
    read -p "Azure Account Name: " AZURE_STORAGE_ACCOUNT_NAME
    read -s -p "Azure Storage Account Key: " AZURE_STORAGE_ACCOUNT_KEY
    echo
    read -p "Azure Storage Container Name: " AZURE_STORAGE_CONTAINER_NAME
    read -p "Azure Storage Backup Path: " AZURE_STORAGE_BACKUP_PATH
}

function read_database_credentials {
    read -p "Database name: " DB_NAME
    read -p "Database user: " DB_USER
    read -s -p "Database password: " DB_PASS
    echo
    read -p "Database host: " DB_HOST
    read -p "Database port: " DB_PORT
}

function validate_arguments {
    if [[ "$STORAGE_PROVIDER" == "s3" ]]; then
        validate_aws_args
    else
        validate_azure_args
    fi

    validate_db_args
}

function validate_aws_args {
    echo "Validating aws args"
    if [[ -z "$AWS_ACCESS_KEY_ID" ]]; then
        echo "AWS access key ID cannot be empty"
        exit 1
    fi

    if [[ -z "$AWS_SECRET_ACCESS_KEY" ]]; then
        echo "AWS secret access Key cannot be empty"
        exit 1
    fi

    if [[ -z "$LOGICAL_BACKUP_S3_BUCKET" ]]; then
        echo "S3 bucket name cannot be empty"
        exit 1
    fi

    if [[ -z "$BACKUP_FILE_PATH" ]]; then
        echo "Backup file path cannot be empty"
        exit 1
    fi

    if [[ -z "$LOGICAL_BACKUP_S3_ENDPOINT" ]]; then
        echo "S3 endpoint cannot be empty"
        exit 1
    fi
}

function validate_azure_args {
    echo "Validating azure storage args"
    if [[ -z "$AZURE_STORAGE_ACCOUNT_KEY" ]]; then
        echo "Azure storage account key cannot be empty"
        exit 1
    fi

    if [[ -z "$AZURE_STORAGE_CONTAINER_NAME" ]]; then
        echo "Azure storage container Name cannot be empty"
        exit 1
    fi

    if [[ -z "$AZURE_STORAGE_ACCOUNT_NAME" ]]; then
        echo "Azure account name cannot be empty"
        exit 1
    fi

    if [[ -z "$AZURE_STORAGE_BACKUP_PATH" ]]; then
        echo "Backup file path cannot be empty"
        exit 1
    fi
}

function validate_db_args {
    echo "Validating database args"
    if [[ -z "$DB_NAME" ]]; then
        echo "Database name cannot be empty."
        exit 1
    fi

    if [[ -z "$DB_PASS" ]]; then
        echo "Database password cannot be empty."
        exit 1
    fi

    if [[ -z "$DB_HOST" ]]; then
        echo "Database host cannot be empty."
        exit 1
    fi

    if ! [[ "$DB_PORT" =~ ^[0-9]+$ ]]; then
        echo "Database port must be a number."
        exit 1
    fi
}

if [[ "${RESTORE_MODE}" == "interactive" ]]; then
    echo "Running in interactive mode..."
    read_input
else
    echo "Running in non-interactive mode..."
fi

validate_arguments

if [[ "$STORAGE_PROVIDER" == "s3" ]]; then
    PATH_TO_BACKUP="${LOGICAL_BACKUP_S3_BUCKET}/${BACKUP_FILE_PATH}"
    
    echo "Restoring ${BACKUP_FILE_PATH} from S3..."
    
    # Download the backup file from S3
    AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY aws s3 cp "s3://${PATH_TO_BACKUP}" /tmp/mongodb-backup.gz --endpoint-url $LOGICAL_BACKUP_S3_ENDPOINT

elif [[ "$STORAGE_PROVIDER" == "azure" ]]; then

    echo "Restoring ${AZURE_STORAGE_BACKUP_PATH} from Azure blob storage..."

    # Download the backup file from Azure blob storage
    az storage blob download --account-name $AZURE_STORAGE_ACCOUNT_NAME --account-key $AZURE_STORAGE_ACCOUNT_KEY --container-name $AZURE_STORAGE_CONTAINER_NAME --name $AZURE_STORAGE_BACKUP_PATH --file /tmp/mongodb-backup.gz
fi

mkdir -p /tmp/mongodb-restore
tar -xzvf /tmp/mongodb-backup.gz -C /tmp/mongodb-restore
mongorestore --host=$DB_HOST --username=$DB_USER --password=$DB_PASS --port=$DB_PORT /tmp/mongodb-restore/backup/dump
