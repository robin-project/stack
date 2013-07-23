package srm.web

import com.hp.it.cdc.robin.srm.domain.JobLog

class IssueDetectJob {
	def NAME = "IssueDetectJob"
	def concurrent =false
	transient findIssueService
	
    static triggers = {
	  //simple startDelay:1000*60*30, repeatInterval: 1000*60*60*8, repeatCount: 0
	  cron cronExpression: '* * 9/12 * * ?'
    }

    def execute() {
		if (null==JobLog.findByJobNameAndDateCreatedGreaterThan(NAME,new Date(new Date().getTime()-8*60*60*1000))){
			findIssueService.service()
			new JobLog(jobName:NAME).save(flush:true)
		}
    }
}
