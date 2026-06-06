trigger StudentTrigger on Student__c (before insert) {

    Set<String> rollNumbers = new Set<String>();

    for(Student__c student : Trigger.new) {
        if(student.Roll_Number__c != null) {
            rollNumbers.add(student.Roll_Number__c);
        }
    }

    Map<String, Student__c> existingStudents = new Map<String, Student__c>();

    for(Student__c s : [
        SELECT Id, Roll_Number__c
        FROM Student__c
        WHERE Roll_Number__c IN :rollNumbers
    ]) {
        existingStudents.put(s.Roll_Number__c, s);
    }

    for(Student__c student : Trigger.new) {

        if(existingStudents.containsKey(student.Roll_Number__c)) {

            student.Roll_Number__c.addError(
                'Duplicate Roll Number is not allowed.'
            );
        }
    }
}