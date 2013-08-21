package com.hp.it.cdc.robin.srm.service

import com.hp.it.cdc.robin.srm.constant.ActivityTypeEnum
import com.hp.it.cdc.robin.srm.constant.RequestStatusEnum
import com.hp.it.cdc.robin.srm.constant.RequestTypeEnum
import com.hp.it.cdc.robin.srm.domain.Activity
import com.hp.it.cdc.robin.srm.domain.Request

class RequestService {

	def service() {
		declineStaleTransferRequest()
	}
	
	def declineStaleTransferRequest(){
		log.info "=======================Decline stale transfer request======================="
		def transferRequestsOpenBefore7Days = Request.findAllByRequestTypeAndStatusAndDateCreatedLessThan(RequestTypeEnum.TRANSFER,RequestStatusEnum.NEW,new Date(new Date().getTime()+7*24*60*60*1000))
		transferRequestsOpenBefore7Days.each {
			try{
				it.addToActivities(new Activity(activityType:ActivityTypeEnum.DECLINED,comment:"Resource not being accepted in more than 3 days."))

				it.nextActionUserBusinessInfo1="null"
				it.status=RequestStatusEnum.REJECTED
				it.save(flush:true)
				log.info("decline request:"+it.id)
			}catch(Exception e){
				log.error e
			}
		}
		log.info "=======================END Decline stale transfer request======================="
	}
}
