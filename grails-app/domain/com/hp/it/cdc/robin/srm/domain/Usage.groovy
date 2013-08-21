package com.hp.it.cdc.robin.srm.domain

import org.bson.types.ObjectId

class Usage {
	ObjectId id
	enum PurposeEnum {
		Personal("Personal"),
		Project("Project")

		PurposeEnum(String purposeCode){
			this.purposeCode=purposeCode
		}

		String purposeCode
	}

//	Project project
	PurposeEnum purpose
	String comment
	static constraints = {
//		project nullable:true
		comment nullable:true
	}

	String toString()
	{
		//return purpose.purposeCode
	}
}

