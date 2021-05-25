trigger update_account_after_approval on Data_Approval_Request__c ( after update) {
    list<data_approval_request__c> newDAR = trigger.new;
    list<data_approval_request__c> oldDAR = trigger.old;
    map<id, data_approval_request__c> oldmapdar = Trigger.oldMap;
    if(Trigger.isafter){
        for(data_approval_request__c loopdar : newDAR){
            string DARId = loopdar.id;
            system.debug('id of DAR ' + DARId);
            string AccId = loopdar.account__c;
            system.debug('ID of Acc '+ AccId);
            if(loopdar.Status__c =='approved')
                {
                    list<Data_Approval_Request_Fields__c> DARF = [select name,id,Status__c, Approved_Value__c,Current_Value__c, Requested_Value__c,  Field_API__c from Data_Approval_Request_Fields__c where Data_Approval_Request__c =:DARId];
                    for(Data_Approval_Request_Fields__c loopdarf : DARF)
                        {   
                            account acc = new account ();
                            acc.id = AccId ;
                            acc.Don_t_create_DAR__c = True;
                            if(loopdarf.Status__c!='Rejected'){
                               if(loopdarf.Approved_Value__c!=Null){     
                                    system.debug('req value of DARf ' + loopdarf.Requested_Value__c);
                                    system.debug('crr value of CRRF ' + loopdarf.Current_Value__c);
                                    acc.put(loopdarf.Field_API__c, loopdarf.Approved_Value__c);
                                    system.debug('assign approveal value '+ loopdarf.Approved_Value__c);
                                    loopdarf.Status__c='Approved';
                                }
                                else{
                                     acc.put(loopdarf.Field_API__c, loopdarf.Requested_Value__c);
                                     system.debug('assign requested value '+ loopdarf.Requested_Value__c);
                                     loopdarf.Status__c='Approved';
                                }
                           
                           }  
                    
                        update acc; 
                        system.debug('update loopdarf '+ loopdarf);
                        update loopdarf;
                        }
              }
         }
    }
}