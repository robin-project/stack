package com.hp.it.cdc.robin.srm.constant

enum RequestTypeEnum {
    APPLY("label.request.type.apply"),
    TRANSFER("label.request.status.transfer")

    RequestTypeEnum(String labelCode){
        this.labelCode=labelCode
    }

    String labelCode
}