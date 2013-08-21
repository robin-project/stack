package com.hp.it.cdc.robin.srm.constant

enum IssueTypeEnum {
	IsolatedResources("ISOLATED_RESOURCE","Resource is not owned by an active User"),
	NoResourceFound("NO_RESOURCE","User has no resource")


	IssueTypeEnum(String issueCode, String description){
		this.issueCode=issueCode
		this.description=description
	}

	String issueCode
	String description
	
}
