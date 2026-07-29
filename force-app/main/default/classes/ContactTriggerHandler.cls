public with sharing class ContactTriggerHandler {
    public static void updateContactCount(List<Contact> newList, List<Contact> oldList, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete){
        Set<Id> accId = new Set<Id>();
        if(isInsert || isUnDelete){
            for(Contact c: newList){
                if(c.AccountId != null){
                    accId.add(c.AccountId);
                }
            }
        }
        if(isDelete){
            for(Contact c: oldList){
                if(c.AccountId != null){
                    accId.add(c.AccountId);
                }
            }
        }
        if(isUpdate){
            for(Integer i=0; i< newList.size(); i++){
                Contact newCon = newList[i];
                Contact oldCon = oldList[i];
                if(newList[i].AccountId !=  oldList[i].AccountId){
                    if (newCon.AccountId != null) {
                        accId.add(newCon.AccountId);
                    }

                    if (oldCon.AccountId != null) {
                        accId.add(oldCon.AccountId);
                    }
                }
            }
        }
        if(accId.isEmpty()){
            return;
        }

        List<Account> accList = [SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id IN :accId WITH USER_MODE];
        Map<Id, Integer> accountContactCount = new Map<Id, Integer>();
        for(AggregateResult ar: [Select AccountId accountId, count(Id) total From Contact Where AccountId IN:accId WITH USER_MODE GROUP BY AccountId]){
            accountContactCount.put((Id)ar.get('accountId'), (Integer)ar.get('total'));
        }
        List<Account> accUpdate = new List<Account>();
        for(Id accountId: accId){
            accUpdate.add(new Account(
                Id = accountId,
                NumberOfContacts__c = accountContactCount.containsKey(accountId) ? accountContactCount.get(accountId) : 0
            ));
        }

        if(!accUpdate.isEmpty()){
            update accUpdate;
        }
    }
}