package com.hp.it.cdc.robin.srm.domain

import com.hp.it.cdc.robin.srm.constant.RequestStatusEnum
import com.hp.it.cdc.robin.srm.constant.RequestTypeEnum
import com.hp.it.cdc.robin.srm.constant.ActivityTypeEnum
import org.bson.types.ObjectId

class Request {
    ObjectId id
    User submitUser
    RequestDetail requestDetail

    RequestStatusEnum status
    RequestTypeEnum requestType

    List<Activity> activities
    String nextActionUserBusinessInfo1
    Integer maxStep
    Integer currentStep

    Date dateCreated
    Date lastUpdated

    static embedded = [
        'requestDetail',
        'activities'
    ]

    static constraints = { 
		nextActionUserBusinessInfo1 nullable:true 
		submitUser lazy: false
		requestDetail lazy: false
	}

    String getPrintableId(){
        return requestType.toString() + submitUser.id.toString().substring(22,24) + id.toString().substring(22,24)
    }
}

class Activity {
    ActivityTypeEnum activityType
    String comment
    User activityUser
    Notification notification
    Date dateCreated = new Date()

    static constraints = {
        notification nullable:true
    }
}
