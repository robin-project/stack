package srm.web

import com.hp.it.cdc.robin.srm.domain.*
import com.hp.it.cdc.robin.srm.constant.*
import org.apache.camel.Exchange

class NotificationService {

	def findNotification(){
		def notification_list = Notification.findAllBySentTsIsNull()
		sendMessage("seda:sendNotification",notification_list)
	}
	
	def markNotificationSent(Exchange exchange) {
		def notification = Notification.get(exchange.getIn().getHeader("id"))
		notification.setSentTs(new Date())
		notification.save()
	}
	
	def persistNotification(Exchange exchange){
		def notification = new Notification()
		notification.to = exchange.getIn().getHeader("to")
		notification.cc = exchange.getIn().getHeader("cc")
		notification.subject = exchange.getIn().getHeader("subject")
		
		notification.body = exchange.getIn().getBody()
		notification.from = "stack-system@hp.com"
		notification.save()
	}
	
	def requestNotification(Request req){
		if(req.status == RequestStatusEnum.REJECTED )
		{
			println req.submitUser.toString()
			def myMessage = [req:req, to:req.submitUser.userBusinessInfo2]
			sendMessage("seda:requestNotification", myMessage)
		}
		else if(!"N/A".equals(req.nextActionUserBusinessInfo1))
		{
			User nextUser = User.findByUserBusinessInfo1(req.nextActionUserBusinessInfo1)
			def myMessage = [req:req, to:nextUser.userBusinessInfo2 , nextUser:nextUser]
			sendMessage("seda:requestNotification", myMessage)
		}
	}

	def requestNotification(Request req, Resource res){
		if(res != null)
		{
			def myMessage = [req:req, to:req.submitUser.userBusinessInfo2, res: res, submitUser:req.submitUser.toString(), greeting:req.submitUser.userBusinessInfo3]
			sendMessage("seda:requestNotification", myMessage)
		}
	}
}
