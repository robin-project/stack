package com.hp.it.cdc.robin.srm.constant

enum RoleEnum {	
	USER(1,"USER"),
	ADMIN(2,"ADMIN"),
	PRIMARY_ADMIN(3,"PRIMARY_ADMIN"),
	RESOURCE_MANAGER(4,"RESOURCE_MANAGER")
	
	RoleEnum(Integer roleId, String description){
		this.roleId = roleId
		this.description = description
	}
	Integer roleId
	String description
}
