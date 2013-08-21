package stack
import com.hp.it.cdc.robin.srm.domain.UserActivityLog


class TracerService {

    def addUserActivity(UserActivityLog activity) {
		sendMessage("seda:user_activities",activity)
    }
}
