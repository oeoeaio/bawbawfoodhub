#!/bin/bash

# Usage: script/backup.sh [bbfh-prod]

set -e

mkdir -p db/backup
ssh $1 "pg_dump -h localhost -U bbfh bbfh_prod |gzip" > db/backup/$1-`date +%Y%m%d`.sql.gz