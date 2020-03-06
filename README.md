# corona
How to using corona project to index data from S3 to Elasticsearch.

Step 1. Create new EC2
Step 2. Install OpenCOBOL, git, cron
Step 3. Get source from git
   cd /home/ec2-user/
   git clone https://github.com/pkm0306pkm/corona.git
Step 4. Create new Elasticsearch service
Step 5. Create new bucket in S3
Step 6. Edit environment variable in batch.sh file: 
   s3 bucket, 
   ec2 path, 
   Elasticsearch domain
Step 7. Setting cron: perform a "batch" schedule every 5 minutes
   */5 * * * * /home/ec2-user/corona/cronjob/batch.sh >> /home/ec2-user/corona/cronjob/batch.log 2>&1
   https://crontab-generator.org/
Step 8. Upload s3_datarow.csv to s3, cron will execute schedule after 5 minutes
Step 9. Confrim log result at batch.log file.
