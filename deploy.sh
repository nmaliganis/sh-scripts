#!/bin/bash
ENV_ALIAS='dev'

API_ALIAS='telemetry.api'

export AZ_RC_NAME_ID=ntuacontainers.azurecr.io
export AZ_RC_ACCESS_USER_ID=ntuacontainers
export AZ_RC_REGISTRY=ntuacontainers
export AZ_RC_SECRET_PASS_KEY=/noKvfu1YkxN3nPtMLt5xsyGEl8yC+uQ

echo "---------------------------------------"
echo "---------------------------------------"
echo "Clear Containers..."
docker rm -vf $(docker ps -a -q)
echo "Clear Images..."
docker rmi -f $(docker images -a -q)
echo "Build images..."
docker-compose -f docker-compose.yml up -d

echo "---------------------------------------"
echo "---------------------------------------"
echo "Azure Arc Login..."
docker login $AZ_RC_NAME_ID -u $AZ_RC_ACCESS_USER_ID -p $AZ_RC_SECRET_PASS_KEY

echo "---------------------------------------"
echo "---------------------------------------"
echo "Tag Images"
docker tag xanax/telemetry.api:linux-latest $AZ_RC_NAME_ID/$AZ_RC_ACCESS_USER_ID/$API_ALIAS
docker push $AZ_RC_NAME_ID/$AZ_RC_ACCESS_USER_ID/$API_ALIAS
echo "Pushed ... $AZ_RC_NAME_ID/$AZ_RC_ACCESS_USER_ID/$API_ALIAS"

echo "---------------------------------------"
echo "---------------------------------------"
echo "Finished"