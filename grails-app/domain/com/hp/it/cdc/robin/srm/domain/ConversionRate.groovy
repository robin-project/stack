package com.hp.it.cdc.robin.srm.domain

import com.hp.it.cdc.robin.srm.constant.CurrencyEnum
import org.bson.types.ObjectId
class ConversionRate {
	ObjectId id
	CurrencyEnum currency
	BigDecimal rateToRmb
	
    static constraints = {
    }
}
