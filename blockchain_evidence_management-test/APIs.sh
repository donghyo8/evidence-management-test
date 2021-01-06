#!/bin/bash

# json jq 설치
jq --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Please Install 'jq' https://stedolan.github.io/jq/ to execute this script"
	echo
	exit 1
fi

starttime=$(date +%s)

# 도움말
function printHelp () {
  echo "Usage: "
  echo "  ./testAPIs.sh -l golang|node"
  echo "    -l <language> - chaincode language (defaults to \"golang\")"
}
# Default golang
LANGUAGE="golang"

# 커맨드라인 인수 parse
while getopts "h?l:" opt; do
  case "$opt" in
    h|\?)
      printHelp
      exit 0
    ;;
    l)  LANGUAGE=$OPTARG
    ;;
  esac
done

## chaincode 경로 설정
function setChaincodePath(){
	LANGUAGE=`echo "$LANGUAGE" | tr '[:upper:]' '[:lower:]'`
	case "$LANGUAGE" in
		"golang")
		CC_SRC_PATH="github.com/example_cc/go"
		;;
		"node")
		CC_SRC_PATH="$PWD/artifacts/src/github.com/example_cc/node"
		;;
		*) printf "\n ------ Language $LANGUAGE is not supported yet ------\n"$
		exit 1
	esac
}

setChaincodePath


########################### 유저 등록 #############################

echo "========== (POST request ---> Police-Station) Digital Evidence System Identity Enroll =========="
echo
ORG1_TOKEN=$(curl -s -X POST \
  http://localhost:3343/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=Investigator1&orgName=Org1')
echo $ORG1_TOKEN
ORG1_TOKEN=$(echo $ORG1_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "ORG1 token : $ORG1_TOKEN"
echo

echo "========== (POST request ---> Police-Station) Digital Evidence System Identity Enroll =========="
echo
ORG1_TOKEN=$(curl -s -X POST \
  http://localhost:3343/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=Investigator2&orgName=Org1')
echo $ORG1_TOKEN
ORG1_TOKEN=$(echo $ORG1_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "ORG1 token : $ORG1_TOKEN"
echo

echo "========== (POST request ---> Police-Station) Digital Evidence System Identity Enroll =========="
echo
ORG1_TOKEN=$(curl -s -X POST \
  http://localhost:3343/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=Investigator3&orgName=Org1')
echo $ORG1_TOKEN
ORG1_TOKEN=$(echo $ORG1_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "ORG1 token : $ORG1_TOKEN"
echo


echo "========== (POST request ---> Police-CyberSecurity-Agency) Digital Evidence System Identity Enroll =========="
echo
ORG2_TOKEN=$(curl -s -X POST \
  http://localhost:3343/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=Digital_Evidence_Analyser1&orgName=Org2')
echo $ORG2_TOKEN
ORG2_TOKEN=$(echo $ORG2_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "ORG2 token : $ORG2_TOKEN"
echo
echo

echo "========== (POST request ---> Police-CyberSecurity-Agency) Digital Evidence System Identity Enroll =========="
echo
ORG2_TOKEN=$(curl -s -X POST \
  http://localhost:3343/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=Digital_Evidence_Analyser2&orgName=Org2')
echo $ORG2_TOKEN
ORG2_TOKEN=$(echo $ORG2_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "ORG2 token : $ORG2_TOKEN"
echo
echo


echo "========== (POST request ---> Prosecutor) Digital Evidence System Identity Enroll =========="
echo
ORG3_TOKEN=$(curl -s -X POST \
  http://localhost:3343/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=prosecutor1&orgName=Org3')
echo $ORG3_TOKEN
ORG3_TOKEN=$(echo $ORG3_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "ORG3 token : $ORG3_TOKEN"
echo
echo

echo "========== (POST request ---> Prosecutor) Digital Evidence System Identity Enroll =========="
echo
ORG3_TOKEN=$(curl -s -X POST \
  http://localhost:3343/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=prosecutor2&orgName=Org3')
echo $ORG3_TOKEN
ORG3_TOKEN=$(echo $ORG3_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "ORG3 token : $ORG3_TOKEN"
echo
echo


echo "========== (POST request ---> Police-Agency) Digital Evidence System Identity Enroll =========="
echo
ORG4_TOKEN=$(curl -s -X POST \
  http://localhost:3343/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=PoliceAgency1&orgName=Org4')
echo $ORG4_TOKEN
ORG4_TOKEN=$(echo $ORG4_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "ORG4 token : $ORG4_TOKEN"
echo
echo

echo "========== (POST request ---> Court) Digital Evidence System Identity Enroll =========="
echo
ORG5_TOKEN=$(curl -s -X POST \
  http://localhost:3343/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=Judge&orgName=Org5')
echo $ORG5_TOKEN
ORG5_TOKEN=$(echo $ORG5_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "ORG5 token : $ORG5_TOKEN"
echo
echo



########################### 채널 생성 및 채널 조인 #############################

echo "POST request_채널 생성 ..."
echo
curl -s -X POST \
  http://localhost:3343/channels \
  -H "authorization: Bearer $ORG3_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"channelName":"mychannel",
	"channelConfigPath":"../artifacts/channel/DigitalEvidenceChannel.tx"
}'
echo
echo

sleep 5

echo "POST request_채널 조인: Org1"
echo
curl -s -X POST \
  http://localhost:3343/channels/mychannel/peers \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com"]
}'
echo
echo

echo "POST request_채널 조인: Org2"
echo
curl -s -X POST \
  http://localhost:3343/channels/mychannel/peers \
  -H "authorization: Bearer $ORG2_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org2.example.com"]
}'
echo
echo


echo "POST request_채널 조인: Org3"
echo
curl -s -X POST \
  http://localhost:3343/channels/mychannel/peers \
  -H "authorization: Bearer $ORG3_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org3.example.com"]
}'
echo
echo


echo "POST request_채널 조인: Org4"
echo
curl -s -X POST \
  http://localhost:3343/channels/mychannel/peers \
  -H "authorization: Bearer $ORG4_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org4.example.com"]
}'
echo
echo


echo "POST request_채널 조인: Org5"
echo
curl -s -X POST \
  http://localhost:3343/channels/mychannel/peers \
  -H "authorization: Bearer $ORG5_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org5.example.com"]
}'
echo
echo


########################### 체인코드 설치 #############################

echo "POST Install_체인코드: Org1"
echo
curl -s -X POST \
  http://localhost:3343/chaincodes \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d "{
	\"peers\": [\"peer0.org1.example.com\"],
	\"chaincodeName\":\"mycc\",
	\"chaincodePath\":\"$CC_SRC_PATH\",
	\"chaincodeType\": \"$LANGUAGE\",
	\"chaincodeVersion\":\"v0\"
}"
echo
echo

echo "POST Install_체인코드: Org2"
echo
curl -s -X POST \
  http://localhost:3343/chaincodes \
  -H "authorization: Bearer $ORG2_TOKEN" \
  -H "content-type: application/json" \
  -d "{
	\"peers\": [\"peer0.org2.example.com\"],
	\"chaincodeName\":\"mycc\",
	\"chaincodePath\":\"$CC_SRC_PATH\",
	\"chaincodeType\": \"$LANGUAGE\",
	\"chaincodeVersion\":\"v0\"
}"
echo
echo

echo "POST Install_체인코드: Org3"
echo
curl -s -X POST \
  http://localhost:3343/chaincodes \
  -H "authorization: Bearer $ORG3_TOKEN" \
  -H "content-type: application/json" \
  -d "{
	\"peers\": [\"peer0.org3.example.com\"],
	\"chaincodeName\":\"mycc\",
	\"chaincodePath\":\"$CC_SRC_PATH\",
	\"chaincodeType\": \"$LANGUAGE\",
	\"chaincodeVersion\":\"v0\"
}"
echo
echo

echo "POST Install_체인코드: Org4"
echo
curl -s -X POST \
  http://localhost:3343/chaincodes \
  -H "authorization: Bearer $ORG4_TOKEN" \
  -H "content-type: application/json" \
  -d "{
	\"peers\": [\"peer0.org4.example.com\"],
	\"chaincodeName\":\"mycc\",
	\"chaincodePath\":\"$CC_SRC_PATH\",
	\"chaincodeType\": \"$LANGUAGE\",
	\"chaincodeVersion\":\"v0\"
}"
echo
echo

echo "POST Install_체인코드: Org5"
echo
curl -s -X POST \
  http://localhost:3343/chaincodes \
  -H "authorization: Bearer $ORG5_TOKEN" \
  -H "content-type: application/json" \
  -d "{
	\"peers\": [\"peer0.org5.example.com\"],
	\"chaincodeName\":\"mycc\",
	\"chaincodePath\":\"$CC_SRC_PATH\",
	\"chaincodeType\": \"$LANGUAGE\",
	\"chaincodeVersion\":\"v0\"
}"
echo
echo


########################### Instantiate #############################

echo "POST Instantiate_체인코드: Org1"
echo
curl -s -X POST \
  http://localhost:3343/channels/mychannel/chaincodes \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d "{
	\"chaincodeName\":\"mycc\",
	\"chaincodeVersion\":\"v0\",
	\"chaincodeType\": \"$LANGUAGE\",
	\"args\":[\"Investigator1\",\"DonghyoKim\",\"Police-Station\",\"Seoul\",\"SmartPhone\", \"He was attacked in the bathroom of a hamburger restaurant in Itaewon-dong, Yongsan-gu, Seoul, around 5 p.m.\", \"The culprit is expected to be a man in his 30s, 180 in height and 80 in weight.\"]
}"
echo
echo


sleep 10

########################### Invoke #############################

echo "POST invoke chaincode on peers of Org1"
echo
VALUES=$(curl -s -X POST \
  http://localhost:3343/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d "{
  \"peers\": [\"peer0.org1.example.com\"],
  \"fcn\":\"invoke\",
  \"args\":[\"Investigator1\",\"The culprit is a man in his 20s, estimated to be 160 and weight 90.\"]
}")
echo $VALUES
MESSAGE=$(echo $VALUES | jq -r ".message")
TRX_ID=${MESSAGE#*ID: }
echo

########################### Query #############################

echo "GET query chaincode on peer1 of Org1"
echo
curl -s -X GET \
  http://localhost:3343/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d "{
  \"peers\": [\"peer0.org1.example.com\"],
  \"fcn\":\"query\",
  \"args\":[\"Investigator1\"]
}"
echo
echo

echo "GET query Block by blockNumber"
echo
curl -s -X GET \
  "http://localhost:3343/channels/mychannel/blocks/1?peer=peer0.org1.example.com" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "GET query Transaction by TransactionID"
echo
curl -s -X GET http://localhost:3343/channels/mychannel/transactions/$TRX_ID?peer=peer0.org1.example.com \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

########################### 블록 정보 #############################
#echo "GET query Block by Hash"
#echo
#hash=????
#curl -s -X GET \
#  "http://localhost:8080/channels/mychannel/blocks?hash=$hash&peer=peer1" \
#  -H "authorization: Bearer $ORG1_TOKEN" \
#  -H "cache-control: no-cache" \
#  -H "content-type: application/json" \
#  -H "x-access-token: $ORG1_TOKEN"
#echo
#echo

echo "GET query ChainInfo"
echo
curl -s -X GET \
  "http://localhost:3343/channels/mychannel?peer=peer0.org1.example.com" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "GET query Installed chaincodes"
echo
curl -s -X GET \
  "http://localhost:3343/chaincodes?peer=peer0.org1.example.com" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "GET query Instantiated chaincodes"
echo
curl -s -X GET \
  "http://localhost:3343/channels/mychannel/chaincodes?peer=peer0.org1.example.com" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "GET query Channels"
echo
curl -s -X GET \
  "http://localhost:3343/channels?peer=peer0.org1.example.com" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo


echo "Total execution time : $(($(date +%s)-starttime)) secs ..."
