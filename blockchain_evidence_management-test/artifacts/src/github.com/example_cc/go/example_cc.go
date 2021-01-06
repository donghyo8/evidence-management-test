package main

import (
   "fmt"
   "time"

    "github.com/hyperledger/fabric/core/chaincode/shim"
    pb "github.com/hyperledger/fabric/protos/peer"
)

type SimpleChaincode struct {
}

func (t *SimpleChaincode) Init(stub shim.ChaincodeStubInterface) pb.Response {
    _, args := stub.GetFunctionAndParameters()
    var Enroll_Id, Name, Jurisdictional, Department_Position, Digital_Evidence string
    var Investigation_Info, Result_Report string
    var IdentityId, date string         
    var EvidenceData string    
    var err error

    Enroll_Id = args[0]
    Name = args[1]
    Jurisdictional = args[2]
    Department_Position = args[3]
    Digital_Evidence = args[4]
    Investigation_Info = args[5]
    Result_Report = args[6]
    IdentityId = Enroll_Id      

    now := time.Now()
    convH, _ := time.ParseDuration("9h")
    date = now.Add(+convH).Format("2006-01-02 15:04:05") 

    fmt.Printf("Date : %s\n Enroll_Id :%s\n Name : %s\n Jurisdictional : %s\n Department_Position : %s\n Digital_Evidence : %s\n Investigation_Info : %s\n Result_Report : %s\n", date, Enroll_Id, Name, Jurisdictional, Department_Position, Digital_Evidence, Investigation_Info, Result_Report)

    EvidenceData = "\n" + "Update Date : " + date + "\n" + "Enroll_ID : "  + Enroll_Id + "\n" + "Name : " + Name +  "\n" + "Jurisdictional : " + Jurisdictional + "\n" + "Department_Position : " + Department_Position +  "\n" + "Digital_Evidence : " + Digital_Evidence + "\n"  + "Investigation_Info : " + Investigation_Info + "\n" + "Result_Report : " + Result_Report;

    err = stub.PutState(IdentityId, []byte(EvidenceData))
    if err != nil {
        return shim.Error(err.Error())
    }

    return shim.Success(nil)
}

func (t *SimpleChaincode) Invoke(stub shim.ChaincodeStubInterface) pb.Response {
    function, args := stub.GetFunctionAndParameters()
    if function == "invoke" {
        return t.invoke(stub, args)
    } else if function == "delete" {
        return t.delete(stub, args)
    } else if function == "query" {
        return t.query(stub, args)
    }

    return shim.Error("Invalid invoke function name. Expecting \"invoke\" \"delete\" \"query\"")
}


func (t *SimpleChaincode) invoke(stub shim.ChaincodeStubInterface, args []string) pb.Response {
    var IdentityId string 
    var  Analysis_Result, date string 
    var err error
    
    if len(args) != 2 {
        return shim.Error("Incorrect number of arguments. Expecting 3")
    }

    IdentityId = args[0]
    Analysis_Result = args[1]
    valbytes, err := stub.GetState(IdentityId)
    if err != nil {
        return shim.Error("Failed to get state")
    }

    now := time.Now()
    convH, _ := time.ParseDuration("9h")
    date = now.Add(+convH).Format("2006-01-02 15:04:05") 

    fmt.Printf(date)

    stringData := string(valbytes)
    stringData = "\n" + "Update Date = "+ date + stringData[34:len(stringData)]
    stringData += "\n" + "Analysis_Result : " +  Analysis_Result

    err = stub.PutState(IdentityId, []byte(stringData))
    if err != nil {
        return shim.Error("Failed to put state")
    }
    return shim.Success(nil)
}



func (t *SimpleChaincode) delete(stub shim.ChaincodeStubInterface, args []string) pb.Response {

    if len(args) != 1 {
        return shim.Error("Incorrect number of arguments. Expecting 1")
    }

    IdentityId := args[0]

    err := stub.DelState(IdentityId)
    if err != nil {
        return shim.Error("Failed to delete state")
    }

    return shim.Success(nil)
}


func (t *SimpleChaincode) query(stub shim.ChaincodeStubInterface, args []string) pb.Response {
    var A, date string 
    var err error

    now := time.Now()
    convH, _ := time.ParseDuration("9h")
    date = now.Add(+convH).Format("2006-01-02 15:04:05") 

    
    if len(args) != 1 {
        return shim.Error("Incorrect number of arguments. Expecting name of the person to query")
    }

    A = args[0]


    Avalbytes, err := stub.GetState(A)
    if err != nil {
        jsonResp := "{\"Error\":\"Failed to get state for " + A + "\"}"
        return shim.Error(jsonResp)
    }

    if Avalbytes == nil {
        jsonResp := "{\"Error\":\"Nil amount for " + A + "\"}"
        return shim.Error(jsonResp)
    }

    jsonResp := "\n" + "{\"EnrollId\":\"" + A  + "\"\n\"Digital Evidence History Data\":\"" + string(Avalbytes) + "\"}"
    fmt.Printf("[Query Date] : %s\n[Query Result] : %s\n",date, jsonResp)
    return shim.Success(Avalbytes)
}

func main() {
    err := shim.Start(new(SimpleChaincode))
    if err != nil {
        fmt.Printf("Error starting Simple chaincode: %s", err)
    }
}
