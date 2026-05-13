#!/bin/bash
# Sync local dir to S3 with versioning
aws s3 sync ./data s3://$1/backup/$(date +%Y/%m/%d)/ --storage-class STANDARD_IA
