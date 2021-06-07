trigger EventSpeakerTrigger on EventSpeakers__c (before insert,before update) {

    Set<Id> speakerIdsSet=new Set<Id>();
    Set<Id> eventIdsSet=new Set<Id>();

    for( EventSpeakers__c es : Trigger.New ){
            speakerIdsSet.add(es.Speaker__c);
            eventIdsSet.add(es.Event__c);
    }

    Map<Id,Datetime> requestedEvents=new Map<Id,Datetime>();
    List<Event__c> relatedEventList=[ select Id,Name,Start_DateTime__c FROM Event__c WHERE Id IN : eventIdsSet];
    for(Event__c evt:relatedEventList){
        requestedEvents.put(evt.Id,evt.Start_DateTime__c);
    }
    List<EventSpeakers__c> relatedEventSpeakerList=[ Select Id,Event__c ,Speaker__c,
                                        Event__r.Start_DateTime__c
                                        FROM EventSpeakers__c 
                                        WHERE Speaker__c IN : speakerIdsSet];

    for(EventSpeakers__c es : Trigger.New){
        DateTime bookingTime=requestedEvents.get(es.Event__c);

        for(EventSpeakers__c es1 : relatedEventSpeakerList){

            if(es1.Speaker__c == es.Speaker__c && es1.Event__r.Start_DateTime__c == bookingTime){
                es.Speaker__c.addError('The speaker is already booked at that time');
                es.addError('The speaker is already booked at that time');
            }
        }
    }
}