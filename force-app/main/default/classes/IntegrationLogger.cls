public with sharing class IntegrationLogger {

    public static void log(
        String requestBody,
        String responseBody,
        String statusCode,
        Exception ex
    ){

        try{

            Integration_Log__c log =
                new Integration_Log__c();

            log.Request__c = requestBody;
            log.Response__c = responseBody;
            log.Status_Code__c = statusCode;
            log.Request_Time__c = System.now();

            log.Status__c =
                statusCode == '200'
                ? 'SUCCESS'
                : 'FAILED';

            if(ex != null){

                log.Error_Message__c =
                    ex.getMessage();

            }

            insert log;

        }
        catch(Exception ignore){

            System.debug(ignore);

        }

    }

}