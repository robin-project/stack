package com.hp.it.cdc.robin.srm.form

import com.hp.it.cdc.robin.srm.constant.RequestStatusEnum
import com.hp.it.cdc.robin.srm.constant.TabEnum
import com.hp.it.cdc.robin.srm.domain.Request
import com.hp.it.cdc.robin.srm.domain.ResourceType
import com.hp.it.cdc.robin.srm.domain.User

class QueryController {

	def lookupUser(){
		log.info params
		def content = params.queryContent
		def criteria = User.createCriteria()
		def retval = criteria.list{
			or {
				ilike("userBusinessInfo1", "%" + content + "%")
				ilike("userBusinessInfo2", "%" + content + "%")
				ilike("userBusinessInfo3", "%" + content + "%")
			}
			maxResults(5)
		}
		log.debug 'result : ' + retval
		render(contentType: "text/json") {
			users = array {
				for (u in retval) {
					user id:u.id,  email: u.userBusinessInfo2, eid: u.userBusinessInfo1 , name: u.userBusinessInfo3
				}
			}
		}
	}
	
	def allocateList(Integer max){
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
		//		render (template:"formAllocateResource",model:[requestInstanceList: requestInstanceList])
		//		render (template:"formViewResource",model:[requestInstanceList: requestInstanceList])

		[requestInstanceList: requestInstanceList]
	}
	
	def loadModel(){
		log.info params
		def models = null;
		if (params.id==null || params.id==""){
			models = ResourceType.findAll().model
		}else{
			models = ResourceType.findAllBySupplier(params.id).model
		}
		if (models!=null){
			models.add(0, '')
			models.unique()
		}
		render g.select(from: models, id: 'model_select', name: "model")
	}

	
	def loadSuppliers(){
		log.info params
		def suppliers = null;
		if (params.id==null || params.id==""){
			suppliers = ResourceType.findAll().model
		}else{
			suppliers = ResourceType.findAllByResourceTypeName(params.id).supplier
		}
		if (suppliers!=null){
			suppliers.add(0, '')
			suppliers.unique()
		}
		render g.select(from: suppliers, id: 'supplier_select', name: "supplier")
	}
	
	
	def displayRequest(){
		log.info params
		def user=session['user']
        params.max = Math.min(params.max ? params.max.toInteger() : 15,  100)

		def moreClosedRequests = Request.where{(status in [
				RequestStatusEnum.CLOSED,
				RequestStatusEnum.REJECTED
			]) && (submitUser == user)}.list(
					sort:"dateCreated",
					order:"desc",
					offset:Integer.valueOf(params["offset"])*params.max,
					max:params.max)

		render(template:"requests", model:[requests:moreClosedRequests])
	}

    def displayApprovalTab(){
		log.info params
        def openMoreApprovals = getMoreOpenApprovals(params)

        render(template:"/common/approvalTab", model:[openApprovals:openMoreApprovals])
    }

    def displayApprovalContent(){
		log.info params
        def openMoreApprovals = getMoreOpenApprovals(params)
        log.debug openMoreApprovals
        render(template:"/common/approvalContent", model:[openApprovals:openMoreApprovals])
    }

    def getMoreOpenApprovals(Object params){
		log.info params
        def user=session['user']
        params.max = Math.min(params.max ? params.max.toInteger() : 15,  100)
        def openMoreApprovals = Request.where{nextActionUserBusinessInfo1 == user.userBusinessInfo1}.list(
                    offset:Integer.valueOf(params["offset"])*params.max,
                    max:params.max,
                    sort:"dateCreated", 
                    order:"asc")
        return openMoreApprovals
    }
}
