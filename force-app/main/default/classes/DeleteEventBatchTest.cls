@isTest
public class DeleteEventBatchTest {

    @testSetup
    public static void testSetupData(){
        Event_Organizer__c  org = new Event_Organizer__c (
            Name = 'DaraSaheb Singh',
            Phone__c = '1234567890',
            Email__c = 'Dara@gmail.com.dev1',
            Alternative_Phone__c  = '1234567890',
            Alternative_Email__c ='Dara@gmail.com.dev1'
        );
        insert org;
        List<Event__c> eventList = new List<Event__c>();
        for(Integer i=0; i<=200; i++){
            Event__c event = new Event__c(
                Name__c = 'MAX FIT Campaign #'+i+1,
                Event_Organizer__c  = org.Id,
                Event_Type__c = 'Virtual',
                Frequency__c  = 'Weekly',
                Max_Seats__c  = 199,
                Recurring__c = true,
                Live__c = true,
                Start_DateTime__c = System.now().addMonths(-4),
                End_Date_Time__c  = System.now().addDays(3).addMonths(-4)
            );
            eventList.add(event);
        }
        insert eventList;
    }
    
    @isTest
    static void sendDeletEventTest(){
        Test.startTest();

        String jobId = Database.executeBatch(new DeleteEventBatch(), 250);
        
        Test.stopTest();
        
    }
}