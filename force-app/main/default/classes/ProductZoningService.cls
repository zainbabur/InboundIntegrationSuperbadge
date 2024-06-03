/*
@author: Zain
@description: Created for Apex Web Services Superbadge Unit part 1: Find the Permissible Fly Zone
*/

@RestResource(urlMapping='/ProductZoning/*')
global class ProductZoningService {
    @HttpGet
    global static String getProductZoningByCountryAndProductCode() {

        //set error messages for different scenarios
        Final String PRODUCT_CODE_MISSING_MESSAGE = 'ProductCode is missing or doesn\'t exist';
        Final String PRODUCT_CODE_NOT_MAPPED_MESSAGE = 'Confirm with the local authorities';


        String productFamily = '';
        String flyZone = '';
        
        RestRequest req = RestContext.request;

        //get country code from header and product code from URL
        String countryCode = req.headers.get('CountryCode') ?? 'US';
        String productCode = req.params.get('ProductCode');
        
        if (String.isNotBlank(countryCode) && String.isNotBlank(productCode)) {

            //get product family if it exists
            productFamily = [SELECT Id, Family 
                            FROM Product2
                            WHERE ProductCode = :productCode]?.Family;
        }

        if ( String.isNotBlank(productFamily) ) {

            //get permissible fly zone if it exists
            flyZone = [SELECT Permissible_Fly_Zone__c 
                        FROM Product_Geo_Mapping__mdt
                        WHERE Country_Code__c = :countryCode 
                        AND Product_Family__c = :productFamily]?.Permissible_Fly_Zone__c;

            //return permissible fly zone if it exists, otherwise return error message
            return String.isNotBlank(flyZone) ? flyZone : PRODUCT_CODE_NOT_MAPPED_MESSAGE;

        } else {

            //product code missing so return error message
            return PRODUCT_CODE_MISSING_MESSAGE;

        }
        
    }
}