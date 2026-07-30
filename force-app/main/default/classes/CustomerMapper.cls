public with sharing class CustomerMapper {

    /**
     * Maps AccountWrapper to Salesforce Account
     */
    public static Account mapAccount(CustomerWrapper.AccountWrapper wrapper) {

        if (wrapper == null) {
            return null;
        }

        Account acc = new Account();

        acc.Name = wrapper.name;
        acc.Industry = wrapper.industry;

        // External ID field
        acc.ERP_Account_Id__c = wrapper.accountId;

        return acc;
    }

    /**
     * Maps ContactWrapper to Salesforce Contact
     */
    public static Contact mapContact(
        CustomerWrapper.ContactWrapper wrapper,
        Id accountId
    ) {

        if (wrapper == null) {
            return null;
        }

        Contact con = new Contact();

        con.FirstName = wrapper.firstName;
        con.LastName = String.isBlank(wrapper.lastName)
            ? 'Unknown'
            : wrapper.lastName;

        con.Email = wrapper.email;
        con.Phone = wrapper.phone;

        con.AccountId = accountId;

        // External ID
        con.ERP_Contact_Id__c = wrapper.contactId;

        return con;
    }

    /**
     * Maps OrderWrapper list to Order__c records
     */
    public static List<Order__c> mapOrders(
        List<CustomerWrapper.OrderWrapper> wrappers,
        Id accountId,
        Id contactId
    ) {

        List<Order__c> orders = new List<Order__c>();

        if (wrappers == null || wrappers.isEmpty()) {
            return orders;
        }

        for (CustomerWrapper.OrderWrapper wrapper : wrappers) {

            Order__c ord = new Order__c();

            ord.ERP_Order_Id__c = wrapper.orderId;
            ord.Amount__c = wrapper.amount;
            ord.Status__c = wrapper.status;
            ord.Order_Date__c = wrapper.orderDate;

            ord.Account__c = accountId;
            ord.Contact__c = contactId;

            orders.add(ord);
        }

        return orders;
    }

}