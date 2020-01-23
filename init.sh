#!/bin/sh

export FABRIC_CFG_PATH=${PWD}
CHANNEL_NAME=basechannel

rm -fr artifacts/*
rm -fr crypto-config/*

echo 'GENERATING CRYPTO CONFIG'

cryptogen generate --config=./crypto-config.yaml

if [ "$?" -ne 0 ]; then
  echo "Failed to generate crypto material..."
  exit 1
fi

echo 'GENERATING ORDER GENSIS BLOCK'

configtxgen -profile Raft  -channelID base-sys-channel -outputBlock ./artifacts/genesis.block

if [ "$?" -ne 0 ]; then
  echo "Failed to generate gensis block..."
  exit 1
fi

echo 'GENERATING CHANNEL ARTIFACTS'

configtxgen -profile MainChannel -outputCreateChannelTx  ./artifacts/channel.tx -channelID $CHANNEL_NAME

if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel artifacts"
  exit 1
fi

echo 'ANCHOR PEER UPDATES'

configtxgen -profile MainChannel -outputAnchorPeersUpdate  ./artifacts/BaseLeftOrg.tx -channelID $CHANNEL_NAME -asOrg LeftOrgMSP

configtxgen -profile MainChannel -outputAnchorPeersUpdate  ./artifacts/BaseRightOrg.tx -channelID $CHANNEL_NAME -asOrg RightOrgMSP

if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer updates"
  exit 1
fi

echo 'CA LEFT CERT NAME'

echo $(cd crypto-config/peerOrganizations/base.left/ca && ls *_sk)

echo 'CA RIGHT CERT NAME'

echo $(cd crypto-config/peerOrganizations/base.right/ca && ls *_sk)

export CA_LEFT=$(cd crypto-config/peerOrganizations/base.left/ca && ls *_sk)

export CA_RIGHT=$(cd crypto-config/peerOrganizations/base.right/ca && ls *_sk)

echo 'MOFDIFY COMPOSE FILE TO REPLACE THE CA CERTS'

sed -i'' -e  "s#CA_LEFT#$CA_LEFT#g"  docker-compose.yaml
sed -i'' -e  "s#CA_RIGHT#$CA_RIGHT#g" docker-compose.yaml

echo 'CA CERTS REPLACED'

echo 'ALL ARTIFACTS GENERATED SUCCESSFULLY'