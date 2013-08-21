package com.hp.it.cdc.robin.srm.constant

enum RequestStatusEnum {
    NEW("label.request.status.new"),
    WAITING_APPROVED("label.request.status.waitingApproved"),
    WAITING_ALLOCATED("label.request.status.waitingAllocated"),
	PARTIAL("label.request.status.partial"),
	CLOSED("label.request.status.closed"),
	REJECTED("label.request.status.rejected")

    RequestStatusEnum(String labelCode){
		this.labelCode =labelCode
    }

    String labelCode
}