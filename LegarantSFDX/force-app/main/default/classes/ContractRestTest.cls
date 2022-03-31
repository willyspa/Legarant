@isTest
public with sharing class ContractRestTest {

    @testSetup static void makeData() {

        Account acct = new Account(Name='acct');
        insert acct;

        Contract contract = new Contract(StartDate = Date.today(), ContractTerm = 6, Status = 'Draft', AccountId = acct.Id);
        insert contract;
    }

    @isTest
    static void createContract() {

    Test.startTest();

    RestRequest request = new RestRequest();
    RestResponse res = new RestResponse();

    RestContext.response = res;
    request.requestURI = 'https://openclassrooms63-dev-ed.lightning.force.com/services/apexrest/Contract/';
    request.httpMethod = 'POST';
    RestContext.request = request;
    Id acctId = [SELECT Id FROM Account LIMIT 1].Id;
    ContractRest.doPost('Draft',Date.today(), 5, acctId);

    Test.stopTest();

    Integer nbOfContract = [SELECT Id FROM Contract].size();
    System.assertEquals(2, nbOfContract);     
    }

    @isTest
    static void updateContract() {

    Test.startTest();

    Id contractId = [SELECT Id FROM Contract LIMIT 1].Id;
    RestRequest request = new RestRequest();
    RestResponse res = new RestResponse();

    RestContext.response = res;
    request.requestURI = 'https://openclassrooms63-dev-ed.lightning.force.com/services/apexrest/Contract/'+contractId;
    request.httpMethod = 'PUT';
    RestContext.request = request;

    Id acctId = [SELECT Id FROM Account LIMIT 1].Id;
    ContractRest.doPut('Draft',Date.today(), 5, acctId);

    Test.stopTest();

    Contract updatedContract = [SELECT Id,ContractTerm FROM Contract LIMIT 1];
    System.assertEquals(5, updatedContract.ContractTerm); 
   
    }
}
