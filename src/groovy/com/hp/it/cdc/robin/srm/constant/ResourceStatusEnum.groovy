package com.hp.it.cdc.robin.srm.constant

enum ResourceStatusEnum {
	NORMAL("label.resource.status.normal", "Normal"),
    ALLOCATED("label.resource.status.allocated", "Allocated"), 
	RETIRED("label.resource.status.retired", "Retired"), 
	BROKEN("label.resource.status.broken", "Broken"),  
	LOST("label.resource.status.lost", "Lost"), 
	RETURNED_ITIO("label.resource.status.returned", "Returned-ITIO"),
	TRANSFERRED("label.resource.status.transferred", "Transferred"),
	IN_QUESTION("label.resource.status.in_question","In-Question")


    ResourceStatusEnum(String labelCode, String description){
        this.labelCode=labelCode
		this.description = description
    }

    String labelCode
	String description
}