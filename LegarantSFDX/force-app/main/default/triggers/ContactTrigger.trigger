trigger ContactTrigger on Contact (before insert,before update,before delete) {
    
    //If the userInterface trigger the process the setting Interface__c will be set to true 
    ActivationSettings__c setting = ActivationSettings__c.getInstance();

    System.debug('Setting status :'+setting.Interface__c);

    if(Trigger.IsBefore && Trigger.isInsert && Setting.Interface__c)
        ContactTriggerHelper.checkIfTheContactsAreDuplicate(Trigger.New,Trigger.newMap);

    if(Trigger.IsBefore && Trigger.isUpdate && Setting.Interface__c)
        ContactTriggerHelper.checkIfTheContactsAreDuplicate(Trigger.New,Trigger.newMap);

    //Throw error if the user interface try to delete contacts
    if(Trigger.IsBefore && Trigger.isDelete && Setting.Interface__c)
        throw new ContactException('Suppression de contact impossible');
}