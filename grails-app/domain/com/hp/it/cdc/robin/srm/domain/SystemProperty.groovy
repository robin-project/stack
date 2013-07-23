package com.hp.it.cdc.robin.srm.domain

import org.bson.types.ObjectId

class SystemProperty {
	ObjectId id
	String identifier
	String logoImageUrl
	String faviconUrl
	ResourceApprovalWorkflow resourceApprovalWorkflow
	String treelevelTopUserBusinessInfo1
	String systemAdminUserBusinessInfo1
	Integer userStaleDays
	String emailFrom
	Integer eachResourcePageCount
    
    static embedded=['resourceApprovalWorkflow']
    static constraints = {
    	identifier nullable:false, unique:true
    }
}
