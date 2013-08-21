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

    def resourceDetail(){
        log.info params
        def user = session['user']
        def res_id = params['res_id']
        def res = Resource.get(res_id)
        def transfer_query = Request.where {
            submitUser==user && (status == RequestStatusEnum.NEW || status == RequestStatusEnum.WAITING_APPROVED) && requestType == RequestTypeEnum.TRANSFER
        }
        def transfer_req = transfer_query.findAll().find{
            if(it.requestDetail.resource == res)
                return true
        }
        render (view:"_resourceDetail.gsp",model:[res:res,transfer_req:transfer_req])
    }


    def apply(){
		log.info params
        try{
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
                detail.resourceTypeUnitPriceInRmb = type?.latestUnitPriceInRmb
                def activity = new Activity(activityType:ActivityTypeEnum.APPLY,comment:params.comment,activityUser:user)
                def req = new Request(submitUser:user ,status:RequestStatusEnum.NEW, requestType:RequestTypeEnum.APPLY, 
                    currentStep: 1, 
                    requestDetail: detail)
                req.addToActivities(activity)
                
                def approvalWorkFlow = getApprovalWorkFlow(req)
                if (approvalWorkFlow.workFlowStep == null || approvalWorkFlow.workFlowStep.size() == 0) {
                    req.nextActionUserBusinessInfo1 = "NA"
                    req.status = RequestStatusEnum.WAITING_ALLOCATED
                }else if(approvalWorkFlow.workFlowStep.size() != 0){
                    def actionUserRole = approvalWorkFlow.workFlowStep[0].stepValue
                    req.nextActionUserBusinessInfo1 = User.findByRole(actionUserRole).userBusinessInfo1
                }

                req.maxStep=approvalWorkFlow.stepCount

                req.save()
    			log.debug 'save Request...'
    			
    			notificationService.requestNotification(req)
            }
        }catch(Exception e){
            log.error(e)
        }finally{
            redirect(action: "myResources")            
        }
	}

    def transfer(){
		log.info params
        try{
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

            render(status:200,text:"")
        }catch(Exception e){
            log.error(e)
            render(status:500,text:message(code: 'flash.transfer.failure'))
        }
        //redirect(action: "myResources")
    }

    def myRequests(){
		log.info params
        def user=session['user']
        def openRequests = Request.where{!(status in [
                RequestStatusEnum.CLOSED,
                RequestStatusEnum.REJECTED
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

        def allOpenApprovals = Request.where{nextActionUserBusinessInfo1 == user.userBusinessInfo1}.list()
        [openApprovals:openApprovals,allOpenApprovals:allOpenApprovals]
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
            def approvalFlow = getApprovalWorkFlow(req)
            def currentStepOperation = approvalFlow.workFlowStep[req.currentStep]

            
            if(!currentStepOperation)
            {
                req.nextActionUserBusinessInfo1="NA"
                req.status=RequestStatusEnum.WAITING_ALLOCATED
                req.currentStep += 1
            }else
            {
                if (currentStepOperation.stepType=="actionUserRole")
                {
                    req.nextActionUserBusinessInfo1=User.findByRole(currentStepOperation.stepValue).userBusinessInfo1
                    req.currentStep += 1
                }else
                {
                    def managerLevel = Integer.valueOf(currentStepOperation.stepValue)
                    def manager = getManagerInfo(req.submitUser, managerLevel.intValue())
                    if (manager==null) {
                        if (approvalFlow.workFlowStep[approvalFlow.workFlowStep.size()-1].stepType=="actionUserRole") {
                            req.nextActionUserBusinessInfo1="00647651"
                            req.currentStep=approvalFlow.stepCount-2
                        }else{
                            req.nextActionUserBusinessInfo1="NA"
                            req.status=RequestStatusEnum.WAITING_ALLOCATED
                            req.currentStep=approvalFlow.stepCount-1
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

	def loadActiveResourceTypeByName(){
        log.info params
        def resourceTypeName = params.ResourceTypeName;
		def query = ResourceType.createCriteria()
		def resourceType_list = query.list() {
			eq('resourceTypeName', resourceTypeName)
			and{
				or{
					eq('isBlock',null)
					eq('isBlock',false)
				}
			}
		}
		
        render (view:"resourceTypeSelection",model:[resourceType_list:resourceType_list.sort(new java.util.Comparator<com.hp.it.cdc.robin.srm.domain.ResourceType>() {
                                        public int compare(com.hp.it.cdc.robin.srm.domain.ResourceType lhs, com.hp.it.cdc.robin.srm.domain.ResourceType rhs) {
                                            
                                            def level1 = lhs.resourceTypeName.toLowerCase().compareTo(rhs.resourceTypeName.toLowerCase())
                                            if (level1 != 0){
                                                return level1
                                            }else{
                                                def level2 = (lhs.model.toLowerCase()).compareTo(rhs.model.toLowerCase())
                                                if (level2 != 0){
                                                    return level2
                                                }else{
                                                    
                                                    return (lhs.supplier.toLowerCase()).compareTo(rhs.supplier.toLowerCase())
                                                    
                                                }
                                            }
                                        }
                                })])
    }

    private def getApprovalWorkFlow(Request req){
        def realPrice = req?.requestDetail?.resourceTypeUnitPriceInRmb
        if (realPrice == null) {
            realPrice = req?.requestDetail?.resourceType?.latestUnitPriceInRmb
        }
        return getFlow(realPrice)
    }

    private def getFlow(BigDecimal realPrice){
        def price= realPrice==null?99999:realPrice
        def systemProperty = SystemProperty.first()
        def approvalWorkFlow 
        def arrays  = systemProperty.resourceApprovalWorkflow
        for(it in arrays) {
            def range = it.range.split("-")
            def minPrice = range[0].toBigDecimal() 
            def maxPrice
            if ( range.size() == 2 ) {   
                maxPrice = range[1].toBigDecimal()
                if (minPrice < price  && price <= maxPrice ){
                    return it
                }
            }else if(minPrice < price && maxPrice == null){
                return it
            }
        }
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
