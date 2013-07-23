package com.hp.it.cdc.robin.srm.constant

enum ActivityTypeEnum {
    APPLY("label.activity.type.apply"),
    TRANSOUT("label.activity.type.transout"),
    APPROVED("label.activity.type.approved"),
    DECLINED("label.activity.type.declined"),
    ALLOCATED("label.activity.type.allocated"),
	CLOSED("label.activity.type.closed")

    ActivityTypeEnum(String labelCode){
        this.labelCode=labelCode
    }
    String labelCode
}
