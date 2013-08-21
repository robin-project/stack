import org.apache.camel.builder.*
import org.apache.camel.*

import org.apache.camel.builder.RouteBuilder

class TracerRoute extends RouteBuilder {
	def grailsApplication

    @Override
    void configure() {
		def config = grailsApplication?.config

		def user_activities_queue = new java.util.concurrent.LinkedBlockingQueue()

        from('seda:user_activities').process{ Exchange exchange ->
            user_activities_queue.add(exchange.getIn().getBody())
        }

        from('timer://user_activities_cache?fixedRate=true&period=180000&delay=180000').process{
            (1..user_activities_queue.size()).each{
        	   user_activities_queue.poll()?.save()
            }
        }
    }
}
