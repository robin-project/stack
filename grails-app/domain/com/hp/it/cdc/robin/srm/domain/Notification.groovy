package com.hp.it.cdc.robin.srm.domain

import org.bson.types.ObjectId

class Notification {

	ObjectId id
	String from
	String to
	String cc
	String body
	String subject
	Date sentTs
	
	Date dateCreated
    Date lastUpdated
	
    static constraints = {
		to nullable:true
		cc nullable:true
		sentTs nullable:true
    }
}
