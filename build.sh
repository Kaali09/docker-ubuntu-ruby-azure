#!/bin/sh
cd /project/builds
bundle exec jekyll build
echo "Build Successful..!!"
az storage blob delete-batch --source $AZURE_STORAGE_CONTAINER --account-name $AZURE_STORAGE_ACCOUNT --account-key $AZURE_STORAGE_KEY
echo "Container Emptied..!!"
az storage blob upload-batch --destination $AZURE_STORAGE_CONTAINER --source _site/ --account-name $AZURE_STORAGE_ACCOUNT --account-key $AZURE_STORAGE_KEY
echo "Site Uploaded..!!"
rm -rf _site/
