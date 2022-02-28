public with sharing class ContactTriggerHelper {
    public static void checkIfTheContactsAreDuplicate(List<Contact> listContacts,Map<Id,Contact> newMap){

        Set<String> setEmail = new Set<String>();
        Set<Id> setId = new Set<Id>();
        Map<Id,Contact> listDuplicateContact = new Map<Id,Contact>();

        for(Contact c:listContacts){
            setEmail.add(c.email);
            setId.add(c.Id);
        }

        listDuplicateContact = new Map<Id,Contact>([SELECT Id, email FROM Contact WHERE email IN :setEmail AND Id NOT IN :setId]);
        
        //Check if the email is already on the database, if true throw an error
        if(listDuplicateContact.size()>0)
            throw new ContactException('Un contact existe déjà avec cet email :'+listDuplicateContact);      
    }
    /*
    public static void CheckIfEmailIsChanged(List<Contact> listContact,Map<Id,Contact> OldMap){
        
        for(Contact c:listContact){
            //Check if the email value is changed, if the value is change an error is throw
            if(c.Email != oldMap.get(c.Id).Email)
                throw new ContactException('L\'email ne peut pas être modifié :'+c.Name+' - '+c.Id);
        }
    }*/
}
