/*
@author: Zain
@description: Created for Apex Web Services Superbadge Unit part 2: Report a Lost Device
*/
@RestResource(urlMapping='/lost')
global class AssetService {

    @HttpPost
    global static String reportLostDevice(String assetIdentifier) {

        //initialize error messages
        Final String ERROR_MESSAGE_CLAIM_EXISTS = '{0} already filed.';
        Final String ERROR_MESSAGE_INVALID_IDENTIFIER = 'No device found.';
        Final String ERROR_MESSAGE_NO_COVERAGE = 'No coverage. Asset status adjusted to Lost.';


        if ( String.isNotBlank(assetIdentifier) ) {

            List<Asset> asset = [SELECT Id, Status 
                                FROM Asset 
                                WHERE Asset_Identifier__c = :assetIdentifier];
            
            //check if asset exists
            if ( asset.size() > 0 ) {

                List<Insurance__c> insurance = [SELECT Id, Coverage__c, Active__c
                                                FROM Insurance__c
                                                WHERE Coverage__c = 'Comprehensive'
                                                AND Active__c = True
                                                AND Asset__r.Id = :asset[0].Id];
                
                //does the asset have active, comprehensive coverage?
                if ( insurance.size() > 0 ) {

                    List<Claim__c> claim = [SELECT Id, Name
                                            FROM Claim__c
                                            WHERE Asset__r.Asset_Identifier__c = :assetIdentifier
                                            AND Insurance__r.Id = :insurance[0].Id];
                    
                    //does a claim already exist?
                    if ( claim.size() > 0 ) {

                        return String.format(ERROR_MESSAGE_CLAIM_EXISTS, new List<String>{claim[0].Name});

                    } else { //given that asset exists with valid insurance and no existing claim

                        asset[0].Status = 'Lost';
                        update asset[0];

                        Claim__c newClaim = new Claim__c (
                            Type__c = 'Loss',
                            Asset__c = asset[0].Id,
                            Insurance__c = insurance[0].Id
                        );

                        insert newClaim;

                        return [SELECT Id, Name 
                                FROM Claim__c
                                WHERE Id = :newClaim.Id]?.Name;

                    }

                } else { //given that asset does not have an insurance that covers loss

                    asset[0].Status = 'Lost';
                    update asset[0];
                    return ERROR_MESSAGE_NO_COVERAGE;

                }


            } else { //given that asset identifier provided does not exist in the system

                return ERROR_MESSAGE_INVALID_IDENTIFIER;

            }

        } else { //given that no asset identifier was provided in request

            return ERROR_MESSAGE_INVALID_IDENTIFIER;

        }

    }


}