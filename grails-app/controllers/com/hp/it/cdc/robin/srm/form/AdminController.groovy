package com.hp.it.cdc.robin.srm.form

import org.springframework.web.multipart.commons.CommonsMultipartFile

import pl.touk.excel.export.WebXlsxExporter
import pl.touk.excel.export.XlsxExporter
import srm.web.NotificationService

import com.hp.it.cdc.robin.srm.constant.ActivityTypeEnum
import com.hp.it.cdc.robin.srm.constant.ArriveDateTypeEnum
import com.hp.it.cdc.robin.srm.constant.RequestStatusEnum
import com.hp.it.cdc.robin.srm.constant.ResourceStatusEnum
import com.hp.it.cdc.robin.srm.constant.RoleEnum
import com.hp.it.cdc.robin.srm.constant.TabEnum
import com.hp.it.cdc.robin.srm.constant.UserStatusEnum
import com.hp.it.cdc.robin.srm.domain.Activity
import com.hp.it.cdc.robin.srm.domain.Issue
import com.hp.it.cdc.robin.srm.domain.Location
import com.hp.it.cdc.robin.srm.domain.Purchase
import com.hp.it.cdc.robin.srm.domain.Request
import com.hp.it.cdc.robin.srm.domain.Resource
import com.hp.it.cdc.robin.srm.domain.ResourceLog
import com.hp.it.cdc.robin.srm.domain.ResourceType
import com.hp.it.cdc.robin.srm.domain.SystemProperty
import com.hp.it.cdc.robin.srm.domain.User
import com.hp.it.cdc.robin.srm.domain.ConversionRate
import com.mongodb.Mongo
import com.mongodb.gridfs.GridFS
import com.mongodb.gridfs.GridFSInputFile


class AdminController {
	transient mailService
	transient _gridfs
	transient birtReportService
	static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

	def NotificationService notificationService

	def index() {
		//        redirect(action: "list", params: params)
		session.setAttribute("view", "ADMIN")
	}

	def allocateResources(Integer max){
		log.info params
		session.setAttribute("tab", TabEnum.TAB_ADMIN_ALLOCATE_RESOURCES)
		params.max = Math.min(max ?: 10, 100)
		def requestInstanceList = Request.where{
			status in [
				RequestStatusEnum.WAITING_ALLOCATED,
				RequestStatusEnum.PARTIAL
			]
		}.list(sort:"id",max:params.max)
		def locationList = Location.list()
		[requestInstanceList: requestInstanceList, requestInstanceTotal: Request.count(),locationList:locationList]
	}

	def renderAllocateModels(Integer max){
		log.info params
		session.setAttribute("tab", TabEnum.TAB_ADMIN_ALLOCATE_RESOURCES)
		params.max = Math.min(max ?: 10, 100)
		def user = User.findByUserBusinessInfo1(params.userBusinessInfo1)
		def requestInstanceList 
		if (user){
			requestInstanceList = Request.where{
			(status in [
				RequestStatusEnum.WAITING_ALLOCATED,
				RequestStatusEnum.PARTIAL
			])&&(submitUser==user)}.list(sort:"id")
		}else{
			requestInstanceList = Request.where{
			status in [
				RequestStatusEnum.WAITING_ALLOCATED,
				RequestStatusEnum.PARTIAL
			]}.list(sort:"id",
					offset:Integer.valueOf(params["offset"])*params.max,
					max:params.max)
		}//end else

		render (template:"formAllocateResource",collection: requestInstanceList)
	}

	def renderViewModels(Integer max){
		log.info params
		session.setAttribute("tab", TabEnum.TAB_ADMIN_ALLOCATE_RESOURCES)
		params.max = Math.min(max ?: 10, 100)
		def user = User.findByUserBusinessInfo1(params.userBusinessInfo1)
		def requestInstanceList 
		if (user){
			requestInstanceList = Request.where{
			(status in [
				RequestStatusEnum.WAITING_ALLOCATED,
				RequestStatusEnum.PARTIAL
			])&&(submitUser==user)}.list(sort:"id")
		}else{
			requestInstanceList = Request.where{
			status in [
				RequestStatusEnum.WAITING_ALLOCATED,
				RequestStatusEnum.PARTIAL
			]}.list(sort:"id",
					offset:Integer.valueOf(params["offset"])*params.max,
					max:params.max)
		}
		
		render (template:"formViewResource",collection: requestInstanceList)
	}

	def demand(){
		log.info params
		def user = session['user']
		user.save()
		log.debug 'save User...'
		def userBusinessInfo1=params['userBusinessInfo1'];
		def owner = User.findByUserBusinessInfo1(userBusinessInfo1);
		if (owner == null) {
			flash.error=message(code: 'flash.errorDemandUserNotFound')
			redirect(action: "allocateResources");			
			return;
		}
		if (owner.status==UserStatusEnum.REMOVED){
			flash.error=message(code: 'flash.errorDemandRemovedUser', args:[owner])
			redirect(action: "allocateResources");
			return;
		}

		def allocations =  params.findAll{
			it.key.contains("resourceType")
		}
		def allocatedSerials=""
		allocations.each {
			def matcher = (it.key =~ /resourceType_(\d+)/)
			def type = ResourceType.get(it.value)

			def serialNr = params['serialNr_'+matcher[0][1]]

			def purchases = Purchase.findAllByResourceType(type);

			def resource
			for( Purchase purchase: purchases){
				resource=Resource.findByPurchaseAndSerialAndStatus(purchase,serialNr,ResourceStatusEnum.NORMAL);
				if (resource!=null){
					break;
				}
			}

			if (resource != null){
				resource.status=ResourceStatusEnum.ALLOCATED
				resource.purpose= params['purpose']
				resource.currentUser=owner
				resource.addToResourceLogs(new ResourceLog(status:ResourceStatusEnum.NORMAL, assignedUser:owner, operateUser:user, logdetail:"allocate resource to user - on demand"))
				resource.save()
				log.debug 'save Resource...'
				allocatedSerials += resource.serial+","
				log.info 'allocatedSerials:' + allocatedSerials

				notificationService.requestNotification(resource)
			}
		}//end of each

		if ("".equals(allocatedSerials)){
			flash.error=message(code: 'flash.demand.failure', args: [
				owner.userBusinessInfo3 + " ("+owner.userBusinessInfo2+")"
			])
		}else{
			flash.message=message(code: 'flash.demand.success', args: [
				owner.userBusinessInfo3 + " ("+owner.userBusinessInfo2+")",
				allocatedSerials
			])
		}
		log.info 'swap out demand'

		redirect(action: "allocateResources");
	}

	def allocate(){
		log.info params
		def user = session['user']
		user.save()
		log.debug 'save User...'
		def requestId=params.requestId
		if (requestId == null) return

			Request req= Request.get(requestId)

		def allocations =  params.findAll{
			it.key.contains("resourceType")
		}

		allocations.each {
			def matcher = (it.key =~ /resourceType_(\d+)/)
			def type = ResourceType.get(it.value)

			def serialNr = params['serialNr_'+matcher[0][1]]

			def purchases = Purchase.findAllByResourceType(type);

			def resource
			for( Purchase purchase: purchases){
				resource=Resource.findByPurchaseAndSerialAndStatus(purchase,serialNr,ResourceStatusEnum.NORMAL);
				if (resource!=null){
					break;
				}
			}

			if (resource != null){
				req.requestDetail.quantityAllocate +=1;
				req.addToActivities(new Activity(activityType:ActivityTypeEnum.ALLOCATED,
				comment:"allocate resource serial:"+ resource.serial,activityUser:user))
				req.save(flush:true)
				log.debug 'save Request...'

				resource.status=ResourceStatusEnum.ALLOCATED
				resource.purpose=req.requestDetail.purpose
				resource.currentUser=req.submitUser
				resource.addToResourceLogs(new ResourceLog(status:ResourceStatusEnum.NORMAL, relatedRequest:req, assignedUser:req.submitUser, operateUser:user, logdetail:"allocate resource to user"))
				resource.save(flush:true)
				log.debug 'save Resource...'

				notificationService.requestNotification(req, resource)
			}
		}
		if (req.requestDetail.quantityAllocate > 0){
			if (req.requestDetail.quantityNeed <=req.requestDetail.quantityAllocate){
				req.status=RequestStatusEnum.CLOSED
				req.currentStep+=1
				req.addToActivities(new Activity(activityType:ActivityTypeEnum.CLOSED,
				comment:"request fulfilled, close request",activityUser:user))
				flash.message=message(code: 'flash.request.closed.success', args: [req.getPrintableId()])
			}else{
				req.status=RequestStatusEnum.PARTIAL
				flash.message=message(code: 'flash.request.partial.success', args: [req.getPrintableId()])
			}
			req.save(flush:true)
			log.debug 'save Request...'
		}

		redirect(action: "allocateResources");

	}

	def toggleResourceTypeStatus(String typeId){
		def resourceType = ResourceType.get(typeId)
		resourceType.isBlock = resourceType.isBlock==true?false:true
		resourceType.save(flush:true)
		render(template:"currentResourceTypes")
	}

	def loadNormalSerials(){
		log.info params
		def typeId  = params.typeId;
		def purchaseList = new ArrayList<String>();
		if(typeId!=null && !"".equals(typeId) ){
			purchaseList = Purchase.findAllByResourceType(ResourceType.get(typeId))
		}
		String selectionName= params.selectionName;
		def patterns = selectionName.split("_")
		def number = patterns[1];

		def serials = new ArrayList<String>();
		for (Purchase purchase: purchaseList){
			if (serials == null){
				serials = Resource.findAllByStatusAndPurchase(ResourceStatusEnum.NORMAL,purchase).serial
			}else{
				serials.addAll(Resource.findAllByStatusAndPurchase(ResourceStatusEnum.NORMAL,purchase).serial);
			}
		}

		serials.remove(null);
		serials.unique();
		render (view:"serialSelection",model:[serials:serials, number:number])
	}

	def closeRequest(String requestId){
		log.info params
		if (params.requestId==null){
			return;
		}

		User user = session.getAttribute("user");
		user.save();
		log.debug 'save User...'
		if (RoleEnum.ADMIN<=user.role){
			Request req = Request.get(requestId);
			if(req != null){
				req.status=RequestStatusEnum.CLOSED;
				req.nextActionUserBusinessInfo1=null;
				req.currentStep +=1;

				req.addToActivities(new Activity(activityType:ActivityTypeEnum.CLOSED,
				comment:params.comment,activityUser:user));
				req.save(flush:true);
				log.debug 'save Request...'
				flash.message = message(code: 'flash.request.closed.success', args: [req.getPrintableId()])

				redirect(action: "allocateResources");
			}
		}
	}

	def returnResources(){
		log.info params
		session.setAttribute("tab", TabEnum.TAB_ADMIN_RETURN_RESOURCES)
	}

	def addResources(Integer maxPurchaseOnePage) {
		log.info params
		session.setAttribute("tab", TabEnum.TAB_ADMIN_ADD_RESOURCES)
		params.max = Math.min(maxPurchaseOnePage ?: 10, 100)
		[resourceTypeInstance: new ResourceType(params),newPurchaseInstance: new Purchase(params),
			purchaseInstanceList: Purchase.list(params), purchaseInstanceTotal: Purchase.count()]
	}

	def putInPool(){
		log.info params
		def user = session['user']
		user.save();
		log.debug 'save User...'
		def purchaseInstance = new Purchase(params)
		if(!purchaseInstance.validate()){
			render (view:"addResources", model:[newPurchaseInstance:purchaseInstance, error:"error"])
			return
		}
		
		if (!purchaseInstance.save()) {
			log.debug 'Unable to save purchaseInstance...'
			//			render(view: "addResources", model: [purchaseInstance: purchaseInstance])
			return
		}

		//update resourcetype latest unit price
		ResourceType rt = purchaseInstance.resourceType
		def rate=ConversionRate.findByCurrency(purchaseInstance.unitCurrency)==null?1:ConversionRate.findByCurrency(purchaseInstance.unitCurrency).rateToRmb
		rt.latestUnitPriceInRmb=purchaseInstance.unitPrice * rate
		rt.save(flush:true)
		
		def serials =  params.findAll{
			it.key.contains("serial_")
		}

		List<String> failedResourceSerials = new ArrayList<String>()
		for(int i=1; i<=purchaseInstance.quantity;i++){
			def serTemp =serials["serial_"+i].trim()
			if (serTemp == null ||"".equals(serTemp)){
				serTemp = "NA"
			}
			Resource newResource = new Resource(purchase:purchaseInstance,status:ResourceStatusEnum.NORMAL,serial:serTemp,
			displayedModel:purchaseInstance.resourceType.resourceTypeName+ " "+purchaseInstance.resourceType.model+" ("+purchaseInstance.resourceType.supplier+ ")",
			displayedProductNr:purchaseInstance.resourceType.productNr,
			displayedArriveDate:purchaseInstance.arriveDate,
			resourceLogs:[
				new ResourceLog(status:ResourceStatusEnum.NORMAL, operateUser:user,logdetail:"put in pool"
				)
			])

			try{
				if (!newResource.save()){
					log.debug 'Unable to save newResource...'
					failedResourceSerials.add(serTemp)

					continue
				}
			}catch(Exception e){
				log.error e
				failedResourceSerials.add(serTemp)

				continue
			}
		}

		if (failedResourceSerials.size()>0){
			purchaseInstance.quantity -= failedResourceSerials.size()
			purchaseInstance.save()
			log.debug 'save purchaseInstance...'
			flash.error = message(code: 'flash.putinpool.failure', args: [
				purchaseInstance.quantity,
				purchaseInstance.resourceType,
				failedResourceSerials
			])
		}else{
			flash.message = message(code: 'flash.putinpool.success', args: [
				purchaseInstance.quantity,
				purchaseInstance.resourceType
			])
		}

		redirect(action: "addResources")
	}
	
	def loadAllTypes(){
		def types = ResourceType.list([sort:'resourceTypeName']).resourceTypeName
		if (types!=null){
			types.unique()
		}
		render(view:"resourceCascadeSelection", model:[value_list: types])
	}
	
	def loadAllSuppliers(){
		def suppliers = ResourceType.list([sort:'supplier']).supplier
		if (suppliers!=null){
			suppliers.unique()
		}
		render(view:"resourceCascadeSelection", model:[value_list: suppliers])
	}
	
	def loadAllModels(){
		def models = ResourceType.list([sort:'model']).model
		if (models!=null){
			models.unique()
		}
		render(view:"resourceCascadeSelection", model:[value_list: models])
	}

	def addResourceType() {
		log.info params
		flash.messageAddResourceType = null
		flash.errorAddResourceType = null
		def resourceTypeInstance = new ResourceType(params)
		//		resourceTypeInstance.pictureNames = new ArrayList<String>()
		//		resourceTypeInstance.getPictureNames().add("1d9b649a-a88b-42c0-9b82-066c8fa15bb2190295247_b4e6f33f7c_b.jpg");

		if(!resourceTypeInstance.validate()){
			render (view:"addResources", model:[resourceTypeInstance:resourceTypeInstance, error:"error"])
			return
		}

		if (ResourceType.find(resourceTypeInstance)){
			flash.errorAddResourceType = message(code: 'flash.addResourceType.duplicate', args: [resourceTypeInstance])
		}else{
			if (!resourceTypeInstance.save(flush: true)) {
				log.debug 'Unable to save ResourceType...'
				//render(view: "create", model: [resourceTypeInstance: resourceTypeInstance])

				return
			}

			flash.messageAddResourceType = message(code: 'flash.addResourceType.success', args: [resourceTypeInstance])

		}
		render(template:"currentResourceTypes")
	}


	def retrievePictures(String resourceTypeId){
		log.info params
		def selectedResourceType = ResourceType.get(resourceTypeId)
		render(view:"resourceTypePictures", model: [selectedResourceType: selectedResourceType])
	}

	def addPicture(){
		log.info params
		CommonsMultipartFile file = request.getFile('pictureBinary')

		def okcontents = [
			'image/png',
			'image/jpeg',
			'image/gif'
		]
		if (! okcontents.contains(file.contentType)) {
			return
		}

		GridFSInputFile gfsFile = getGridFs().createFile(file.getBytes());
		String fileName = UUID.randomUUID().toString()
		gfsFile.setContentType(file.contentType)
		gfsFile.setFilename(fileName);
		gfsFile.save();
		log.debug 'save Picture ...'
		String resourceTypeId = request.getParameter("resourceTypeId")
		def resourceType = ResourceType.get(resourceTypeId)
		resourceType.pictureNames.add(0,fileName)
		resourceType.save()
		log.debug 'save ResourceType ...'
		//		render(view: "addResources")
	}

	def queryResources(){
		log.info params
		session.setAttribute("tab", TabEnum.TAB_ADMIN_QUERY_RESOURCES)
		flash.actionMessage = null
		flash.errorMessage = null

		//refresh the arriveType
		if (params.refreshArriveType){
			params.arriveDateType = params.refreshArriveType
			return
		}
		//initial the arriveType default value with 'On'
		if (!params.arriveDateType){
			params.arriveDateType = message(code:"label.arrive.type.on")
		}

		//initial the arriveDate
		if (params.arriveDate_year!=null){
			flash.arriveDateValue = params.arriveDate_month + " " + params.arriveDate_day + " " + params.arriveDate_year
		}
		if (params.arriveDateValue){
			flash.arriveDateValue = params.arriveDateValue
		}

		//process resources subAction(returned, retire, lost, normal, broken, transfered)
		if (params.actionResList && params.actionId){
			def user = session['user']
			user.save()
			log.debug 'save User ... '
			
			def resIdStatusArr = params.actionResList.substring(1,params.actionResList.size()-1).split(",")
			for (int i=0; i<resIdStatusArr.length; i++){
				def resIdStatus = resIdStatusArr[i].split("=")
				def resId = resIdStatus[0].trim()
				def oldStatus = resIdStatus[1].trim()
				Resource res = Resource.get(resId)
				res.currentUser = null
				if (params.actionId == '[returnedItio]'){
					res.status = ResourceStatusEnum.RETURNED_ITIO
				}else if (params.actionId == '[retired]'){
					res.status = ResourceStatusEnum.RETIRED
				}else if (params.actionId == '[broken]'){
					res.status = ResourceStatusEnum.BROKEN
				}else if (params.actionId == '[lost]'){
					res.status = ResourceStatusEnum.LOST
				}else if (params.actionId == '[returned]'){
					res.status = ResourceStatusEnum.NORMAL
					if (res.purchase.resourceType.isBlock == false){
						res.purchase.resourceType.isBlock = true
					}
				}else if (params.actionId == '[transferred]'){
					res.status = ResourceStatusEnum.TRANSFERRED
				}else if (params.actionId == '[reAssigned]'){
					res.status = ResourceStatusEnum.ALLOCATED	//reassigned current resource to another user
					//set current user to new
					if (params.reAssignedUserEid){
						res.currentUser = User.findByUserBusinessInfo1(params.reAssignedUserEid)
					}
				}
				def detail = "Update resource status from ["+oldStatus+"] to ["+res.status+"]"
				if (params.actionComment){
					detail +="; \n<strong>ActionComment :</strong> " + params.actionComment
				}
				if (params.actionId == '[reAssigned]'){
					res.addToResourceLogs(new ResourceLog(status:res.status, dateCreated:new Date(), operateUser:user, assignedUser:res.currentUser, logdetail: detail))
				}else{
					res.addToResourceLogs(new ResourceLog(status:res.status, dateCreated:new Date(), operateUser:user, logdetail: detail))
				}
				if (!res.save(flush:true)){
					flash.errorMessage = message(code:"resource.action.error", args:[params.actionId])
					return
				}
			}
			flash.actionMessage = message(code:"resource.action.msg", args:[resIdStatusArr.length,params.actionId])
		}

		//calculate current page's beginning index
		def pageOffSet = 0
		if (SystemProperty.first() == null){
			log.error "no system property found!"
			return
		}
		def eachPageCount = SystemProperty.first().eachResourcePageCount
		if (params.pageId && new Integer(params.pageId) > 0){
			pageOffSet = (new Integer(params.pageId)-1) * eachPageCount
		}
		//query criteria
		if (params.subAction=='query'){
			if (!"desc".equals(params.orderName)&&!"asc".equals(params.orderName)){
				params.orderName = "desc"
			}
			if (params.sortName==null || params.sortName==""){
				params.sortName = "displayedModel"	//default is sorted by id
			}
			def results = getQueryResources(params, eachPageCount, pageOffSet, params.sortName, params.orderName)
			if (params.actionMsg){
				flash.actionMessage=params.actionMsg
			}
			//send email message
			def emailList =  params.findAll{
				it.key.contains("emailAddress_")
			}
			def tos = null
			if (emailList!=null && emailList.size()>0){
				tos = new ArrayList<String>()
				emailList.each {
					tos.add(it.value)
				}
				if (tos != null && tos.size() > 0){
					flash.actionMessage = "Resources have sent to emails " + tos + " successfully!"
				}
			}
			//figure out page counts
			def counts= 1
			if (results != null && results.totalCount > eachPageCount){
				def pageCount = results.totalCount/eachPageCount;
				counts = pageCount.toInteger()
				if (pageCount > pageCount.toInteger()){
					counts ++
				}
			}
			//begin page id
			if (!params.pageId){
				params.pageId = 1
			}
			[resources:results, pageCounts:counts, currentPage: params.pageId, totalCounts:results.totalCount, params:params]
		}
	}
	
	def serialConfig(String id){
		log.info params
		def resourceInstance = Resource.get(id);
		if (!resourceInstance) {
			return
		}

		resourceInstance.properties = params
		if (resourceInstance.save(flush: true)) {
			flash.actionMessage = message(code: 'flash.serialConfig.success', args: [resourceInstance.serial])
			return
		}
		
			flash.errorMessage = message(code: 'flash.serialConfig.failure', args: [resourceInstance.serial])
			log.debug 'Unable to update AliasConfig...'
			
	}
	
	def issues(){
		log.info params
		session.setAttribute("tab", TabEnum.TAB_ADMIN_ISSUES)
		params.max = Math.min(params.max ? params.max.toInteger() : 12,  100)
		[issueInstanceList: Issue.list(params), issueInstanceTotal: Issue.count()]
	}

	def issueList(){
		log.info params
		session.setAttribute("tab", TabEnum.TAB_ADMIN_ISSUES)
		params.max = Math.min(params.max ? params.max.toInteger() : 12,  100)

		[issueInstanceList: Issue.list(offset:Integer.valueOf(params["offset"])*params.max,max:params.max), issueInstanceTotal: Issue.count()]
	}

	def manageUsers(){
		log.info params
		session.setAttribute("tab", TabEnum.TAB_ADMIN_MANAGE_USERS)

		def pageOffSet = 0
		def eachPageCount = message(code:"user.page.each.count", default:'10').toInteger()
		if (params.pageId && new Integer(params.pageId) > 0){
			pageOffSet = (new Integer(params.pageId)-1) * eachPageCount
		}

		if (params.subAction=='query'){
			def content = params.queryContent

			if (!"desc".equals(params.orderParams)&&!"asc".equals(params.orderParams)){
				params.orderParams = "asc"
			}
			if (params.sortParams==null || params.sortParams==""){
				params.sortParams = "status"	//default is sorted by status
			}
			
			def results
			def criteria = User.createCriteria()
			if (params.userBusinessInfo1==null||"".equals(params.userBusinessInfo1)){
				results = criteria.list(max: eachPageCount, offset: pageOffSet, sort: params.sortParams , order: params.orderParams){
					or {
						ilike("userBusinessInfo1", "%" + content + "%")
						ilike("userBusinessInfo2", "%" + content + "%")
						ilike("userBusinessInfo3", "%" + content + "%")}}
			}else{
				results = criteria.list(max: eachPageCount, offset: pageOffSet, sort: params.sortParams , order: params.orderParams){
					
						eq("userBusinessInfo1",  params.userBusinessInfo1)}
			}
			
			log.debug 'Rendering  :'+ results
			if(results ==null){
				flash.totalCount =0
			}
			else
			{
				flash.totalCount =results.totalCount
			}

			def counts= 1
			if (results != null && results.totalCount > eachPageCount){
				def pageCount = results.totalCount/eachPageCount;
				counts = pageCount.toInteger()
				if (pageCount > pageCount.toInteger()){
					counts ++
				}
			}
			if (!params.pageId){
				params.pageId = 1
			}
			def locationList = Location.list()
			[userList:results,pageCounts:counts, currentPage: params.pageId, totalCounts:results.totalCount,locationList:locationList]
		}
	}

	def saveUserDetails(String id, Long version) {
		log.info params
		def userInstance = User.get(id)
		if (!userInstance) {
			return
		}

		userInstance.properties = params
		if (userInstance.save(flush: true)) {
			flash.message = message(code: 'flash.saveUserDetails.success', args: [userInstance.userBusinessInfo3])
			if (userInstance.role == RoleEnum.PRIMARY_ADMIN && User.countByRole(userInstance.role) >1 ){
				def user = User.findAllByRole(userInstance.role)
				for (u in user){
					if( u.userBusinessInfo1 != userInstance.userBusinessInfo1){
						u.setRole(RoleEnum.USER)
						u.save()
					}
				}
			}
			
			if (userInstance.role == RoleEnum.RESOURCE_MANAGER && User.countByRole(userInstance.role) >1 ){
				def user = User.findAllByRole(userInstance.role)
				for (u in user){
					if( u.userBusinessInfo1 != userInstance.userBusinessInfo1){
						u.setRole(RoleEnum.USER)
						u.save()
					}
				}
			}
			
			return
		}
		
		flash.error = message(code: 'flash.saveUserDetails.duplicate', args: [userInstance])
	}

	def saveAliasConfig(String id){
		log.info params
		def locationInstance = Location.get(id)
		if (!locationInstance) {
			return
		}

		locationInstance.properties = params
		if (locationInstance.save(flush: true)) {
			flash.info = message(code: 'flash.updateAliasConfig.success', args: [locationInstance.locationCode])
			return
		}
		
			flash.err = message(code: 'flash.updateAliasConfig.failure', args: [locationInstance])
			log.debug 'Unable to update AliasConfig...'
	}


	private def getGridFs(){
		log.info params
		if (this._gridfs == null){
			def mongoSettings = grailsApplication.config.mongo
			Mongo mongo = new Mongo(mongoSettings.host, mongoSettings.port.intValue());
			def db = mongo.getDB(mongoSettings.databaseName);
			_gridfs = new GridFS(db,mongoSettings.bucket)
		}

		return _gridfs
	}

	def emailResources(){
		log.info params
		def emailList =  params.findAll{
			it.key.contains("emailAddress_")
		}
		def tos = new ArrayList<String>()
		emailList.each {
			tos.add(it.value)
		}
		List<Resource> results = getQueryResources(params, 0, 0, "displayedModel", "desc")

		//create excel
		def headers = [
			message(code: "excel.resource.header2"),
			message(code: "excel.resource.header3"),
			message(code: "excel.resource.header4"),
			message(code: "excel.resource.header5"),
			message(code: "excel.resource.header6"),
			message(code: "excel.resource.header7"),
			message(code: "excel.resource.header8"),
			message(code: "excel.resource.header9")
		]
		def withProperties = [
			'status.description',
			'purchase.resourceType.resourceTypeName',
			'purchase.resourceType.supplier',
			'purchase.resourceType.model',
			'serial',
			'purchase.resourceType.productNr',
			'currentUser.userBusinessInfo2',
			'purchase.arriveDate'
		]
		String path = servletContext.getRealPath("/") + "emailResources/Resource_" + new Date().getTime()+ ".xlsx"
		new XlsxExporter(path).with {
			fillHeader(headers)
			add(results, withProperties)
			save()
			log.debug 'save emailResources ... '
		}
		//send email attached excel
		try{
			mailService.sendMail {
				multipart true
				to tos
				from SystemProperty.first().emailFrom
				subject message(code: "email.resource.subject")
				attach new File(path)
				text message(code: "email.resource.text")
			}
		}catch(Exception e){
			log.error "send email faild with exception: "+e
			removeFileByPath(path)
		}
		removeFileByPath(path)
		flash.args = [tos]
		flash.resources = results
	}

	def removeFileByPath(String filePath){
		def file = new File(filePath)
		if (file.exists()){
			if (!file.delete()){
				log.error "can not delete temp file: "+filePath
			}
		}
	}

	def selectedResources(){
		flash.actionRes = null
		def resList = params.checkedResource.toString().split(",")
		def results = new ArrayList()
		def checkedResMap = new HashMap()
		resList.each{
			def res = Resource.get(it.toString())
			results.add(res)
			checkedResMap.put(res.id, res.status);
		}
		if (results.size() == 0){
			results = null
		}
		flash.actionRes = checkedResMap
		flash.args = [params.actionId]
		[checkedResults: results]
	}

	def exportResource(){
		log.info params
		List<Resource> exportList = getQueryResources(params, 0, 0, "displayedModel", "desc")
		def headers = [
			message(code: "excel.resource.header2"),
			message(code: "excel.resource.header3"),
			message(code: "excel.resource.header4"),
			message(code: "excel.resource.header5"),
			message(code: "excel.resource.header6"),
			message(code: "excel.resource.header7"),
			message(code: "excel.resource.header8"),
			message(code: "excel.resource.header9")
		]
		def withProperties = [
			'status.description',
			'purchase.resourceType.resourceTypeName',
			'purchase.resourceType.supplier',
			'purchase.resourceType.model',
			'serial',
			'purchase.resourceType.productNr',
			'currentUser.userBusinessInfo2',
			'purchase.arriveDate'
		]
		new WebXlsxExporter().with {
			setResponseHeaders(response)
			fillHeader(headers)
			add(exportList, withProperties)
			save(response.outputStream)
			log.debug 'save outputStream ... '
		}
	}
	
	private def getCascadeUsersByOrganization(List<User> users){
		def cascadeUsers = null
		for (User user:users){
			def tempUsers = User.findAllByManager(user)
			if(tempUsers){
				if(!cascadeUsers){
					cascadeUsers = []
				}
				cascadeUsers.addAll(tempUsers)
				// recursive query
				def recurUsers = getCascadeUsersByOrganization(tempUsers)
				if (recurUsers){
					cascadeUsers.addAll(recurUsers)
				}
			}
		}
		return cascadeUsers
	}

	private def getQueryResources(params, eachPageCount, pageOffSet, sortProp, orderProp){
		log.info params
		def query = Resource.createCriteria()
		def results = query.list(max: eachPageCount, offset: pageOffSet, sort: sortProp, order: orderProp) {
			//by serial number
			if (params.serialNr){
				def serials = params.serialNr.trim().split("\r\n")
				'in'('serial', serials)
			}

			//by owner
			if (params.queryContent != null && params.queryContent != ""){
				def curUsers = []
				//get current users
				curUsers = User.createCriteria().list(){
					if (params.queryResourceEid != null && params.queryResourceEid != ""){
						//equal query: by owner EID---only one user
						eq("userBusinessInfo1", params.queryResourceEid)
					}else{
						//like query: by owner Name---one or more users 
						ilike("userBusinessInfo3", "%" + params.queryContent + "%")
					}
				}
				//get cascade users if cascadeOwner is 'on' 
				if ("on".equals(params.ownerCascade) && curUsers.size() > 0){
					def cascadeUsers = getCascadeUsersByOrganization(curUsers)
					if (cascadeUsers){
						curUsers.addAll(cascadeUsers)
					}
				}
				'in'('currentUser', curUsers)
			}
			//by purpose
			if (params.purpose){
				eq('purpose', params.purpose)
			}
			//by resource status
			if ('on'.equals(params.normalCode)||'on'.equals(params.allocatedCode)||'on'.equals(params.brokenCode)||'on'.equals(params.retiredCode)||'on'.equals(params.lostCode)||'on'.equals(params.returnedItioCode)||'on'.equals(params.transferredCode)||'on'.equals(params.inQuestionCode)){
				and{
					or{
						if (params.normalCode && params.normalCode.equals('on')){
							eq('status',ResourceStatusEnum.NORMAL)
						}
						if (params.allocatedCode && params.allocatedCode.equals('on')){
							eq('status',ResourceStatusEnum.ALLOCATED)
						}
						if (params.brokenCode && params.brokenCode.equals('on')){
							eq('status',ResourceStatusEnum.BROKEN)
						}
						if (params.retiredCode && params.retiredCode.equals('on')){
							eq('status',ResourceStatusEnum.RETIRED)
						}
						if (params.lostCode && params.lostCode.equals('on')){
							eq('status',ResourceStatusEnum.LOST)
						}
						if (params.returnedItioCode && params.returnedItioCode.equals('on')){
							eq('status',ResourceStatusEnum.RETURNED_ITIO)
						}
						if (params.transferredCode && params.transferredCode.equals('on')){
							eq('status',ResourceStatusEnum.TRANSFERRED)
						}
						if (params.inQuestionCode && params.inQuestionCode.equals('on')){
							eq('status',ResourceStatusEnum.IN_QUESTION)
						}
					}
				}
			}
			//by purchase criteria
			if (params.productNr || params.supplier||params.model || (params.arriveDateType && params.arriveDate_year && params.arriveDate_month && params.arriveDate_day&& params.arriveDate_year && params.arriveDate_month && params.arriveDate_day) || params.type){
				def purs = null
				def purchases = null
				if (params.supplier||params.model||params.type || params.productNr){
					Map whereMap = new HashMap()
					if (params.supplier){
						whereMap.put("supplier", params.supplier)
					}
					if (params.model){
						whereMap.put("model", params.model)
					}
					if (params.type){
						whereMap.put("resourceTypeName", params.type)
					}
					if (params.productNr){
						whereMap.put("productNr", params.productNr)
					}
					def resTypes = ResourceType.findAllWhere(whereMap)
					purchases = Purchase.findAllByResourceTypeInList(resTypes)
				}
				//by arriveDate
				if (params.arriveDateType && params.arriveDate_year && params.arriveDate_month && params.arriveDate_day){
					def dateStr = params.arriveDate_month + "/" + params.arriveDate_day + "/" + params.arriveDate_year
					def arrDate = new Date().parse("MM/dd/yyyy",dateStr)
					def arrType = params.arriveDateType.toString()
					if (message(code:ArriveDateTypeEnum.ON.labelCode).equals(arrType)){
						purs = Purchase.findAllByArriveDate(arrDate)
					}else if(message(code:ArriveDateTypeEnum.BEFORE.labelCode).equals(arrType)){
						purs = Purchase.findAllByArriveDateLessThan(arrDate)
					}else if(message(code:ArriveDateTypeEnum.AFTER.labelCode).equals(arrType)){
						purs = Purchase.findAllByArriveDateGreaterThan(arrDate)
					}else if(message(code:ArriveDateTypeEnum.ON_BEFORE.labelCode).equals(arrType)){
						purs = Purchase.findAllByArriveDateLessThanEquals(arrDate)
					}else if(message(code:ArriveDateTypeEnum.ON_AFTER.labelCode).equals(arrType)){
						purs = Purchase.findAllByArriveDateGreaterThanEquals(arrDate)
					}
				}
				//figure out the purchases
				if (purchases && !purchases.isEmpty() && (purs==null || purs.isEmpty())){
					'in'('purchase', purchases)
				}else if ((!purchases || purchases.isEmpty()) && (purs!=null)){
					'in'('purchase', purs)
				}else if (purchases && !purchases.isEmpty() && (purs!=null)){
					'in'('purchase', purchases.intersect(purs))
				}else{
					'in'('purchase', purchases)
				}
			}
		}
		return results
	}

	def reports(){
		session.setAttribute("tab", TabEnum.TAB_ADMIN_REPORTS)

	}
}
