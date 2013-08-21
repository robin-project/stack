package com.hp.it.cdc.robin.srm.constant

enum CurrencyEnum {
	USD("USD"),
	RMB("RMB")


	CurrencyEnum(String currencyCode){
		this.currencyCode=currencyCode
	}

	String currencyCode
}