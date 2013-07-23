package srm.web

import com.hp.it.cdc.robin.srm.domain.JobLog



class RequestCleanJob {
    def NAME = "RequestCleanJob"
    def concurrent =false
	transient requestService
    static triggers = {
         //simple startDelay:1000*60*20, repeatInterval: 1000*60*60*4, repeatCount: 0 
         cron cronExpression: '* * 12/12 * * ?' 
    }

	def execute() {
		if (null==JobLog.findByJobNameAndDateCreatedGreaterThan(NAME,new Date(new Date().getTime()-8*60*60*1000))){
			requestService.service()
			new JobLog(jobName:NAME).save(flush:true)
		}
	}
}
