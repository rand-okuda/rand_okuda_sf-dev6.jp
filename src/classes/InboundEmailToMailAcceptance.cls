global class InboundEmailToMailAcceptance implements Messaging.InboundEmailHandler {

// このクラスは、メールの件名とメールを送信元の情報を元に、MailAcceptance__cレコードを新規作成します。

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {

        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        
        String mailFrom = email.fromAddress;
        String mailSubject = email.subject;

        List<MailAcceptance__c> mailAccs = new List<MailAcceptance__c>();
        MailAcceptance__c mailAcc = new MailAcceptance__c();

        mailAcc.Source__c = mailFrom;
        mailAcc.Subject__c = mailSubject;

        mailAccs.add(mailAcc);

        insert mailAccs;
        
        result.success = true;
        return result;
    }
    
    // テストメソッド
    public static testmethod void testUnit() {
        InboundEmailToMailAcceptance ctrl = new InboundEmailToMailAcceptance();
        
        
    }

}