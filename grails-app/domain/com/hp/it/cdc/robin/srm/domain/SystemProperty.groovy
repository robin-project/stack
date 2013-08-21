package com.hp.it.cdc.robin.srm.domain

import org.bson.types.ObjectId

class SystemProperty {
	ObjectId id
	List<ResourceApprovalWorkflow> resourceApprovalWorkflow
	String treelevelTopUserBusinessInfo1
	Integer userStaleDays
	String emailFrom
	Integer eachResourcePageCount
    String userGuideUrl
    Boolean productionMode
    
    static embedded=['resourceApprovalWorkflow']
    static constraints = {
    	productionMode nullable:true
    }
}
