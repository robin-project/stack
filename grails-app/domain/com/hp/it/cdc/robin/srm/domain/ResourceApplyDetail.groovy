package com.hp.it.cdc.robin.srm.domain

import com.hp.it.cdc.robin.srm.constant.PurposeEnum

class ResourceApplyDetail extends RequestDetail{
	
	String comment
	ResourceType resourceType
	PurposeEnum purpose
	
	Integer quantityNeed
	Integer quantityAllocate = Integer.valueOf(0)
	BigDecimal resourceTypeUnitPriceInRmb

    static constraints = {
		resourceTypeUnitPriceInRmb nullable:true 
    }
}
