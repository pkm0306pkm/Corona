#!/bin/bash

export PATH="/usr/local/bin:/usr/bin:/bin"
export S3_DATA_PATH="s3://fpt-corona-data"
export EC2DATA_PATH="/home/ec2-user/corona/data"
export FDDOMAIN="https://search-corona-5sbkgdsencyyorxubck7wdg6s4.ap-northeast-1.es.amazonaws.com"
export COB_LIBRARY_PATH="/home/ec2-user/corona/cobol"

# 10 Start job
echo "start run corona job: "$(date)

# 20 Copy data file from S3
aws s3 cp $S3_DATA_PATH/s3_datarow.csv $EC2DATA_PATH/ec2_datarow.csv

# 25 Check file is existed
if (! (test -f $EC2DATA_PATH/ec2_datarow.csv)) then
   exit 4 
fi

# 30 Convert CSV to ES-JSON
export DD_FDZZ9C0=$EC2DATA_PATH/ec2_datarow.csv
export DD_FDZZ9C4=$EC2DATA_PATH/ec2_dataconv.json
cobcrun CZZ1230 corona-index

# 40 Elasticsearch index
curl -X POST -H "Content-Type: application/x-ndjson" \
     $FDDOMAIN/_bulk?pretty \
     --data-binary @$EC2DATA_PATH/ec2_dataconv.json

# 50 Remove temp file
aws s3 rm $S3_DATA_PATH/s3_datarow.csv
rm $EC2DATA_PATH/ec2_datarow.csv
rm $EC2DATA_PATH/ec2_dataconv.json

# End job
echo "end corona job. "$(date)
