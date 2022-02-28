@RestResource(urlMapping='/Contract/*')
global with sharing class ContractRest {

    @HttpGet
    global static Contract doGet() {
        RestRequest req = RestContext.request;
        String contractId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Contract result = [SELECT Id, StartDate, EndDate, ContractTerm, Status, AccountId, Account.Name FROM Contract WHERE Id = :contractId];

        return result;
    }

    @HttpPost
        global static String doPost(String Status,Date StartDate, Integer ContractTerm, String AccountId) {

            Contract contract = new Contract();
            contract.StartDate = StartDate;
            contract.ContractTerm = ContractTerm;
            contract.Status = Status;
            contract.AccountId = AccountId;

            insert contract;
            return contract.Id;
    }

    @HttpPut // a tester
    global static String doPut(String Status,Date StartDate, Integer ContractTerm, String AccountId) {

        RestRequest req = RestContext.request;
        String contractId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Contract contract = [SELECT Id, StartDate, ContractTerm, Status, AccountId FROM Contract WHERE Id = :contractId LIMIT 1];

        if(contract != null){
            contract.Status = String.isBlank(Status) ? contract.Status : Status;
            contract.StartDate = StartDate == contract.StartDate ? contract.StartDate : StartDate;
            contract.ContractTerm = contract.ContractTerm == ContractTerm ? contract.ContractTerm : ContractTerm;

            update contract;

            return 'updated';

        }else{
            return 'No contract related to this Id';
        }

    }
}



