package com.hp.it.cdc.robin.srm.domain

import org.bson.types.ObjectId

class Notification {

	ObjectId id
	String from
	String to
	String cc
	String bcc
	String body
	String subject
	Date sentTs

	Map<Date, Exception> exception
	Integer retryCount = Integer.valueOf(0)
	
	Date dateCreated
    Date lastUpdated
	
    static constraints = {
		to nullable:true
		cc nullable:true
		bcc nullable:true
		sentTs nullable:true
    }
}
