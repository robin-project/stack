package com.hp.it.cdc.robin.srm.domain

import com.hp.it.cdc.robin.srm.constant.IssueTypeEnum
import org.bson.types.ObjectId
class Issue {
	ObjectId id
	IssueTypeEnum issueType
	String detail
	Date dateCreated
	
    static constraints = {
    }
}
