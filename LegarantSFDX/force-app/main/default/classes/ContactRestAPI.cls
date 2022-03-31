global class ContactRestAPI{

    private string id;
    private String status;

    public void setResponseMessage(String status){
        this.status = status;
    }

    global static ContactRestAPI parse(Contact contact){

        ContactRestAPI newContactAPI = new ContactRestAPI();
        newContactAPI.id = contact.id;

        return newContactAPI;
    }

    global static ContactRestAPI parsePost(Contact contact){

        ContactRestAPI newContactAPI = new ContactRestAPI();  
        newContactAPI.id = contact.id;

        return newContactAPI;
    }
    
    global String toJSON(){
        return JSON.serialize(this);
    }

    global String toJSONpretty(){
        return JSON.serializePretty(this);
    }
}