@RestResource(urlMapping='/ProductZoning/*')
global class ProductZoningService {
    @HttpGet
    global static String getProductZoningByCountryAndProductCode() {
        String productFamily = '';
        String flyZone = '';
        
        RestRequest req = RestContext.request;
        String countryCode = req.headers.get('CountryCode') ?? 'US';
        String productCode = req.params.get('ProductCode');
        
        if (String.isNotBlank(countryCode) && String.isNotBlank(productCode)) {
            productFamily = [SELECT Id, Family 
                            FROM Product2
                            WHERE ProductCode = :productCode]?.Family;
        }

        if ( String.isNotBlank(productFamily) ) {

            flyZone = [SELECT Permissible_Fly_Zone__c 
                        FROM Product_Geo_Mapping__mdt
                        WHERE Country_Code__c = :countryCode 
                        AND Product_Family__c = :productFamily]?.Permissible_Fly_Zone__c;

        }
        
        flyZone = String.isNotBlank(flyZone) ? flyZone : 'ProductCode is missing or doesn\'t exist'; 

        return flyZone;
    }
}