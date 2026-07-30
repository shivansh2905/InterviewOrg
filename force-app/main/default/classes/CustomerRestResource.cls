@RestResource(urlMapping='/customer/*')
global with sharing class CustomerRestResource {

    @HttpPost
    global static void processCustomer() {

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String requestBody = req.requestBody.toString();

        ApiResponse response;
        Exception loggedException;

        try {

            // Deserialize JSON
            CustomerWrapper wrapper =
                (CustomerWrapper)JSON.deserialize(
                    requestBody,
                    CustomerWrapper.class
                );

            // Process Request
            response = CustomerService.process(wrapper);

            // HTTP 200
            res.statusCode = 200;

        }
        catch(CustomerService.CustomerServiceException ex){
            loggedException = ex;
            response = new ApiResponse();

            response.success = false;
            response.message = ex.getMessage();

            res.statusCode = 400;

        }
        catch(Exception ex){

            response = new ApiResponse();

            response.success = false;
            response.message = 'Internal Server Error';

            res.statusCode = 500;

        }

        // Response JSON
        String responseBody =
            JSON.serializePretty(response);

        res.addHeader(
            'Content-Type',
            'application/json'
        );

        res.responseBody =
            Blob.valueOf(responseBody);

        // Log API Transaction
        IntegrationLogger.log(
            requestBody,
            responseBody,
            String.valueOf(res.statusCode),
            loggedException
        );

    }

}