trigger ContactTrigger on Contact (
    after insert,
    after update,
    after delete,
    after undelete
) {
    ContactTriggerHandler.updateContactCount(
        Trigger.new,
        Trigger.old,
        Trigger.isInsert,
        Trigger.isUpdate,
        Trigger.isDelete,
        Trigger.isUndelete
    );
}