trigger OpportunityCloseTrigger on Opportunity (after update) {
    
    List<Opportunity_Close__e> closeEvents = new List<Opportunity_Close__e>();
    
    // If this is Closed-Won
    for (Opportunity newOppty : Trigger.new) {
        if (newOppty.StageName == 'Closed Won' && Trigger.old.get(0).StageName != 'Closed Won')
        {
            closeEvents.add(new Opportunity_Close__e(
                Opportunity_Name__c = newOppty.Name,
                Amount__c = newOppty.Amount,
                Opportunity_Id__c = newOppty.Id,
                Stage_Name__c = newOppty.StageName
            ));
            
        }
    }
    
    // Call method to publish events
    List<Database.SaveResult> results = EventBus.publish(closeEvents);
     
    // Inspect publishing result for each event
    for (Database.SaveResult sr : results) {
        if (sr.isSuccess()) {
            System.debug('Successfully published event.');
        } else {
            for(Database.Error err : sr.getErrors()) {
                System.debug('Error returned: ' +
                            err.getStatusCode() +
                            ' - ' +
                            err.getMessage());
            }
        }       
    }
    
}