trigger data_approval_process_update_fields on Account (before update, after update) {
    list<Account> newtm = trigger.new;
    list<Account> oldtm = trigger.old;
    if(Trigger.isBefore){
        string newstatus = newtm[0].Status_PMT__c;
        string oldstatus = oldtm [0].Status_PMT__c;
        string id = oldtm[0].id;
        string newdes = newtm[0].Description;
        system.debug('new status of account: '+  newstatus);
        system.debug('old status of account: '+  oldstatus );
        system.debug(' new Phone of account: '+  newtm[0].Phone );
        system.debug('old Phone of account: '+  oldtm [0].Phone);
       // system.debug('old id of account: '+ id);
        system.debug(' new description of account: '+  newdes);
        if(newtm[0].Don_t_create_DAR__c!=True){
            if((newtm[0].Status_PMT__c!=oldtm [0].Status_PMT__c) && (newtm[0].Phone !=oldtm [0].Phone)) {
                Data_Approval_Request__c DAR = new Data_Approval_Request__c();
                DAR.Status__c = 'new';
                DAR.Request_Typw__c= 'Edit';
                DAR.Team__c= oldtm[0].id;
              //system.debug(DAR);
                insert DAR;
                system.debug('inserted DAR record: '+  DAR);
                list<Data_Approval_Request_Fields__c> ListofDARF = new list<Data_Approval_Request_Fields__c> ();
                Data_Approval_Request_Fields__c DARF = new Data_Approval_Request_Fields__c ();
                Data_Approval_Request_Fields__c DARF1 = new Data_Approval_Request_Fields__c ();
                DARF.Field_Name__c = 'Status';
                DARF.Requested_Value__c = newtm[0].Status_PMT__c;
                DARF.Current_Value__c =  oldtm[0].Status_PMT__c;
                DARF.Status__c='new';
                DARF.Field_API__c = 'Status__c';
                DARF.Data_Approval_Request__c=DAR.id;
                ListofDARF.add(DARF);
                DARF1.Field_Name__c = 'Phone ';
                DARF1.Requested_Value__c = newtm[0].Phone ;
                DARF1.Current_Value__c =  oldtm[0].Phone ;
                DARF1.Status__c='new';
                DARF1.Field_API__c ='Phone';
                DARF1.Data_Approval_Request__c=DAR.id;
                ListofDARF.add(DARF1);
                insert ListofDARF ;
                system.debug('insert DARF record: '+  ListofDARF);
                
           } 
           else if((newtm[0].Status_PMT__c!=oldtm [0].Status_PMT__c)){
               Data_Approval_Request__c DAR1 = new Data_Approval_Request__c();
                DAR1.Status__c = 'new';
                DAR1.Request_Typw__c= 'Edit';
                DAR1.Team__c= oldtm[0].id;
                insert DAR1;
                system.debug('inserted DAR1 record: '+  DAR1);
                Data_Approval_Request_Fields__c CrtDARF = new Data_Approval_Request_Fields__c ();
                CrtDARF.Field_Name__c = 'Status';
                CrtDARF.Field_API__c = 'Status__c';
                CrtDARF.Requested_Value__c = newtm[0].Status_PMT__c;
                CrtDARF.Current_Value__c =  oldtm[0].Status_PMT__c;
                CrtDARF.Status__c= 'new';
                CrtDARF.Data_Approval_Request__c= DAR1.id;
                insert CrtDARF ;
                system.debug('insert CrtDARF record: '+  CrtDARF );
            }
           
            if(newtm[0].Status_PMT__c !=  oldtm[0].Status_PMT__c){
                newtm[0].Status_PMT__c =  oldtm [0].Status_PMT__c;
                system.debug('assign old value of status to new status: '+  newtm[0].Status_PMT__c );
            }
            if(newtm[0].Phone!=  oldtm[0].Phone){
                newtm[0].Phone=  oldtm[0].Phone;
                system.debug('assign old value of status to new status: '+  newtm[0].Phone );
            }
        }
        else
        {
            newtm[0].Don_t_create_DAR__c=false;
        }
    }
}