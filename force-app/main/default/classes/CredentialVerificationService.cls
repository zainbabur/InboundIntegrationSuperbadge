/*
@author: Zain
@description: description: Created for Apex Web Services Superbadge Unit part 3: Confirm Certification Status
*/
global class CredentialVerificationService {

    webservice static String verifyCredential(String lastName, String certName) {

        //check cert status
        Boolean isCertActive = [SELECT IsActive__c 
                                FROM Contact_Certification__c 
                                WHERE Contact__r.LastName = :lastName
                                AND Name = :certName]?.IsActive__c;
        
        if ( isCertActive != null ) {
            //params validated, return Valid if cert is active or Needs Renewal if cert expired
            return isCertActive ? 'Valid' : 'Needs Renewal';

        } else {
            //params invalid
            return 'No record found';

        }

    }

}