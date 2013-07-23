package com.hp.it.cdc.robin.srm.domain

import org.bson.types.ObjectId

class ResourceApprovalWorkflow {
	ObjectId id
    List<Step> workFlowStep
    Integer stepCount 

    static embedded = ['workFlowStep']
    static constraints = {
    }
}


