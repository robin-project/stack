package com.hp.it.cdc.robin.srm.form

import org.apache.jasper.compiler.Node.ParamsAction;

import srm.web.NotificationService;

import com.hp.it.cdc.robin.srm.constant.RequestStatusEnum
import com.hp.it.cdc.robin.srm.constant.RequestTypeEnum
import com.hp.it.cdc.robin.srm.constant.ResourceStatusEnum
import com.hp.it.cdc.robin.srm.constant.ActivityTypeEnum
import com.hp.it.cdc.robin.srm.constant.UserStatusEnum
import com.hp.it.cdc.robin.srm.constant.PurposeEnum
import com.hp.it.cdc.robin.srm.constant.RoleEnum
import com.hp.it.cdc.robin.srm.constant.TabEnum
import com.hp.it.cdc.robin.srm.constant.CurrencyEnum
import com.hp.it.cdc.robin.srm.domain.Activity
import com.hp.it.cdc.robin.srm.domain.Request
import com.hp.it.cdc.robin.srm.domain.RequestDetail
import com.hp.it.cdc.robin.srm.domain.ResourceApplyDetail
import com.hp.it.cdc.robin.srm.domain.ResourceTransferDetail
import com.hp.it.cdc.robin.srm.domain.ResourceApprovalWorkflow
import com.hp.it.cdc.robin.srm.domain.ResourceType
import com.hp.it.cdc.robin.srm.domain.Resource
import com.hp.it.cdc.robin.srm.domain.ResourceLog
import com.hp.it.cdc.robin.srm.domain.Step
import com.hp.it.cdc.robin.srm.domain.SystemProperty
import com.hp.it.cdc.robin.srm.domain.User
import com.hp.it.cdc.robin.srm.domain.Purchase
import com.hp.it.cdc.robin.srm.domain.Notification
import grails.converters.*

class CommonController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
	
	def NotificationService notificationService

    def index() {
        session.setAttribute("view", "COMMON")
    }

    def myResources(){
		log.info params
        session.setAttribute("tab", TabEnum.TAB_USER_MY_RESOURCES)
        def user = session['user']
        def res_list = Resource.findAllWhere(currentUser:user)
        def applied_query = Request.where {
            submitUser==user && (status == RequestStatusEnum.NEW || status == RequestStatusEnum.WAITING_APPROVED ||  status == RequestStatusEnum.PARTIAL || status == RequestStatusEnum.WAITING_ALLOCATED) && requestType == RequestTypeEnum.APPLY
        }
        def transfer_query = Request.where {
            submitUser==user && (status == RequestStatusEnum.NEW || status == RequestStatusEnum.WAITING_APPROVED ||  status == RequestStatusEnum.PARTIAL || status == RequestStatusEnum.WAITING_ALLOCATED) && requestType == RequestTypeEnum.TRANSFER
        }
        [res_list:res_list, apply_list: applied_query.findAll() , transfer_list: transfer_query.findAll() ]
    }


    def apply(){
		log.info params
        def user = session['user']
        if(!user?.isAttached())
            user.attach()
        def each_req =  params.findAll{
            it.key.contains("resourceType")
        }

        each_req.each {
            def matcher = (it.key =~ /resourceType_(\d+)/)
            def type = ResourceType.get(it.value)
            def quantity = Integer.valueOf(params['quantityNeed_'+matcher[0][1]])
            
            def detail = new ResourceApplyDetail(params)
            detail.resourceType = type
            detail.quantityNeed = quantity
            def activity = new Activity(activityType:ActivityTypeEnum.APPLY,comment:params.comment,activityUser:user)
            def req = new Request(submitUser:user ,status:RequestStatusEnum.NEW, requestType:RequestTypeEnum.APPLY, 
                currentStep: 1, 
                maxStep: SystemProperty.first().resourceApprovalWorkflow.stepCount, 
                nextActionUserBusinessInfo1: SystemProperty.first().resourceApprovalWorkflow.workFlowStep[0].stepValue,
                requestDetail: detail)
            req.addToActivities(activity)
            req.save()
			log.debug 'save Request...'
			
			notificationService.requestNotification(req)
        }
    }

    def transfer(){
		log.info params
        def user = session['user']
		if(!user?.isAttached())
			user.attach()
        def res = Resource.get(params.resourceId)
        def target_eid = params.userBusinessInfo1

        def detail = new ResourceTransferDetail()
        detail.resource = res
		detail.comment = params.comment
        detail.transferToUserBusinessInfo = target_eid

        def activity = new Activity(activityType:ActivityTypeEnum.TRANSOUT,comment:params.comment,activityUser:user)
        def req = new Request(submitUser:user ,status:RequestStatusEnum.NEW, requestType:RequestTypeEnum.TRANSFER, maxStep : 2, currentStep: 1 , nextActionUserBusinessInfo1:target_eid,
            requestDetail:detail )
        req.addToActivities(activity)
        req.save()
		log.debug 'save Request...'
		
		notificationService.requestNotification(req)
    }

    def myRequests(){
		log.info params
        def user=session['user']
        def openRequests = Request.where{(status in [
                RequestStatusEnum.NEW,
                RequestStatusEnum.WAITING_APPROVED,
                RequestStatusEnum.WAITING_ALLOCATED
            ]) && (submitUser == user)}.list(sort:"dateCreated", order:"desc")

        def queryClosedReq = Request.where{(status in [
                RequestStatusEnum.CLOSED,
                RequestStatusEnum.REJECTED
            ]) && (submitUser == user)}
        
        params.max = Math.min(params.max ? params.max.toInteger() : 15,  100)
        def closedRequests = queryClosedReq.list(offset:0, max:params.max, sort:"dateCreated", order:"desc")
         
        def closedRequestsCount = queryClosedReq.count()

        [openRequests: openRequests, closedRequests: closedRequests, closedRequestsCount:closedRequestsCount]
    }

    def myApprovals(){
		log.info params
        def user=session['user']
        params.max = Math.min(params.max ? params.max.toInteger() : 15,  100)

        def openApprovals = Request.where{nextActionUserBusinessInfo1 == user.userBusinessInfo1}.list(
            offset:0, max:params.max, sort:"dateCreated", order:"asc")

        [openApprovals:openApprovals]
    }

    def approveRequest(){
		log.info params
        def req
        try {
            //1. Create a new activity and mark the activityStatus to Approved
            def user=session['user']
            def comment = (params.comment)? params.comment : "approved"
            def activity = new Activity(activityType:ActivityTypeEnum.APPROVED,comment:comment,activityUser:user)
            
            user.save()//fix the OptimisticLockingException
			log.debug 'save User...'

            //2. Add activity to the request
            req = Request.get(params.requestId)
            req.addToActivities(activity)
            req.status=RequestStatusEnum.WAITING_APPROVED
            //3. Set the request.nextActionUserBusinessInfo1 to the next level manager/admin
            def systemProperty = getSystemPropertyConfig(req)
            def currentStepOperation = systemProperty.resourceApprovalWorkflow.workFlowStep[req.currentStep]

            
            if(!currentStepOperation)
            {
                req.nextActionUserBusinessInfo1="N/A"
                req.status=RequestStatusEnum.WAITING_ALLOCATED
                req.currentStep += 1
            }else
            {
                if (currentStepOperation.stepType=="actionUserBusinessInfo1")
                {
                    req.nextActionUserBusinessInfo1=currentStepOperation.stepValue
                    req.currentStep += 1
                }else
                {
                    def managerLevel = Integer.valueOf(currentStepOperation.stepValue)
                    def manager = getManagerInfo(req.submitUser, managerLevel.intValue())
                    if (manager==null) {
                        if (systemProperty.identifier=="iridium") {
                            req.nextActionUserBusinessInfo1="N/A"
                            req.status=RequestStatusEnum.WAITING_ALLOCATED
                            req.currentStep=systemProperty.resourceApprovalWorkflow?.stepCount-1
                        }else if (systemProperty.identifier=="platinum") {
                            req.nextActionUserBusinessInfo1="00647651"
                            req.currentStep=systemProperty.resourceApprovalWorkflow?.stepCount-2
                        }
                    }else{
                        req.nextActionUserBusinessInfo1=manager?.userBusinessInfo1
                        req.currentStep += 1    
                    }
                    
                }
            }
            req.save()
			log.debug 'save Request...'
			notificationService.requestNotification(req)
            flash.message = message(code: 'flash.approval.success', args: [req.getPrintableId()])

        }
        catch(Exception e) {
            log.error e
            flash.error = message(code: 'flash.approval.failure', args: [req.getPrintableId()])
        }
        finally {
            redirect(action: "myApprovals")
        }
    }

    def acceptTransfer(){
		log.info params
        def req
        try {
            //1. Create a new activity and mark the activityStatus to Approved
            def user=session['user']
            def comment = (params.comment) ? params.comment : "accepted"
            def activity = new Activity(activityType:ActivityTypeEnum.APPROVED,comment:comment,activityUser:user)

            //2. Add activity to the request
            req = Request.get(params.requestId)
            req.addToActivities(activity)
            req.status=RequestStatusEnum.CLOSED
            req.nextActionUserBusinessInfo1="N/A"

            //Set the resource's current user to the login user
            def requestDetail = req.requestDetail
            def resource = requestDetail.resource

            resource.currentUser=user

            // def resourceLog = new ResourceLog(status:ResourceStatusEnum.TRANSFERRED,relatedRequest:req,assignedUser:user)
            // resource.addToResourceLogs(new ResourceLog(status:ResourceStatusEnum.TRANSFERRED,relatedRequest:req,assignedUser:user))
            user.save()//OptimisticLockingException
			log.debug 'save User...'
            req.save()
			log.debug 'save Request...'
            resource.save()
			log.debug 'save Resource...'
            flash.message = message(code: 'flash.accept.success', args: [req.getPrintableId()])
        }
        catch(Exception e) {
            log.error e
            flash.error = message(code: 'flash.accept.failure', args: [req.getPrintableId()])
        }
        finally {
            redirect(action: "myApprovals")
        }
    }

    def declineRequest(){
		log.info params
        def req
        try {
            //1. Create a new activity and mark the activityStatus to Decline
            def user=session['user']
            user.save()
			log.debug 'save User...'
            def comment = (params.comment) ? params.comment : "declined"
            def activity = new Activity(activityType:ActivityTypeEnum.DECLINED,comment:comment,activityUser:user)
            //2. Add activity to the request
            req = Request.get(params.requestId)
            req.addToActivities(activity)
            //3. Set the request.nextActionUserBusinessInfo1 to null
            req.nextActionUserBusinessInfo1="N/A"
            req.status=RequestStatusEnum.REJECTED
            req.save()
			log.debug 'save Request...'
            notificationService.requestNotification(req)
            flash.message = message(code: 'flash.decline.success', args: [req.getPrintableId()])
        }
        catch(Exception e) {
            log.error e
            flash.error = message(code: 'flash.decline.failure', args: [req.getPrintableId()])
        }
        finally {
            redirect(action: "myApprovals")
        }
    }

    private def getSystemPropertyConfig(Request req){
        def resourceType=req.requestDetail?.resourceType
        def minPrice = Purchase.findByResourceType(resourceType)?.unitPrice
        Purchase.findAllByResourceType(resourceType).each{
            if (it.unitCurrency==CurrencyEnum.USD) {
                it.unitPrice *= 6
            }
            if (it.unitPrice < minPrice) {
                minPrice = it.unitPrice
            }
        }
        if (minPrice >= 6000) {
            log.info "Use platinum system config, actionUser > Manager1 > Manager2 > actionUser "
            return SystemProperty.findByIdentifier("platinum")
        }
        log.info "Use iridium system config, actionUser > Manager1 "
        return SystemProperty.findByIdentifier("iridium")
    }

    private def getManagerInfo(User user, int managerLevel){
		log.info params
        User manager = User.findByUserBusinessInfo1(user?.manager?.userBusinessInfo1)
        if(managerLevel > 1 ){
            getManagerInfo(manager, --managerLevel)
        }else{
            return manager
        }
    }
}
