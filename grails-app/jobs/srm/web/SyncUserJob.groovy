package srm.web

import com.hp.it.cdc.robin.hpdata.ldap.PersonSummary
import com.hp.it.cdc.robin.hpdata.ldap.impl.LdapLookupService
import com.hp.it.cdc.robin.srm.constant.*
import com.hp.it.cdc.robin.srm.domain.*

class SyncUserJob {
	def NAME = "SyncUserJob"
	def concurrent =false
	transient validateUserService
    static triggers = {
         //simple startDelay:1000*60*1, repeatInterval: 1000*60*60*4, repeatCount: 0 
         cron cronExpression: '* * 8/4 * * ?' 
    }

	def execute() {
		
		if (null==JobLog.findByJobNameAndDateCreatedGreaterThan(NAME,new Date(new Date().getTime()-8*60*60*1000))){
			validateUserService.service()
			new JobLog(jobName:NAME).save(flush:true)
		}
	}

}
