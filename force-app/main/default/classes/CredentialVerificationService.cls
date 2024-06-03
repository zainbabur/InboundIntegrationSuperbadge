global class CredentialVerificationService {

    webservice static String verifyCredential(String lastName, String certName) {

        Boolean isCertActive = [SELECT IsActive__c 
                                FROM Contact_Certification__c 
                                WHERE Contact__r.LastName = :lastName
                                AND Name = :certName]?.IsActive__c;
        
        if ( isCertActive != null ) {

            return isCertActive ? 'Valid' : 'Needs Renewal';

        } else {

            return 'No record found';

        }

    }

}