package com.hp.it.cdc.robin.srm.domain

import com.hp.it.cdc.robin.srm.constant.CurrencyEnum
import org.bson.types.ObjectId


class Purchase {
	ObjectId id
	ResourceType resourceType
	Date arriveDate
	BigDecimal unitPrice
	CurrencyEnum unitCurrency
	Integer quantity
	BigDecimal totalPrice
	CurrencyEnum totalCurrency
	String comment
	
	static belongsTo = 	ResourceType

    static constraints = {
		comment nullable:false, blank:false
    }
}
