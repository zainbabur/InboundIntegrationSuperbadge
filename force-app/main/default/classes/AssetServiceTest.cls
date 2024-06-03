@isTest
private class AssetServiceTest {

    @TestSetup
    static void makeData(){

        //create account
        Account account = new Account(Name = 'Test Account', BillingCountry = 'Germany');
        insert account;

        //create assets
        Asset asset1 = new Asset(Name = 'Test Asset 1', Status = 'Purchased', Asset_Identifier__c = 'TST-1', AccountId = account.Id);
        insert asset1;

        Asset asset2 = new Asset(Name = 'Test Asset 2', Status = 'Purchased', Asset_Identifier__c = 'TST-2', AccountId = account.Id);
        insert asset2;

        Asset asset3 = new Asset(Name = 'Test Asset 3', Status = 'Purchased', Asset_Identifier__c = 'TST-3', AccountId = account.Id);
        insert asset3;

        //create insurance

        Insurance__c insurance1 = new Insurance__c(Coverage__c = 'Comprehensive', Active__c = true, Asset__c = asset1.Id);
        insert insurance1;
        Insurance__c insurance2 = new Insurance__c(Coverage__c = 'Comprehensive', Active__c = true, Asset__c = asset2.Id);
        insert insurance2;

        //create claim
        Claim__c claim = new Claim__c(Type__c = 'Loss', Status__c = 'New', Insurance__c = insurance2.Id, Asset__c = asset2.Id);
        insert claim;
        
    }

    @isTest
    private static void testReportLostDeviceInvalidIdentifier() {
            
        Test.startTest();
        //test reporting lost device with invalid asset identifier
        String result = AssetService.reportLostDevice('');
        Test.stopTest();

        //verify result
        System.assertEquals('No device found.', result, 'Invalid asset identifier should return "No device found."');


    }

    @isTest
    private static void testReportLostDeviceValidIdentifierNoInsurance() {
            
        Test.startTest();
        //test reporting lost device with invalid asset identifier
        String result = AssetService.reportLostDevice('TST-3');
        Test.stopTest();

        //verify result
        System.assertEquals('No coverage. Asset status adjusted to Lost.', result, 'Valid Identifier with no coverage should return "No coverage. Asset status adjusted to Lost."');


    }

    @isTest
    private static void testReportLostDeviceValidIdentifierWithExistingClaim() {
            
        Test.startTest();
        //test reporting lost device with invalid asset identifier
        String result = AssetService.reportLostDevice('TST-2');
        Test.stopTest();

        //verify result
        Assert.isTrue(result.contains('already filed.'), 'Valid Identifier with existing claim should return "<Claim Name> already filed."');


    }

    @isTest
    private static void testReportLostDeviceValidIdentifierWithInsurance() {
            
        Test.startTest();
        //test reporting lost device with invalid asset identifier
        String result = AssetService.reportLostDevice('TST-1');
        Test.stopTest();

        //verify result
        System.assertEquals([SELECT Name FROM Claim__c WHERE Asset__r.Asset_Identifier__c = 'TST-1']?.Name, result, 'Valid Identifier with insurance should return Claim Name');


    }

}