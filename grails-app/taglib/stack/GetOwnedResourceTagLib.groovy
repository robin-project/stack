package stack

import com.hp.it.cdc.robin.srm.domain.Request
import com.hp.it.cdc.robin.srm.domain.ResourceType 
import com.hp.it.cdc.robin.srm.domain.Resource
import com.hp.it.cdc.robin.srm.domain.User
import com.hp.it.cdc.robin.srm.domain.Purchase
import com.hp.it.cdc.robin.srm.constant.RequestTypeEnum

class GetOwnedResourceTagLib {

	def ownedResource = { attrs, body ->
		def req = attrs.request
		def resourceType
        if (req.requestType == RequestTypeEnum.APPLY)
            resourceType = req.requestDetail?.resourceType
        else
            resourceType = req.requestDetail?.resource?.purchase?.resourceType
        
        def allPurchase = Purchase.findAllByResourceType(resourceType)
        def count = Resource.where {
            (purchase in allPurchase) && (purpose == req.requestDetail.purpose) && (currentUser==req.submitUser)
        }.count()

    	out << count
  	}


    def approvalsCount = {attrs, body -> 
        def user = attrs.user
        def count = Request.countByNextActionUserBusinessInfo1(user?.userBusinessInfo1)
        if (count !=0) {
            out << "<span id='tab_alert_approval_number' class='badge badge-important' style='display:inline'>"
            out << count
            out << "</span>"
        }else{
            out << "<span id='tab_alert_approval_number' class='badge badge-important' style='display:none'>"
            out << count
            out << "</span>"
        }
    }
}
