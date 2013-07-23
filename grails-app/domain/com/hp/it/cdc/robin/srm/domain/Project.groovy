package com.hp.it.cdc.robin.srm.domain

import org.bson.types.ObjectId

class Project {
	ObjectId id
	String projectName
	String enterpriseProjectId
	String comment
	
    static constraints = {
		enterpriseProjectId matches: "[0-9]+", unique:true
		comment nullable:true 
    }
	
	String toString(){
		return projectName
	}
}