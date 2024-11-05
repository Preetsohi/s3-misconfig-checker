#!/bin/bash

# AWS S3 Misconfiguration Checker
# This script tests an S3 bucket for various misconfiguration issues.
# Usage: ./s3_misconfig_checker.sh <s3_bucket_url>

# Function to extract bucket name from the S3 URL
extract_bucket_name() {
    local s3_url=$1
    echo "$s3_url" | awk -F[/:] '{print $4}'
}

# Check for required arguments
if [ -z "$1" ]; then
    echo "Usage: $0 <s3_bucket_url>"
    exit 1
fi

# Extract bucket name from URL
BUCKET_URL=$1
BUCKET_NAME=$(extract_bucket_name "$BUCKET_URL")

# Prompt for optional email for testing ACL write permissions
read -p "Enter email address to test ACL write permissions (or leave blank to skip): " EMAIL

echo "Testing misconfigurations for bucket: $BUCKET_NAME"
echo "=================================================="

# 1. Test for misconfigured list permissions
echo "[*] Testing list permissions..."
aws s3 ls s3://"$BUCKET_NAME" --no-sign-request || echo "List permission check failed."

# 2. Test for misconfigured read permissions
echo "[*] Testing read permissions..."
aws s3api get-object --bucket "$BUCKET_NAME" --key archive.zip ./OUTPUT --no-sign-request || echo "Read permission check failed."

# 3. Test for misconfigured download permissions
echo "[*] Testing download permissions..."
aws s3 cp s3://"$BUCKET_NAME"/intigriti.txt ./ --no-sign-request || echo "Download permission check failed."

# 4. Test for misconfigured write permissions
echo "[*] Testing write permissions..."
aws s3 cp intigriti.txt s3://"$BUCKET_NAME"/intigriti-ac5765a7-1337-4543-ab45-1d3c8b468ad3.txt --no-sign-request || echo "Write permission check failed."

# 5. Test for read permissions on Access Control Lists (ACLs)
echo "[*] Testing read permissions on bucket ACL..."
aws s3api get-bucket-acl --bucket "$BUCKET_NAME" --no-sign-request || echo "Bucket ACL read permission check failed."

echo "[*] Testing read permissions on object ACL..."
aws s3api get-object-acl --bucket "$BUCKET_NAME" --key index.html --no-sign-request || echo "Object ACL read permission check failed."

# 6. Test for write permissions on Access Control Lists (ACLs)
if [ -n "$EMAIL" ]; then
    echo "[*] Testing write permissions on bucket ACL..."
    aws s3api put-bucket-acl --bucket "$BUCKET_NAME" --grant-full-control emailaddress="$EMAIL" --no-sign-request || echo "Bucket ACL write permission check failed."
else
    echo "[*] Skipping ACL write permission check (no email provided)."
fi

# 7. Testing for missing file type restrictions
echo "[*] Testing for missing file type restrictions..."
echo "This requires manual testing for allowed file types or MIME types."

# 8. Testing for S3 versioning
echo "[*] Testing S3 versioning..."
aws s3api get-bucket-versioning --bucket "$BUCKET_NAME" --no-sign-request || echo "Bucket versioning check failed."

echo "=================================================="
echo "Testing completed for bucket: $BUCKET_NAME"
