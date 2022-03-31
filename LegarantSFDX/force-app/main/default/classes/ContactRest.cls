@RestResource(urlMapping='/Contact/*')
global with sharing class ContactRest {

    public static String headAttribute = 'Content-Type';
    public static String headValue = 'application/json';


    //On selectionne le contact et on le désactive
    @HttpDelete
    global static void doDelete() {
        
        RestRequest req = RestContext.request;
        String contactId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        Contact contact = [SELECT Id, active__c FROM Contact WHERE Id = :contactId];
        contact.active__c = false;

        update contact;

        ContactRestAPI contactResponse = ContactRestAPI.parse(contact);
        contactResponse.setResponseMessage('Contact is deactivated');

        RestResponse res = RestContext.response;
        res.addHeader(headAttribute,headValue);
        res.responseBody = Blob.valueOf(contactResponse.toJSON());
    }

    //On renvoie le contact demandé
    @HttpGet
    global static Contact doGet() {

        RestRequest req = RestContext.request;
        String contactId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Contact result = [SELECT Id, Name, Phone, Email, active__c FROM Contact WHERE Id = :contactId];

        return result;
    }
    //on insère le contact
    @HttpPost
    global static void doPost(String FirstName,String LastName,String Email,String MobilePhone) {

        Contact contact = new Contact(FirstName = FirstName, LastName = LastName, Email = Email, MobilePhone = MobilePhone); 
        String errorMsg = 'A contact is already linked to this email';
        String created = 'Successfully created';

        Integer NbOfContact = [SELECT Id FROM Contact WHERE Email = :Email].size();

        if(NbOfContact == 0){
            insert contact;
            ContactRestAPI contactResponse = ContactRestAPI.parse(contact);
            contactResponse.setResponseMessage(created);
            RestResponse res = RestContext.response;
            res.addHeader(headAttribute,headValue);
            res.responseBody = Blob.valueOf(contactResponse.toJSON());
            
        }else{
            contact = [SELECT Id FROM Contact WHERE Email = :Email LIMIT 1];
            ContactRestAPI contactResponse = ContactRestAPI.parse(contact);
            contactResponse.setResponseMessage(errorMsg);
            RestResponse res = RestContext.response;
            res.addHeader(headAttribute,headValue);
            res.responseBody = Blob.valueOf(contactResponse.toJSON());
            res.statusCode = 500;

        }
    }

    
    @HttpPatch 
        global static void doPatch(String firstName, String lastName,String mobilePhone, String email, String id) {

            RestRequest req = RestContext.request;
            String updated = 'updated';
            String errorMsg = 'A contact is already linked to this email';
            String errorMsgNoId = 'No contact linked to this id';
            String created = 'Successfully created';
            Integer nbOfContactWithThisEmail = 0;
            //Si un Email est présent je vérifie sa présence sur la BDD
            if(!String.isBlank(Email)){
                nbOfContactWithThisEmail = [SELECT Id FROM Contact WHERE Email = :email].size();
            }
            //Si aucune Id n'est présente et que l'Email n'existe pas en base on insère le contact
            if(String.isBlank(Id) && nbOfContactWithThisEmail == 0){

                Contact contact = new Contact(FirstName = FirstName, LastName = LastName, Email = Email, MobilePhone = mobilePhone); 
                insert contact;

                ContactRestAPI contactResponse = ContactRestAPI.parse(contact);
                contactResponse.setResponseMessage(created);
                RestResponse res = RestContext.response;
                res.addHeader(headAttribute,headValue);
                res.responseBody = Blob.valueOf(contactResponse.toJSON());
            //Si aucune Id n'est présente mais que l'Email est en BDD une erreur est renvoyée dans le cadre d'une insertion
            }else if(String.isBlank(Id) && nbOfContactWithThisEmail != 0){

                Contact contact = [SELECT Id FROM Contact WHERE Email = :Email LIMIT 1];
                ContactRestAPI contactResponse = ContactRestAPI.parse(contact);
                contactResponse.setResponseMessage(errorMsg);
                RestResponse res = RestContext.response;
                res.addHeader(headAttribute,headValue);
                res.responseBody = Blob.valueOf(contactResponse.toJSON());
                res.statusCode = 500;
            }
            //Si l'Id est présent il nécessaire de faire un update si il n'y a pas de redondance sur l'email, si redondance une erreur est envoyée
            if(!String.isBlank(id)){

                Contact contactToUpdate = null;
                
                // Si le contact n'est pas présent en BDD on envoie une erreur
                Boolean doesThisIdExist = false;
                doesThisIdExist = [SELECT Id, Email, FirstName, LastName, MobilePhone FROM Contact WHERE Id = :id].size()>0 ? true : false;

                if(doesThisIdExist){
                    contactToUpdate = [SELECT Id, Email, FirstName, LastName, MobilePhone FROM Contact WHERE Id = :id];
                }else{
                    RestResponse res = RestContext.response;
                    res.addHeader(headAttribute,headValue);
                    res.responseBody = Blob.valueOf('{"status":"'+errorMsgNoId+'"}');
                    res.statusCode = 500;
                }

                if(doesThisIdExist){
                //mise à jour uniquement si le mail n'est pas déjà présent en BDD
                    if(contactToUpdate.Email == email || (contactToUpdate.Email != email && nbOfContactWithThisEmail == 0 )){

                        contactToUpdate.FirstName = String.isBlank(firstName) ? contactToUpdate.FirstName : FirstName;
                        contactToUpdate.LastName = String.isBlank(lastName) ? contactToUpdate.LastName : LastName;
                        contactToUpdate.Email = String.isBlank(email) ? contactToUpdate.Email : Email;
                        contactToUpdate.MobilePhone = String.isBlank(mobilePhone) ? contactToUpdate.MobilePhone : MobilePhone;
                    
                        update contactToUpdate;

                    }else{

                        Contact contact = [SELECT Id FROM Contact WHERE Email = :Email LIMIT 1];
                        ContactRestAPI contactResponse = ContactRestAPI.parse(contact);
                        contactResponse.setResponseMessage(errorMsg);
                        RestResponse res = RestContext.response;
                        res.addHeader(headAttribute,headValue);
                        res.responseBody = Blob.valueOf(contactResponse.toJSON());
                        res.statusCode = 500;
                    }
                }
            }   


            


    }
    
    //on met à jour le contact
    @HttpPut
    global static void doPut(String FirstName,String LastName,String Email,String MobilePhone) {
        
        String updated = 'updated';
        String errorMsg = 'Can\'t update a contact Email with an Email already in the database';
        Integer NbOfContact;

        RestRequest req = RestContext.request;
        String contactId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);

        Contact contact = [SELECT Id, FirstName, LastName, MobilePhone, Email FROM Contact WHERE Id = :contactId];
        contact.FirstName = String.isBlank(FirstName) ? contact.FirstName : FirstName;
        contact.LastName = String.isBlank(LastName) ? contact.LastName : LastName;
        contact.Email = String.isBlank(Email) ? contact.Email : Email;
        contact.MobilePhone = String.isBlank(MobilePhone) ? contact.MobilePhone : MobilePhone;
        //Si l'email est modifié je verifie si le mail n'est pas déjà présent sur le CRM si il est présent une erreur est renvoyé
        System.debug('Email:'+Email+' - '+'contact.Email:'+contact.Email+'!String.isBlank(Email):'+!String.isBlank(Email));
        System.debug(contact.Email == Email);
        if(!String.isBlank(Email) && contact.Email != Email){

            NbOfContact = [SELECT Id FROM Contact WHERE Email = :Email].size();
            System.debug('NbOfContact:'+NbOfContact);
            if(NbOfContact>0){
                System.debug('error');
                RestResponse res = RestContext.response;
                res.responseBody = Blob.valueOf(errorMsg);
                res.statusCode = 500;
            }else{
                System.debug('update');
                contact.Email = Email;
                update contact;
                RestResponse res = RestContext.response;
                res.responseBody = Blob.valueOf(updated);
            }
        }else if(String.isBlank(Email) || contact.Email == Email){
            System.debug('je ne dois pas rentrer ici');
            update contact;
            RestResponse res = RestContext.response;
            res.responseBody = Blob.valueOf(updated);
        }  
    }

}