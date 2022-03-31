public class contactAPI{

    string id;
    string email;
    string firstName;
    string lastName;
    string mobilePhone;

    public static contactAPI parse(Contact contact){

        contactAPI newContactAPI = new ContactAPI();
        
        newContactAPI.id = contact.id;
        newContactAPI.email = contact.email;
        newContactAPI.firstName = contact.firstName;
        newContactAPI.lastName = contact.lastName;
        newContactAPI.mobilePhone = contact.MobilePhone;

        return newContactAPI;
    }
    
    public String toJSON(){
        return JSON.serialize(this);
    }
}