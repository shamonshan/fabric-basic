
**HLF**

POC to test chaincode as external servvice

HLF version: 2.1.0

**Network Details**

This network has the following configurations

  1. Three ordering node using Raft consensus

  2. Two organizations will have one peer node each

  3. Two certificate authorites for the each organizations

 
Docker compose is used as the container orchstration tool

**Project directory**

 

 1.`base.yaml` we are extending this into our `docker-compose.yaml` it includes common configurations for order,peer and cli containers.

 2.`docker-compose.yaml` Main file for the network creation it includes docker container configuration for the whole network

 3. `crypto-config.yaml` contains  configurations for the certificate generation

 4. `configtx.yaml` contains the policy's for orgz,configurations for the order node and channel



**Installation instruction**

1. Clone the repo

2. Bootstrap the network with `./run.sh`

3. To delete the network `./down.sh`

