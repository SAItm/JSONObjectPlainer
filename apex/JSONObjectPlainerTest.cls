@IsTest
class JSONObjectPlainerTest {
    @TestSetup
    static void setup(){
        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;
        
        Opportunity opp = new Opportunity(
            Name='Test Opp', 
            StageName='Open', 
            Type = 'Direct', 
            CloseDate = Date.Today() + 30, 
            Required_Ship_Date__c = Date.today() + 20
        );
        insert opp;
        Quote q = new Quote(
            OpportunityId = opp.Id, 
            Name = 'Test Quote'
        );
        q.Pricebook2Id = standardPricebook.Id;

        Quote q2 = new Quote(
            OpportunityId = opp.Id, 
            Name = 'Test Quote 2'
        );
        q.Pricebook2Id = standardPricebook.Id;
        insert new List<Quote> {q, q2};
    }
    testmethod static void plain() {
        List<Quote> qts = [SELECT Opportunity.Name FROM Quote];
        String oppName = qts[0].Opportunity.Name;
        Map<String, Object> result = (Map<String,Object>) JSONObjectPlainer.plain(qts[0]);
        System.assertEquals(result.get('Opportunity.Name'), oppName);
        List<Object> results = JSONObjectPlainer.plain(qts);
        for (Object obj: results) {
            Map<String,Object> pair = (Map<String,Object>) obj;
            System.assertEquals(pair.get('Opportunity.Name'), oppName);
        }
    }
}