#!/bin/bash

# Usage: script/mirror_db.sh

set -Eeuo pipefail

DB_HOST='bbfh'
DB_USER='bbfh'
DB_DATABASE='bbfh_prod'

# -- Mirror database
echo "Mirroring database..."
echo "drop database bbfh_dev" | psql -h localhost -U bbfh bbfh_test
echo "create database bbfh_dev" | psql -h localhost -U bbfh bbfh_test
ssh $DB_HOST "pg_dump -h localhost -U $DB_USER $DB_DATABASE |gzip" |gunzip |psql -h localhost -U bbfh bbfh_dev
