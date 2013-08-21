package com.hp.it.cdc.robin.srm.constant

enum UserStatusEnum {

	ACTIVE("label.users.status.active"),
	INACTIVE("label.users.status.inactive"),
	REMOVED("label.users.status.remove")
	
	UserStatusEnum(String userStatusCode){
		this.userStatusCode = userStatusCode
	}
	String userStatusCode
}
