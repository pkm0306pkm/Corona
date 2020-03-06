
## How to using corona project to index data from S3 to Elasticsearch.

### Step 1. Create new AWS EC2 <br/>
### Step 2. Install OpenCOBOL, git, cron on EC2<br/>
### Step 3. Get source from git <br/>
```
cd /home/ec2-user/<br/>
git clone https://github.com/pkm0306pkm/corona.git <br/>
```
### Step 4. Create new AWS Elasticsearch service
### Step 5. Create new bucket in AWS S3
### Step 6. Edit environment variable in batch.sh file
```
export S3_DATA_PATH="s3://fpt-corona-data"
export EC2DATA_PATH="/home/ec2-user/corona/data"
export FDDOMAIN="https://search-corona-5sbkgdsencyyorxubck7wdg6s4.ap-northeast-1.es.amazonaws.com"
export COB_LIBRARY_PATH="/home/ec2-user/corona/cobol"
```
### Step 7. Setting cron: 
Perform a "batch" schedule every 5 minutes
```
   */5 * * * * /home/ec2-user/corona/cronjob/batch.sh >> /home/ec2-user/corona/cronjob/batch.log 2>&1
   https://crontab-generator.org/<br/>
```
### Step 8. Upload s3_datarow.csv to S3 
Cron will execute schedule after 5 minutes<br/>
### Step 9. Confrim log result at batch.log file.<br/>
Copy file s3_datarow.csv to EC2 (aws cli)<br/>
Convert to Elasticsearch json format (cobol)<br/>
Index json data to Elasticsearch service (rest api)<br/>
