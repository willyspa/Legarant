@RestResource(urlMapping='/Contract/*')
global with sharing class ContractRest {

    private static String headAttribute = 'Content-Type';
    private static String headValue = 'application/json';
    
    @HttpPost
    global static void doPost(String Status,Date StartDate, Integer ContractTerm, String AccountId) {

            Contract contract = new Contract(StartDate = StartDate, ContractTerm = ContractTerm, Status = Status, AccountId = AccountId);
            insert contract;

            ContractRestAPI contractResponse = ContractRestAPI.parse(contract);
            contractResponse.setResponseMessage('Successfully created');
            RestResponse res = RestContext.response;
            res.addHeader(headAttribute,headValue);
            res.responseBody = Blob.valueOf(contractResponse.toJSON());
    }

    @HttpPut // a tester
    global static void doPut(String Status,Date StartDate, Integer ContractTerm, String AccountId) {

        String updated = 'updated';
        String errorMsg = 'No contract related to this Id';
        RestRequest req = RestContext.request;
        String contractId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        List<Contract> contracts = [SELECT Id, StartDate, ContractTerm, Status, AccountId FROM Contract WHERE Id = :contractId LIMIT 1];



        if(contracts.size() == 1){
            Contract contract = contracts[0];
            contract.Status = String.isBlank(Status) ? contract.Status : Status;
            contract.StartDate = StartDate == contract.StartDate ? contract.StartDate : StartDate;
            contract.ContractTerm = contract.ContractTerm == ContractTerm ? contract.ContractTerm : ContractTerm;

            update contract;

            RestResponse res = RestContext.response;
            res.addHeader(headAttribute,headValue);
            res.responseBody = Blob.valueOf(updated);
        }else{
            RestResponse res = RestContext.response;
            res.addHeader(headAttribute,headValue);
            res.responseBody = Blob.valueOf(errorMsg);
            res.statusCode = 500;
        }
    }
}



