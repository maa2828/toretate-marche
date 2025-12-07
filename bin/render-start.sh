#!/bin/bash
set -e

echo "Running database migrations..."
bin/rails db:migrate

echo "Starting Rails server..."
exec bin/rails server -b 0.0.0.0
