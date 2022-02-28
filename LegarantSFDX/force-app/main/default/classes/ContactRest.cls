@RestResource(urlMapping='/Contact/*')
global with sharing class ContactRest {

    @HttpDelete
    global static Contact doDelete() {

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String contactId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Contact contact = [SELECT Id, active__c FROM Contact WHERE Id = :contactId];
        contact.active__c = false;

        update contact;

        return contact;
    }


    @HttpGet
    global static Contact doGet() {

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String contactId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Contact result = [SELECT Id, Name, Phone, Email, active__c FROM Contact WHERE Id = :contactId];

        return result;
    }

  
    @HttpPost
    global static String doPost(String FirstName,String LastName,String Email) {

        Contact contact = new Contact(FirstName = FirstName, LastName = LastName, Email = Email); 
        String errorMsg = 'A contact is already linked to this email';

        Integer NbOfContact = [SELECT Id FROM Contact WHERE Email = :Email].size();

        if(NbOfContact == 0){
            insert contact;
            return contact.Id;
        }else{
            return errorMsg;
        }

    }

    @HttpPatch // a tester
        global static String doPatch(String FirstName,String LastName,String Email) {

            RestRequest req = RestContext.request;
            String updated = 'updated';
            String errorMsg = 'A contact is already linked to this email or the mail is Null';
            Integer nbOfContact;

            String contactId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);

            if(String.isBlank(contactId) || String.valueOf(contactId) == ':RECORD_ID%20'){

                nbOfContact = [SELECT Id, FirstName, LastName, Phone, Email FROM Contact WHERE Email = :Email].size();
                if(nbOfContact == 0){
                    Contact contact = new Contact(FirstName = FirstName, LastName = LastName, Email = Email);
                    insert contact;
    
                    return contact.Id; 
                }else{
                    return errorMsg;
                }
               
            }else{
               
                Contact contact = [SELECT Id, FirstName, LastName, Phone, Email FROM Contact WHERE Id = :contactId];
                contact.FirstName = String.isBlank(FirstName) ? contact.FirstName : FirstName;
                contact.LastName = String.isBlank(LastName) ? contact.LastName : LastName;

                if(contact.Email == Email){

                    update contact;
                    return updated;

                }else{

                    contact.Email = String.isBlank(Email) ? contact.Email : Email;

                    nbOfContact = [SELECT Id, FirstName, LastName, Phone, Email FROM Contact WHERE Email = :Email AND Id != :contactId].size();

                    if(nbOfContact == 0 && Email != null){
                        update contact;
                        return updated;
                    }else{
                        return errorMsg;
                    }
                }
            }

    }

    @HttpPut
    global static String doPut(String FirstName,String LastName,String Email) {
        
        RestRequest req = RestContext.request;
        String updated = 'updated';
        String errMsg = 'Can\'t update a contact Email with an Email already in the database';
        Integer NbOfContact;
        String contactId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);

        Contact contact = [SELECT Id, FirstName, LastName, Phone, Email FROM Contact WHERE Id = :contactId];
        contact.FirstName = String.isBlank(FirstName) ? contact.FirstName : FirstName;
        contact.LastName = String.isBlank(LastName) ? contact.LastName : LastName;

        if(!String.isBlank(Email) && contact.Email != Email){

            NbOfContact = [SELECT Id FROM Contact WHERE Email = :Email].size();

            if(NbOfContact>0){
                return errMsg;
            }else{
                contact.Email = Email;
                update contact;
                return updated;
            }
        }else{
            update contact;
            return updated;
        }

        /*
        if(NbOfContact == 1){
            contact.Email = Email;
        }else{
            return 'Can\'t update a contact Email with an Email already in the database ';
        }*/
            
        

    }
}