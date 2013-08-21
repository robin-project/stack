package com.hp.it.cdc.robin.srm.form

import com.hp.it.cdc.robin.srm.constant.RequestStatusEnum
import com.hp.it.cdc.robin.srm.constant.TabEnum
import com.hp.it.cdc.robin.srm.domain.Request
import com.hp.it.cdc.robin.srm.domain.ResourceType
import com.hp.it.cdc.robin.srm.domain.User

class QueryController {

	def lookupUser(){
		log.info params
		def status_list = null
		if(params.status != null && !"".equals(params.status)){
			status_list = params.status.split(";")
		}

		def content = params.queryContent
		def criteria = User.createCriteria()
		def retval = criteria.list{
			and{
			if(status_list!=null){
				'in'("status", status_list)
			}
				or {
					ilike("userBusinessInfo1", "%" + content + "%")
					ilike("userBusinessInfo2", "%" + content + "%")
					ilike("userBusinessInfo3", "%" + content + "%")
				}
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
		def user = User.findByUserBusinessInfo1(params.userBusinessInfo1)
		def requestInstanceList
		if (user){
			requestInstanceList = Request.where{
				(status in [
					RequestStatusEnum.WAITING_ALLOCATED,
					RequestStatusEnum.PARTIAL
					])&&(submitUser==user)
				}.list(sort:"id")
		}else{
			requestInstanceList = Request.where{
				status in [
					RequestStatusEnum.WAITING_ALLOCATED,
					RequestStatusEnum.PARTIAL
					]
				}.list(sort:"id",
						offset:Integer.valueOf(params["offset"])*params.max,
						max:params.max)
		}
		
		//		render (template:"formAllocateResource",model:[requestInstanceList: requestInstanceList])
		//		render (template:"formViewResource",model:[requestInstanceList: requestInstanceList])

		
		render(template:"allocateList", model:[requestInstanceList: requestInstanceList])
	}
	

	def loadModel(){
		log.info params
		def models = null;
		if ((params.typeId==null || params.typeId=="")&&(params.supId==null || params.supId=="")){	//load all models
			models = ResourceType.list([sort:'model']).model
		}else if((params.typeId==null || params.typeId=="")&&(params.supId!=null && params.supId!="")){	//load models by supplier
			models = ResourceType.where {supplier==params.supId}.list([sort:'model']).model
		}else if((params.typeId!=null && params.typeId!="")&&(params.supId==null || params.supId=="")){	//load models by type
			models = ResourceType.where {resourceTypeName==params.typeId}.list([sort:'model']).model
		}else if(params.typeId!=null && params.typeId!=""&&params.supId!=null && params.supId!=""){	//load models by type and supplier
			models = ResourceType.where{resourceTypeName==params.typeId && supplier==params.supId}.list([sort:'model']).model
		}
		if (models!=null){
			models.unique()
		}
		render (view:"resourceCascadeSelection",model:[value_list:models])
	}

	
	def loadSuppliers(){
		log.info params
		def suppliers = null;
		if (params.typeId==null || params.typeId==""){
			suppliers = ResourceType.list([sort:'supplier']).supplier
		}else{
			suppliers = ResourceType.where {resourceTypeName==params.typeId}.list([sort:'supplier']).supplier
		}
		if (suppliers!=null){
			suppliers.unique()
		}
		render (view:"resourceCascadeSelection",model:[value_list:suppliers])
	}
	
	
	def displayRequest(){
		log.info params
		def user=session['user']
        params.max = Math.min(params.max ? params.max.toInteger() : 15,  100)
		if (params["offset"] == null){
        	params["offset"] = 1
        }
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

        if (params["offset"] == null){
        	params["offset"] = 1
        }
        def openMoreApprovals = Request.where{nextActionUserBusinessInfo1 == user.userBusinessInfo1}.list(
                    offset: Integer.valueOf(params["offset"]) * params.max,
                    max:params.max,
                    sort:"dateCreated", 
                    order:"asc")
        return openMoreApprovals
    }

    def countApprovals(){
		def count = Request.countByNextActionUserBusinessInfo1(session["user"].userBusinessInfo1)
		render count
    }

    def refreshDashboard(){
    	render(template:"dashboardNumbers")
    }

}
