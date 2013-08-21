package com.hp.it.cdc.robin.srm.domain

import com.hp.it.cdc.robin.srm.constant.CurrencyEnum

class ResourceApprovalWorkflow {
	String range
	CurrencyEnum currency
    List<Step> workFlowStep = new ArrayList<Step>()
    Integer stepCount

    static embedded = ['workFlowStep']
    static constraints = {
    }
}


