package stack
import com.hp.it.cdc.robin.srm.domain.UserActivityLog
       
class TracerFilters {

    def TracerService tracerService

    def filters = {
        all(controller:'common|admin', action:'.*', regex:true) {
            before = {
                if(session.user){
                    try{
                        def activity = new UserActivityLog(user:session.user)
                        activity['request'] = params
                        tracerService.addUserActivity(activity)
                    }catch(Exception e)
                    {
                        log.error(e)
                    }
                }
            }
            after = { Map model ->

            }
            afterView = { Exception e ->

            }
        }
    }
}
