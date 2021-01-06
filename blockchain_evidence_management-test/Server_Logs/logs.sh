#!/bin/bash

docker logs Orderer 2>&1 | tee .Orderer.log

docker logs Police-Station_CA 2>&1 | tee ./Police-Station_CA.log
docker logs Police-Station_Peer 2>&1 | tee ./Police-Station_Peer.log

docker logs Police-Agency_CA 2>&1 | tee ./Police-Agency_CA.log
docker logs Police-Agency_Peer 2>&1 | tee ./Police-Agency_Peer.log

docker logs Police-CyberSecurity-Agency_CA 2>&1 | tee ./Police-CyberSecurity-Agency_CA.log
docker logs Police-CyberSecurity-Agency_Peer 2>&1 | tee ./Police-CyberSecurity-Agency_Peer.log

docker logs Prosecutor_Peer 2>&1 | tee ./Prosecutor_Peer.log
docker logs Prosecutor_CA 2>&1 | tee ./Prosecutor_CA.log

docker logs Court_CA 2>&1 | tee ./Court_CA.log
docker logs Court_Peer 2>&1 | tee ./Court_Peer.log