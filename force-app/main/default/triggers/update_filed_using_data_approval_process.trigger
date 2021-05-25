trigger update_filed_using_data_approval_process on Account (before update) {
list<account> newacc = trigger.new;
list<account> oldacc = trigger.old;
    if(trigger.isbefore){
       list<Data_Approval_Process_Setting__mdt> listOfFields=[select id, Country_Name__c, DeveloperName, Field_API__c, Field_Name__c, Object_API_Name__c   from Data_Approval_Process_Setting__mdt];
       Data_Approval_Request__c  DAR = new Data_Approval_Request__c ();
         if(newacc[0].Don_t_create_DAR__c!=True){
            for (Data_Approval_Process_Setting__mdt FieldLoop: listOfFields){
                    system.debug(String.valueof(oldacc[0].get(FieldLoop.Field_API__c)));
                    string a = String.valueof(oldacc[0].get(FieldLoop.Field_API__c));
                    string b = String.valueof(newacc[0].get(FieldLoop.Field_API__c ));    
                    if(a!=b){
                        if(DAR.id==null){
                           DAR.Status__c = 'new';
                            DAR.Request_Typw__c= 'Edit';
                            DAR.account__c= oldacc[0].id;
                            insert DAR;
                            system.debug('insert new DAR ' + DAR);
                        }
                        Data_Approval_Request_Fields__c DARF1 = new Data_Approval_Request_Fields__c();
                        DARF1.Field_API__c = FieldLoop.Field_API__c;
                        DARF1.Requested_Value__c = b;
                        DARF1.Current_Value__c = a;
                        DARF1.Field_Name__c= FieldLoop.Field_Name__c;
                        DARF1.Data_Approval_Request__c = DAR.id; 
                        insert DARF1;
                        system.debug('insert new DARF ' + DARF1);
                  }
                  newacc[0].put(FieldLoop.Field_API__c, a);
             }
        }
        else{
              newacc[0].Don_t_create_DAR__c=false;
          
            }
    }
}