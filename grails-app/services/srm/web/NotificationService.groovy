package srm.web

import com.hp.it.cdc.robin.srm.domain.*
import com.hp.it.cdc.robin.srm.constant.*
import org.apache.camel.Exchange

class NotificationService {

	def findNotification(){
		def notification_list = Notification.withCriteria(){
			isNull('sentTs')
			lt('retryCount', 3)
		}
		sendMessage("seda:sendNotification",notification_list)
	}
	
	def markNotificationSentSuccess(Exchange exchange) {
		def notification = Notification.get(exchange.getIn().getHeader("id"))
		notification.setSentTs(new Date())
		notification.save()
	}

	def markNotificationSentFail(Exchange exchange) {
		def notification = Notification.get(exchange.getIn().getHeader("id"))
		def e = exchange.getProperty(Exchange.EXCEPTION_CAUGHT, Exception.class)
		if(notification.exception == null)
			notification.exception = new HashMap()
		notification.exception.put(new Date(), e)
		notification.retryCount ++ 
		notification.save()
	}
	
	def persistNotification(Exchange exchange){
		def notification = new Notification()
		notification.to = exchange.getIn().getHeader("to")
		notification.cc = exchange.getIn().getHeader("cc")
		notification.bcc = exchange.getIn().getHeader("bcc")
		notification.subject = exchange.getIn().getHeader("subject")
		
		notification.body = exchange.getIn().getBody()
		notification.from = SystemProperty.first().emailFrom
		notification.save()
	}
	
	def requestNotification(Request req){
		if(req.status == RequestStatusEnum.REJECTED )
		{
			
			def myMessage = [req:req, to:req.submitUser.userBusinessInfo2 , submitUser:req.submitUser.toString() ,greeting: req.submitUser.userBusinessInfo3]
			sendMessage("seda:requestNotification", myMessage)
		}
		else if(!"NA".equals(req.nextActionUserBusinessInfo1))
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

	def requestNotification(Resource res){
		def myMessage = [res: res , to: res.currentUser.userBusinessInfo2 ,submitUser:res.currentUser.toString(),, greeting:res.currentUser.userBusinessInfo3]
		sendMessage("seda:requestNotification", myMessage)
	}
}
