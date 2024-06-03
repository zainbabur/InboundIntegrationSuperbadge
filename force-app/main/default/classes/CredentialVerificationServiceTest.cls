@isTest
private class CredentialVerificationServiceTest {

    @TestSetup
    static void makeData(){
        //insert contact
        Contact testContact = new Contact(
            LastName = 'TST'
        );
        insert testContact;

        //insert certification
        Certification__c testCert = new Certification__c(
            Name = 'TST',
            IsActive__c = true
        );
        insert testCert;

        //insert Contact certification
        Contact_Certification__c testContactCert = new Contact_Certification__c(
            IsActive__c = true,
            Contact__c = testContact.Id,
            Certification__c = testCert.Id,
            Issue_Date__c = Date.today()
        );
        insert testContactCert;
        
    }

    @isTest
    static void testVerifyCredential() {
        Contact existingContact = [SELECT Id, LastName FROM Contact WITH USER_MODE LIMIT 1];
        Contact_Certification__c existingCert = [SELECT Id, Name, IsActive__c 
                                                FROM Contact_Certification__c 
                                                WHERE Contact__c = :existingContact.Id];
        
        String result;
        
        Test.startTest();
        System.runAs(new User(Id = UserInfo.getUserId())) {
            result = CredentialVerificationService.verifyCredential(existingContact.LastName, existingCert.Name);
        }
        Test.stopTest();
        
        System.assertEquals('Valid', result, 'Expected "Valid" result');
    }

    @isTest
    static void testVerifyCredentialInvalidParams() {

        String result;
        Test.startTest();
        System.runAs(new User(Id = UserInfo.getUserId())) {
            result = CredentialVerificationService.verifyCredential('TST1', 'TST1');
        }
        Test.stopTest();
        
        System.assertEquals('No record found', result, 'Expected "No record found" result');
        
    }
}