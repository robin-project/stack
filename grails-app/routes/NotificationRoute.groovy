import org.apache.camel.builder.*
import org.apache.camel.*
import com.example.*
import com.hp.it.cdc.robin.srm.domain.*
import com.hp.it.cdc.robin.srm.constant.*

class NotificationRoute extends RouteBuilder {

	def grailsApplication

	void configure() {
		def config = grailsApplication?.config

		from('timer://notification?fixedRate=true&period=60000&delay=60000').to("bean://notificationService?method=findNotification")
		
		/*
		 * workflow that send the notificaiton
		 */
		from("seda:sendNotification").split().body(Collection.class)
				.process{ Exchange exchange ->
					def notification = exchange.getIn().getBody()
					exchange.getIn().setHeader("Content-Type", "text/html")
					exchange.getIn().setHeader("id", notification.id)
					exchange.getIn().setHeader("subject", notification.subject)
					exchange.getIn().setHeader("from", notification.from)
					exchange.getIn().setHeader("to", "fm.core.chinateam@hp.com")
					//exchange.getIn().setHeader("to", notification.to)
					//exchange.getIn().setHeader("cc", notification.cc)
					exchange.getIn().setBody(notification.body)
				}
				.to("smtp://smtp.hp.com:25")
				.to("bean://notificationService?method=markNotificationSent")
		
		/*
		 * workflow that request notification
		 */
		from('seda:requestNotification')
		.process { Exchange exchange ->
			//transform the message
			Map context = exchange.getIn().getBody(Map.class)
			for(e in context){
				exchange.getIn().setHeader(e.key, e.value)
			}
			//dispatch to different template
			if(exchange.in.headers["res"] != null )
			{
				exchange.getIn().setHeader("CamelVelocityResourceUri","template/resource_allocated.vm")
			}
			else if(exchange.in.headers["req"].requestType == RequestTypeEnum.APPLY)
			{
				exchange.in.setHeader('resourceType',exchange.in.headers["req"].requestDetail.resourceType.toString())
				exchange.in.setHeader('submitUser',exchange.in.headers["req"].submitUser.toString())
				if(exchange.in.headers["req"].status == RequestStatusEnum.REJECTED)
				{
					exchange.getIn().setHeader("CamelVelocityResourceUri","template/resource_apply_rejected.vm")
				}else{
					exchange.getIn().setHeader("CamelVelocityResourceUri","template/resource_apply_approval.vm")
				}
			}
			else if(exchange.in.headers["req"].requestType == RequestTypeEnum.TRANSFER)
			{
				if(exchange.in.headers["req"].status == RequestStatusEnum.REJECTED)
				{
					exchange.getIn().setHeader("CamelVelocityResourceUri","template/resource_transfer_rejected.vm")
				}else{
					exchange.getIn().setHeader("CamelVelocityResourceUri","template/resource_transfer_approval.vm")
				}
			}
			exchange.getIn().setBody(null)
        }
		.to("velocity:dummy").process{ Exchange exchange ->
			String content =  exchange.getIn().getBody(String.class)
			int startIndex = content.indexOf("<title>")
			int endIndex = content.indexOf("</title>")
			exchange.getIn().setHeader("subject",content.substring(startIndex + 7, endIndex))
		}
    	.to('bean://notificationService?method=persistNotification')
	}
}