package com.hp.it.cdc.robin.srm.domain

import com.hp.it.cdc.robin.srm.constant.ResourceStatusEnum
import com.hp.it.cdc.robin.srm.constant.PurposeEnum
import java.util.Date;
import org.bson.types.ObjectId

class Resource {
	ObjectId id
    Purchase purchase
    String serial
    ResourceStatusEnum status
    PurposeEnum purpose
    User currentUser
    User assistUser
    List<Issue> issues = new ArrayList<Issue>()
    List<ResourceLog> resourceLogs = new ArrayList<ResourceLog>()
	Date dateCreated
	Date lastUpdated
	
	String displayedModel
	String displayedProductNr
	Date displayedArriveDate

	static mapping = {
		sort dateCreated: "desc"
	}
	
    static constraints = {
		purchase nullable:false
		status nullable:false
		serial nullable: false
		purpose nullable: true
		currentUser nullable: true
		assistUser nullable: true
		displayedProductNr nullable: true
    }
	
	static embedded = [
		'resourceLogs'
	]
	
	String getPrintableId(){
		return purchase.resourceType.resourceTypeName + "-" + id.toString().substring(20,24)
	}
	
	String toString(){
		return this.purchase.resourceType.toString() + this.serial
	}
	
}

class ResourceLog {
	ResourceStatusEnum status
	Date dateCreated=new Date()
	Request relatedRequest
	User assignedUser
	User operateUser
	String logdetail
	
	static constraints = {
		status(nullable: false)
		relatedRequest(nullable: true)
		assignedUser(nullable: true)
		operateUser(nullable:true)
		logdetail(nullable:false)
	}
}

