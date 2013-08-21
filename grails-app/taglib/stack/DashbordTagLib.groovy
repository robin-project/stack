package stack

import com.hp.it.cdc.robin.srm.domain.Request
import com.hp.it.cdc.robin.srm.domain.Resource
import com.hp.it.cdc.robin.srm.domain.User
import com.hp.it.cdc.robin.srm.constant.RequestTypeEnum
import com.hp.it.cdc.robin.srm.constant.RequestStatusEnum

class DashbordTagLib {

	static namespace = 'dash'
	
	def owned = {attrs, body->
	        def user = attrs.user
	        def count = Resource.countByCurrentUser(user)
	        out << count
	    }
    
    def requested = { attrs, body ->
        def user = attrs.user
        def count = Request.where{
            (submitUser==user) && 
            !(status in [RequestStatusEnum.CLOSED, RequestStatusEnum.REJECTED])}.count()
        out << count
    }

    def toAccept = { attrs, body ->
        def user = attrs.user
        def count = Request.countByStatusAndRequestTypeAndNextActionUserBusinessInfo1(RequestStatusEnum.NEW, RequestTypeEnum.TRANSFER, user?.userBusinessInfo1)
        out << count
    }
}
