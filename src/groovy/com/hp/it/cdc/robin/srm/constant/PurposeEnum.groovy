package com.hp.it.cdc.robin.srm.constant

enum PurposeEnum {
	Personal("Personal"),
	Project("Project")

	PurposeEnum(String purposeCode){
		this.purposeCode=purposeCode
	}

	String purposeCode
}