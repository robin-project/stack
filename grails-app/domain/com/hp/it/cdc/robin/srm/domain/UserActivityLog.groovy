package com.hp.it.cdc.robin.srm.domain

import org.bson.types.ObjectId

class UserActivityLog {
	ObjectId id
	User user

	Date dateCreated

    static constraints = {
    }

    static mapping = {
    	collection 'user.activities'
    }
}
