package com.hp.it.cdc.robin.srm.constant

enum RoleEnum {
	ADMIN(1,"ADMIN"),
	USER(2,"USER"),
	ADMIN_ASSIST(3,"ADMIN_ASSIST")
	
	RoleEnum(Integer roleId, String description){
		this.roleId = roleId
		this.description = description
	}
	Integer roleId
	String description
}
