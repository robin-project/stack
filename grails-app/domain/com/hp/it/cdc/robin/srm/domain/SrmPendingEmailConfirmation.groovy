package com.hp.it.cdc.robin.srm.domain

import java.util.Date;
import org.bson.types.ObjectId

class SrmPendingEmailConfirmation {
	ObjectId id
	transient springSecurityService
	
	String emailAddress
	String confirmationToken = "?"
	String userToken
	String confirmationEvent
	String pendingPassword
	
	Date timestamp = new Date()

	static mapping = {
		confirmationToken index:'emailconf_token_Idx'
		timestamp index:'emailconf_timestamp_Idx'
	}
	
	static constraints = {
		emailAddress(size:1..80, email:true)
		confirmationToken(unique:true,size:1..80)
		confirmationEvent(nullable:true, size:0..80)
		// Allow quite a bit of space here for app supplied data
		userToken(size:0..500, nullable: true, blank:true)
	}
	
	def beforeInsert() {
	}
}
