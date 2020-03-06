# corona
How to using corona project to index data from S3 to Elasticsearch.

Step 1. Create new EC2 <br/>
Step 2. Install OpenCOBOL, git, cron <br/>
Step 3. Get source from git <br/>
   cd /home/ec2-user/<br/>
   git clone https://github.com/pkm0306pkm/corona.git <br/>
Step 4. Create new Elasticsearch service<br/>
Step 5. Create new bucket in S3<br/>
Step 6. Edit environment variable in batch.sh file: <br/>
   s3 bucket, <br/>
   ec2 path, <br/>
   Elasticsearch domain<br/>
Step 7. Setting cron: perform a "batch" schedule every 5 minutes<br/>
   */5 * * * * /home/ec2-user/corona/cronjob/batch.sh >> /home/ec2-user/corona/cronjob/batch.log 2>&1<br/>
   https://crontab-generator.org/<br/>
Step 8. Upload s3_datarow.csv to s3, cron will execute schedule after 5 minutes<br/>
Step 9. Confrim log result at batch.log file.<br/>
