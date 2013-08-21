package com.hp.it.cdc.robin.srm.domain

import org.bson.types.ObjectId

class Step {
	ObjectId id
    String stepType//actionUserBusinessInfo1,treeLevel
    String stepValue //admin or supervisor's email, tree manager level
    
    static constraints = {
    }
}
