trigger ConstructionUpdateAtMail on MailAcceptance__c (before insert, before update) {

//このトリガーは、MailAcceptance__cのレコードに基き、Construction__cを更新します。
//同時に、メール送信元アドレスとメール件名から、関連付けを行います。
//関連付け時には、メール送信元アドレスが登録済み情報と一致しているかを確認し、不正があればエラーとします。

    for(MailAcceptance__c newMa : Trigger.new){

        Integer cntMe = [SELECT COUNT() FROM Member__c WHERE MailAddress__c = :newMa.Source__c]; 

        if (cntMe == 1){

            for(Member__c me : [SELECT Id, Name, MailAddress__c FROM Member__c WHERE MailAddress__c = :newMa.Source__c LIMIT 1]){

                newMa.Member__c = me.Id ;

            }

        }else{

            newMa.addError('未登録のメール送信元< '+newMa.Source__c+' >');

        }

        if(newMa.Subject__c == null){

            newMa.addError('空白のメール件名は禁止');

        }else{

            String newMaSubject;
            String newMTJN;
            String newMTJS;

            newMaSubject = newMa.Subject__c;
            String[] TJNJS = newMaSubject.split(' ',0);

            newMTJN = TJNJS[0];
            newMTJS = TJNJS[1];

            newMa.TargetJobNumber__c = newMTJN;
            newMa.TargetJobStatus__c = newMTJS;

            Integer cntCons = [SELECT COUNT() FROM Construction__c WHERE Member__r.MailAddress__c = :newMa.Source__c AND ProjectsNumber__c = :newMTJN];

            if(cntCons == 1){

                for(Construction__c cons :[SELECT Id, Name, TargetJobStatus__c FROM Construction__c WHERE ProjectsNumber__c = :newMTJN LIMIT 1]){

                    newMa.Construction__c = cons.Id;

                    cons.TargetJobStatus__c = newMTJS;
                    update cons;

                }

            }else{

                newMa.addError('メール送信元< '+newMa.Source__c+' >と対象工事番号< '+newMTJN+' >の組合せが不正');

            }

        }

    }

}