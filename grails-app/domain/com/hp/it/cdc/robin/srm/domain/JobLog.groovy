package com.hp.it.cdc.robin.srm.domain

import org.bson.types.ObjectId

class JobLog {
	ObjectId id
	String jobName
	Date dateCreated
    static constraints = {
    }
}
