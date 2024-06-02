@isTest
private class ProductZoningServiceTest {

    @TestSetup
    static void insertData() {


        Product2 testProduct = new Product2(
                    Name = 'Test',
                    ProductCode = 'TST',
                    Family = 'Fixed-Wing',
                    IsActive = true
                );

        insert testProduct;
        
    }

    @isTest
    static void testGetProductZoningByCountryAndProductCode() {
        
        System.runAs(new User(Id = UserInfo.getUserId())) {
            Test.startTest();
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/productzoning/';
            req.httpMethod = 'GET';
            req.addHeader('Accept', 'application/json'); 
            req.addHeader('Content-Type', 'application/json');
            req.addHeader('CountryCode', 'AU'); 
            req.params.put('ProductCode', 'TST');
            RestContext.request = req;
            RestContext.response = res;

            String flyZone = ProductZoningService.getProductZoningByCountryAndProductCode();

            Test.stopTest();

            System.assertEquals('Authorized', flyZone, 'Expected Authorized for valid ProductCode');
        }
    }

    @isTest
    static void testGetProductZoningByCountryAndMissingProductCode() {
        
        System.runAs(new User(Id = UserInfo.getUserId())) {
            Test.startTest();
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/productzoning/';
            req.httpMethod = 'GET';
            req.addHeader('Accept', 'application/json'); 
            req.addHeader('Content-Type', 'application/json'); 
            req.addHeader('CountryCode', 'AU');
            req.params.put('ProductCode', '');
            RestContext.request = req;
            RestContext.response = res;

            String flyZone = ProductZoningService.getProductZoningByCountryAndProductCode();

            Test.stopTest();

            System.assertEquals('ProductCode is missing or doesn\'t exist', flyZone, 'Expected Error in response');
        }
    }
}