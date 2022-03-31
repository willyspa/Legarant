@isTest
public with sharing class ContactRestTest {

    @testSetup static void makeData() {
        Contact c = new Contact(
            LastName = 'LastName',
            FirstName = 'FirstName',
            Email = 'email@email.com',
            MobilePhone = '0102030405',
            active__c = true
        );
        insert c;
    }

    @isTest
    static void deleteContact() {

        Test.startTest();

        Id contactId = [SELECT Id FROM Contact LIMIT 1].Id;
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = request;
        RestContext.response = res;
        request.requestURI = 'https://openclassrooms63-dev-ed.lightning.force.com/services/apexrest/Contact/'+contactId;
        request.httpMethod = 'DELETE';
        RestContext.request = request;
        ContactRest.doDelete();

        Test.stopTest();

        Contact deletedContact = [SELECT Id, active__c FROM Contact LIMIT 1];
        System.assertEquals(false, deletedContact.active__c);     
    }
    
    @isTest
    static void createContactWithSameEmail() {

        Test.startTest();

        Id contactId = [SELECT Id FROM Contact WHERE Email = 'email@email.com' LIMIT 1].Id;
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();

        RestContext.request = request;
        RestContext.response = res;
        request.requestURI = 'https://openclassrooms63-dev-ed.lightning.force.com/services/apexrest/Contact/'+contactId;
        request.httpMethod = 'POST';
        RestContext.request = request;
        ContactRest.doPost('TestFirstName', 'TestLastName', 'Email@Email.com','0102030405');

        Test.stopTest();

        Integer nbOfContact = [SELECT Id FROM Contact].size();
        System.assertEquals(1, nbOfContact);     
    }

@isTest
    static void createContact() {

    Test.startTest();
    
    RestRequest request = new RestRequest();
    RestResponse res = new RestResponse();

    RestContext.response = res;
    request.requestURI = 'https://openclassrooms63-dev-ed.lightning.force.com/services/apexrest/Contact/';
    request.httpMethod = 'POST';
    RestContext.request = request;
    ContactRest.doPost('TestFirstName', 'TestLastName', 'new@email.com','0102030708');

    Test.stopTest();

    Integer nbOfContact = [SELECT Id FROM Contact].size();
    System.assertEquals(2, nbOfContact);     
    }

    @isTest
    static void updateContact() {

    Test.startTest();

    Contact c = new Contact(FirstName = 'insert', LastName = 'insert', Email = 'email@in.database');
    insert c;

    Id contactId = [SELECT Id FROM Contact WHERE Email = 'email@email.com' LIMIT 1].Id;
    System.debug(contactId);
    RestRequest request = new RestRequest();
    RestResponse res = new RestResponse();

    RestContext.response = res;
    request.requestURI = 'https://openclassrooms63-dev-ed.lightning.force.com/services/apexrest/Contact/'+contactId;
    request.httpMethod = 'PUT';
    RestContext.request = request;
    ContactRest.doPut('Updated', 'Updated','email@email.com', '0102030405');



    //Try to update with an email already in DB
    ContactRest.doPut('Updated', 'Updated','email@in.database', '0102030405');

    Test.stopTest();

    Contact updatedContact = [SELECT Id,FirstName,LastName,Email FROM Contact WHERE FirstName ='updated' LIMIT 1];
    System.debug(updatedContact);
    //Check if the fields of the contact  are changed
    System.assertEquals('Updated', updatedContact.FirstName); 
    System.assertEquals('Updated', updatedContact.LastName); 
    //Check duplicate 
    System.assertEquals('email@email.com', updatedContact.Email);  
    }






    @isTest
    static void createContactWithPatch() {

    Test.startTest();

    RestRequest request = new RestRequest();
    RestResponse res = new RestResponse();

    RestContext.response = res;
    request.requestURI = 'https://openclassrooms63-dev-ed.lightning.force.com/services/apexrest/Contact/';
    request.httpMethod = 'PATCH';
    RestContext.request = request;
    ContactRest.doPatch('TestFirstName','0102030405','TestLastName','new@email.com','');
    //String firstName, String lastName,String mobilePhone, String email, String id
    //try to insert a secondtime the contact
    ContactRest.doPatch('TestFirstName','0102030405','TestLastName','new@email.com','');
    Test.stopTest();

    Integer nbOfContact = [SELECT Id FROM Contact].size();
    System.assertEquals(2, nbOfContact);     
    }




    @isTest
    static void updateContactWithPatch() {

    Test.startTest();
    Id contactId = [SELECT Id FROM Contact LIMIT 1].Id;
    RestRequest request = new RestRequest();
    RestResponse res = new RestResponse();
    
    RestContext.response = res;
    request.requestURI = 'https://openclassrooms63-dev-ed.lightning.force.com/services/apexrest/Contact/';
    request.httpMethod = 'PATCH';
    RestContext.request = request;
    ContactRest.doPatch('TestFirstName','0102030405','TestLastName','new@email.com','');
    //update contact lastly inserted
    ContactRest.doPatch('TestFirstName','0102030405','TestLastName','new@email.com',contactId);
    //try to change to an email already in the DB
    ContactRest.doPatch('TestFirstName','0102030405','TestLastName','email@email.com',contactId);
    //try to update with a wrong id
    ContactRest.doPatch('TestFirstName','0102030405','TestLastName','new@email.com','e5a46e4az3e5a35ea');
    Test.stopTest();

    Integer nbOfContact = [SELECT Id FROM Contact].size();
    List<Contact> ctcs = [SELECT Email FROM Contact];
    //Check Nb of contacts inserted
    System.assertEquals(2, nbOfContact);
    //Check duplicate on mail
    System.assertNotEquals(ctcs[0].Email, ctcs[1].Email);
    }

    

}


