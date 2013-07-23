package com.hp.it.cdc.robin.srm.form

import java.util.Date;

import org.springframework.web.multipart.commons.CommonsMultipartFile

import pl.touk.excel.export.WebXlsxExporter
import pl.touk.excel.export.XlsxExporter

import com.hp.it.cdc.robin.srm.constant.ActivityTypeEnum
import com.hp.it.cdc.robin.srm.constant.ArriveDateTypeEnum
import com.hp.it.cdc.robin.srm.constant.RequestStatusEnum
import com.hp.it.cdc.robin.srm.constant.ResourceStatusEnum
import com.hp.it.cdc.robin.srm.constant.RoleEnum
import com.hp.it.cdc.robin.srm.constant.TabEnum
import com.hp.it.cdc.robin.srm.domain.Activity
import com.hp.it.cdc.robin.srm.domain.Issue
import com.hp.it.cdc.robin.srm.domain.Purchase
import com.hp.it.cdc.robin.srm.domain.Request
import com.hp.it.cdc.robin.srm.domain.Resource
import com.hp.it.cdc.robin.srm.domain.ResourceLog
import com.hp.it.cdc.robin.srm.domain.ResourceType
import com.hp.it.cdc.robin.srm.domain.Usage
import com.hp.it.cdc.robin.srm.domain.User
import com.mongodb.Mongo
import com.mongodb.gridfs.GridFS
import com.mongodb.gridfs.GridFSInputFile
import com.hp.it.cdc.robin.srm.domain.SystemProperty

import srm.web.NotificationService;


class AdminController {
	transient mailService
	transient _gridfs
	static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

	def NotificationService notificationService

	def index() {
		//        redirect(action: "list", params: params)
		session.setAttribute("view", RoleEnum.ADMIN.description)
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
		[requestInstanceList: requestInstanceList, requestInstanceTotal: Request.count()]
	}

	def renderAllocateModels(Integer max){
		log.info params
		session.setAttribute("tab", TabEnum.TAB_ADMIN_ALLOCATE_RESOURCES)
		params.max = Math.min(max ?: 10, 100)

		def requestInstanceList = Request.where{
			status in [
				RequestStatusEnum.WAITING_ALLOCATED,
				RequestStatusEnum.PARTIAL
			]
		}.list(sort:"id",
		offset:Integer.valueOf(params["offset"])*params.max,max:params.max)
		render (template:"formAllocateResource",collection: requestInstanceList)
	}

	def renderViewModels(Integer max){
		log.info params
		session.setAttribute("tab", TabEnum.TAB_ADMIN_ALLOCATE_RESOURCES)
		params.max = Math.min(max ?: 10, 100)
		def requestInstanceList = Request.where{
			status in [
				RequestStatusEnum.WAITING_ALLOCATED,
				RequestStatusEnum.PARTIAL
			]
		}.list(sort:"id",
		offset:Integer.valueOf(params["offset"])*params.max,
		max:params.max)
		render (template:"formViewResource",collection: requestInstanceList)
	}

	def demand(){
		log.info params
		def user = session['user']
		user.save()
		log.debug 'save User...'
		def userBusinessInfo1=params['userBusinessInfo1'];
		def owner = User.findByUserBusinessInfo1(userBusinessInfo1);
		if (owner == null) return;

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
				flash.message=message(code: 'flash.request.closed.success', args: ["req-apply-"+requestId])
			}else{
				req.status=RequestStatusEnum.PARTIAL
				flash.message=message(code: 'flash.request.partial.success', args: ["req-apply-"+requestId])
			}
			req.save(flush:true)
			log.debug 'save Request...'
		}

		redirect(action: "allocateResources");

	}

	def loadNormalSerials(){
		log.info params
		def typeId = params.typeId;
		String selectionName= params.selectionName;
		def patterns = selectionName.split("_")
		def number = patterns[1];
		def purchaseList = Purchase.findAllByResourceType(ResourceType.get(typeId))

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
	def closeRequest(Integer requestId){
		log.info params
		if (params.requestId==null){
			return;
		}

		User user = session.getAttribute("user");
		user.save();
		log.debug 'save User...'
		if (RoleEnum.ADMIN.equals(user.role)){
			Request req = Request.get(requestId);
			if(req != null){
				req.status=RequestStatusEnum.CLOSED;
				req.nextActionUserBusinessInfo1=null;
				req.currentStep +=1;

				req.addToActivities(new Activity(activityType:ActivityTypeEnum.CLOSED,
				comment:params.comment,activityUser:user));
				req.save(flush:true);
				log.debug 'save Request...'
				flash.message = message(code: 'flash.request.closed.success', args: ["req-apply-"+requestId])

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
			displayedModel:purchaseInstance.resourceType.resourceTypeName+ " "+purchaseInstance.resourceType.supplier+ " "+purchaseInstance.resourceType.model,
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

	def addResourceType() {
		log.info params
		def resourceTypeInstance = new ResourceType(params)
		//		resourceTypeInstance.pictureNames = new ArrayList<String>()
		//		resourceTypeInstance.getPictureNames().add("1d9b649a-a88b-42c0-9b82-066c8fa15bb2190295247_b4e6f33f7c_b.jpg");

		if(!resourceTypeInstance.validate()){
			render (view:"addResources", model:[resourceTypeInstance:resourceTypeInstance, error:"error"])
			return
		}

		if (ResourceType.find(resourceTypeInstance)){
			flash.error = message(code: 'flash.addResourceType.duplicate', args: [resourceTypeInstance])
		}else{
			if (!resourceTypeInstance.save(flush: true)) {
				log.debug 'Unable to save ResourceType...'
				//render(view: "create", model: [resourceTypeInstance: resourceTypeInstance])

				return
			}

			flash.message = message(code: 'flash.addResourceType.success', args: [resourceTypeInstance])

		}
		redirect(action: "addResources")
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
		resourceType.pictureNames.add(fileName)
		resourceType.save()
		log.debug 'save ResourceType ...'
		//		render(view: "addResources")
	}

	def queryResources(){
		log.info params
		session.setAttribute("tab", TabEnum.TAB_ADMIN_QUERY_RESOURCES)
		flash.resources = null
		flash.actionMessage = null

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

		if (flash.actionRes && flash.args){
			def user = session['user']
			user.save()
			log.debug 'save User ... '
			flash.actionRes.each {
				Resource res = Resource.get(it.id)
				if (flash.args.toString() == '[returnedItio]'){
					res.status = ResourceStatusEnum.RETURNED_ITIO
				}else if (flash.args.toString() == '[retired]'){
					res.status = ResourceStatusEnum.RETIRED
				}else if (flash.args.toString() == '[broken]'){
					res.status = ResourceStatusEnum.BROKEN
				}else if (flash.args.toString() == '[lost]'){
					res.status = ResourceStatusEnum.LOST
				}else if (flash.args.toString() == '[transferred]'){
					res.status = ResourceStatusEnum.TRANSFERRED
				}else if (flash.args.toString() == '[returned]'){
					res.status = ResourceStatusEnum.NORMAL
				}
				res.currentUser = null
				res.addToResourceLogs(new ResourceLog(status:res.status, dateCreated:new Date(), operateUser:user, logdetail: "update resource status from ["+it.status+"] to ["+res.status+"]"))
				res.save()
				log.debug 'save Resource... '
				flash.actionMessage = message(code:"resource.action.msg", args:[
					flash.actionRes.size(),
					flash.args.toString()
				])
			}
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
			flash.resources = results
			if (params.actionMsg){
				flash.actionMessage=params.actionMsg
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
			def sortInfo = params.sortParams
			def orderInfo = params.orderParams


			if (sortInfo==null || sortInfo==""){
				sortInfo = "status"	//default sort
				orderInfo = "asc"
			}

			log.debug 'sortInfo :' + sortInfo
			log.debug 'orderInfo :' + orderInfo

			def criteria = User.createCriteria()
			def results = criteria.list(max: eachPageCount, offset: pageOffSet, sort: sortInfo , order: orderInfo){
				or {
					ilike("userBusinessInfo1", "%" + content + "%")
					ilike("userBusinessInfo2", "%" + content + "%")
					ilike("userBusinessInfo3", "%" + content + "%")

				}
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
			[userList:results,pageCounts:counts, currentPage: params.pageId, totalCounts:results.totalCount]
		}
	}

	def saveUserDetails(String id, Long version) {
		log.info params
		def userInstance = User.get(id)
		if (!userInstance) {
			return
		}

		if (version != null) {
			if (userInstance.version > version) {
				userInstance.errors.rejectValue("version", "default.optimistic.locking.failure",
						[
							message(code: 'user.label', default: 'User')] as Object[],
						"Another user has updated this User while you were editing")
				return
			}
		}

		userInstance.properties = params
		if (userInstance.save(flush: true)) {
			flash.message = message(code: 'flash.saveUserDetails.success', args: [userInstance.userBusinessInfo3])
			return
		}
		
		flash.error = message(code: 'flash.saveUserDetails.duplicate', args: [userInstance])
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
		def str = params.queryParams.toString()
		str = str.substring(1, str.length()-2)
		def strArr = str.split(',')
		def newMap = new HashMap()
		strArr.each {
			def temp = it.split(':')
			if (temp.length==2){
				newMap.put(temp[0].trim(), temp[1].trim())
			}else{
				newMap.put(temp[0].trim(), null)
			}
		}
		List<Resource> results = getQueryResources(newMap, 0, 0, "displayedModel", "desc")

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
		mailService.sendMail {
			multipart true
			to tos
			from SystemProperty.first().emailFrom
			subject message(code: "email.resource.subject")
			attach new File(path)
			text message(code: "email.resource.text")
		}
		flash.args = [tos]
		flash.resources = results
		//render(view: "emailResources", model: [tos: tos])
	}


	def selectedResources(){
		flash.actionRes = null
		def resList = params.checkedResource.toString().split(",");
		def results = new ArrayList();
		resList.each{
			def res = Resource.get(it.toString())
			results.add(res)
		}
		if (results.size() == 0){
			results = null
		}
		flash.actionRes = results
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

	private def getQueryResources(params, eachPageCount, pageOffSet, sortProp, orderProp){
		log.info params
		def query = Resource.createCriteria()
		def results = query.list(max: eachPageCount, offset: pageOffSet, sort: sortProp, order: orderProp) {
			//by serial number
			if (params.serialNr){
				eq('serial',params.serialNr)
			}
			//by owner user email
			if (params.userBusinessInfo2){
				def curUser = User.findByUserBusinessInfo2(params.userBusinessInfo2)
				if(curUser==null){
					curUser = ""
				}
				eq('currentUser', curUser)
			}
			//by purpose
			if (params.purpose){
				eq('purpose', params.purpose)
			}
			//by resource status
			if (params.normalCode||params.allocatedCode||params.brokenCode||params.retiredCode||params.lostCode||params.returnedItioCode||params.transferredCode){
				and{
					or{
						if (params.normalCode){
							eq('status',ResourceStatusEnum.NORMAL)
						}
						if (params.allocatedCode){
							eq('status',ResourceStatusEnum.ALLOCATED)
						}
						if (params.brokenCode){
							eq('status',ResourceStatusEnum.BROKEN)
						}
						if (params.retiredCode){
							eq('status',ResourceStatusEnum.RETIRED)
						}
						if (params.lostCode){
							eq('status',ResourceStatusEnum.LOST)
						}
						if (params.returnedItioCode){
							eq('status',ResourceStatusEnum.RETURNED_ITIO)
						}
						if (params.transferredCode){
							eq('status',ResourceStatusEnum.TRANSFERRED)
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
}
