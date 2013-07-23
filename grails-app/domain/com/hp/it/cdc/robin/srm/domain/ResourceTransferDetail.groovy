package com.hp.it.cdc.robin.srm.domain

class ResourceTransferDetail extends RequestDetail{
	Resource resource
	String transferToUserBusinessInfo  //Email
	String comment
	
    static constraints = {
    }
}
