package com.hp.it.cdc.robin.srm.constant

enum ArriveDateTypeEnum {

	ON("label.arrive.type.on"),
	BEFORE("label.arrive.type.before"),
	AFTER("label.arrive.type.after"),
	ON_BEFORE("label.arrive.type.onbefore"),
	ON_AFTER("label.arrive.type.onafter")
	
	ArriveDateTypeEnum(String labelCode){
		this.labelCode =labelCode
	}

	String labelCode
}
