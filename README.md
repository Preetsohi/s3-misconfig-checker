# s3-misconfig-checker
This script accepts an S3 bucket URL as a parameter, extracts the bucket name, customizes and executes each command, and displays the output.

# S3 Misconfiguration Checker

This tool tests AWS S3 buckets for common misconfigurations, helping identify potential security issues.

## Installation and Usage

1. Clone this repository:
   ```bash
   git clone https://github.com/<username>/s3-misconfig-checker.git
   cd s3-misconfig-checker
2. Make the script executable:
   chmod +x s3_misconfig_checker.sh
3. Run the script with your S3 bucket URL:
   ./s3_misconfig_checker.sh https://bucket-name.s3.region.amazonaws.com

**Tests Performed**
List Permissions
Read Permissions
Download Permissions
Write Permissions
Read ACL Permissions (Bucket and Object)
Write ACL Permissions
Missing File Type Restrictions (Manual Step Required)
Versioning Settings

**Requirements**
AWS CLI installed on Kali Linux (sudo apt install awscli).
Sufficient permissions for testing each setting on the target S3 bucket.
