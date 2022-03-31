global class ContractRestAPI{

    private string id;
    private String status;

    public void setResponseMessage(String status){
        this.status = status;
    }

    global static ContractRestAPI parse(Contract contract){

        ContractRestAPI newContractAPI = new ContractRestAPI(); 
        newContractAPI.id = contract.id;

        return newContractAPI;
    }

    global static ContractRestAPI parsePost(Contract contract){

        ContractRestAPI newContractAPI = new ContractRestAPI();  
        newContractAPI.id = contract.id;

        return newContractAPI;
    }
    
    global String toJSON(){
        return JSON.serialize(this);
    }

    global String toJSONpretty(){
        return JSON.serializePretty(this);
    }
}