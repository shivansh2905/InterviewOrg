public class CustomerWrapper {

    public AccountWrapper account;
    public ContactWrapper contact;
    public List<OrderWrapper> orders;

    /**
     * Account JSON
     */
    public class AccountWrapper {

        public String accountId;
        public String name;
        public String industry;

    }

    /**
     * Contact JSON
     */
    public class ContactWrapper {

        public String contactId;
        public String firstName;
        public String lastName;
        public String email;
        public String phone;

    }

    /**
     * Order JSON
     */
    public class OrderWrapper {

        public String orderId;
        public Decimal amount;
        public String status;
        public Date orderDate;

    }

}