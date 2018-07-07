/**
 * Description: Contact sObject trigger methods.
 * Author: Oscar Becerra
 * Company: gA
 * Email: obecerra@grupoassa.com
 * Created date: 12/10/2014
 **/
public with sharing class ContactTrigger {
    
    public static void asignaPropietario(List<Contact> contactNewList) {
        Map<Id, List<Contact>> childContactListXaccountIdMap = new Map<Id, List<Contact>>();
        for(Contact contact : contactNewList) {
            if(contact.AccountId != null) {
                if(!childContactListXaccountIdMap.containsKey(contact.AccountId)) {
                    childContactListXaccountIdMap.put(contact.AccountId, new List<Contact>());
                }
                childContactListXaccountIdMap.get(contact.AccountId).add(contact);
            }
        }
        if(!childContactListXaccountIdMap.isEmpty()) {
            for(Account account : [
                SELECT OwnerId
                FROM Account
                WHERE Id IN :childContactListXaccountIdMap.keySet()
            ]) {
                for(Contact contact : childContactListXaccountIdMap.get(account.Id)) {
                    contact.OwnerId = account.OwnerId;
                }
            }
        }
    }
}