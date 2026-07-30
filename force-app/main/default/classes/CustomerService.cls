public with sharing class CustomerService {

    /**
     * Main entry point
     */
    public static ApiResponse process(CustomerWrapper wrapper) {

        ApiResponse response = new ApiResponse();

        try {

            validate(wrapper);

            /*
             * -------------------------
             * Account
             * -------------------------
             */

            Account account =
                CustomerMapper.mapAccount(wrapper.account);

            upsert account ERP_Account_Id__c;

            /*
             * -------------------------
             * Contact
             * -------------------------
             */

            Contact contact =
                CustomerMapper.mapContact(
                    wrapper.contact,
                    account.Id
                );

            upsert contact ERP_Contact_Id__c;

            /*
             * -------------------------
             * Orders
             * -------------------------
             */

            List<Order__c> orders =
                CustomerMapper.mapOrders(
                    wrapper.orders,
                    account.Id,
                    contact.Id
                );

            if(!orders.isEmpty()){

                Database.UpsertResult[] results =
                    Database.upsert(
                        orders,
                        Order__c.Fields.ERP_Order_Id__c,
                        false
                    );

            }

            response.success = true;
            response.message = 'Data processed successfully';
            response.accountId = account.Id;
            response.contactId = contact.Id;
            response.orderCount = orders.size();

            return response;

        }
        catch(Exception ex){

            response.success = false;
            response.message = ex.getMessage();

            throw ex;

        }

    }

    /**
     * Validation
     */
    private static void validate(CustomerWrapper wrapper){

        if(wrapper == null){

            throw new CustomerServiceException(
                'Request body is empty.'
            );

        }

        if(wrapper.account == null){

            throw new CustomerServiceException(
                'Account section missing.'
            );

        }

        if(String.isBlank(wrapper.account.accountId)){

            throw new CustomerServiceException(
                'Account External Id is mandatory.'
            );

        }

        if(String.isBlank(wrapper.account.name)){

            throw new CustomerServiceException(
                'Account Name is mandatory.'
            );

        }

        if(wrapper.contact == null){

            throw new CustomerServiceException(
                'Contact section missing.'
            );

        }

        if(String.isBlank(wrapper.contact.contactId)){

            throw new CustomerServiceException(
                'Contact External Id is mandatory.'
            );

        }

        if(String.isBlank(wrapper.contact.lastName)){

            throw new CustomerServiceException(
                'Contact LastName is mandatory.'
            );

        }

    }

    /**
     * Custom Exception
     */
    public class CustomerServiceException extends Exception{}

}