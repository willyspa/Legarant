@RestResource(urlMapping='/Contract/*')
global with sharing class ContractRest {

    @HttpGet
    global static Contract doGet() {
        RestRequest req = RestContext.request;
        String contractId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Contract result = [SELECT Id, StartDate, EndDate, ContractTerm, Status, AccountId, Account.Name FROM Contract WHERE Id = :contractId];

        return result;
    }

    @HttpPost // a tester
        global static String doPost(String Status,Date StartDate, Integer ContractTerm, String AccountId) {
            Contract contract = new Contract();
            contract.StartDate = StartDate;
            contract.ContractTerm = ContractTerm;
            contract.Status = Status;
            contract.AccountId = AccountId;

            insert contract;
            return contract.Id;
    }
/*
    @HttpPut // a tester
    global static Integer doPatch(String FirstName,String LastName,String Email) {
        Contract contract = new Contract();
        contract.FirstName = FirstName;
        contract.LastName = LastName;
        contract.Email = Email;
        update contract;
        return 1;
    }*/
}