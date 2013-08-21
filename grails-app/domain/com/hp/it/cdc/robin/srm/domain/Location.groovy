package com.hp.it.cdc.robin.srm.domain
import org.bson.types.ObjectId

class Location {

	ObjectId id
	String locationCode
	String alias

    static constraints = {
    	alias nullable:true
    }
}
