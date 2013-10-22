import com.hp.it.cdc.robin.srm.constant.RoleEnum
import com.hp.it.cdc.robin.srm.constant.UserStatusEnum
import com.hp.it.cdc.robin.srm.constant.CurrencyEnum
import com.hp.it.cdc.robin.srm.domain.Issue
import com.hp.it.cdc.robin.srm.domain.ResourceApprovalWorkflow
import com.hp.it.cdc.robin.srm.domain.ResourceType
import com.hp.it.cdc.robin.srm.domain.Step
import com.hp.it.cdc.robin.srm.domain.SystemProperty
import com.hp.it.cdc.robin.srm.domain.User
import com.hp.it.cdc.robin.srm.domain.ConversionRate

import com.mongodb.Mongo
import com.mongodb.gridfs.GridFS
import com.mongodb.gridfs.GridFSDBFile
import com.mongodb.gridfs.GridFSInputFile

class BootStrap {
	def grailsApplication

	def init = { servletContext ->
		println "start bootstraping, check stacktrace.log for details..."
		if(!User.count()) {
			new User(password:"23wesdxc",
				userBusinessInfo1:"00647651",userBusinessInfo2:"wen-binw@hp.com",userBusinessInfo3:"Wen-Bin,Wang",
				status:UserStatusEnum.ACTIVE, role:RoleEnum.RESOURCE_MANAGER,userApprovalPreferences:"blabla").save(flush:true)

			new User(password:"23wesdxc",
				userBusinessInfo1:"21980082",userBusinessInfo2:"pxie@hp.com",userBusinessInfo3:"Pei-Pei,Xie",
				status:UserStatusEnum.ACTIVE, role:RoleEnum.PRIMARY_ADMIN,userApprovalPreferences:"blabla").save(flush:true)

			new User(password:"23wesdxc",
				userBusinessInfo1:"00000000",userBusinessInfo2:"srm.admin@hp.com",userBusinessInfo3:"Jesus,God",
				status:UserStatusEnum.ACTIVE, role:RoleEnum.ADMIN,userApprovalPreferences:"blabla").save(flush:true)

			def user_list = [
					[name:"Ting Jiang", email:"tingj@hp.com", id:"21932182"],
					[name:"Li-Peng Zhu", email:"li-peng.zhu@hp.com", id:"21879109"],
					[name:"Da Zhang", email:"da.zhang@hp.com", id:"21929675"],
					[name:"Cheng Zhong", email:"czhong@hp.com", id:"21669898"],
                    [name:"Yang Chen", email:"yang.chen@hp.com", id:"20154734"],
                    [name:"Manhong Yang", email:"manhong.yang@hp.com", id:"20036255"],
                    [name:"Shi Li", email:"shi.li@hp.com", id:"00645948"]					
				]
			
			user_list.each{
				new User(password:"23wesdxc",
				userBusinessInfo1:it.id,userBusinessInfo2:it.email,userBusinessInfo3:it.name,
				status:UserStatusEnum.ACTIVE, role:RoleEnum.USER,userApprovalPreferences:"blabla").save(flush:true)
			}			
		}
		if(!ResourceType.count()) {
			new ResourceType(model:'test', resourceTypeName:'Mouse',supplier:'HP', productNr:'',latestUnitPriceInRmb:10).save(flush:true)
		}
		if(!ConversionRate.count()) {
			new ConversionRate(currency:CurrencyEnum.USD, rateToRmb:6.13).save(flush:true)
		}
		// if(!Issue.count()) {
		// 	for(int i=0; i<50;i++){
		// 		new Issue(issueType:com.hp.it.cdc.robin.srm.constant.IssueTypeEnum.IsolatedResources,detail:i+" blablah fake isolated devices.....................................").save()
		// 	}
		// }
        if(!SystemProperty.count()){
            def step1 = new Step(stepType:"actionUserRole",stepValue:"PRIMARY_ADMIN")
            def step2 = new Step(stepType:"treeLevel",stepValue:"1")
            def step3 = new Step(stepType:"treeLevel",stepValue:"2")
            def step4 = new Step(stepType:"actionUserRole",stepValue:"RESOURCE_MANAGER")

            def workflow1 = new ResourceApprovalWorkflow(range:"6000",stepCount:6, currency:CurrencyEnum.RMB)
            workflow1.addToWorkFlowStep(step1).addToWorkFlowStep(step2).addToWorkFlowStep(step3).addToWorkFlowStep(step4)

            def workflow2 = new ResourceApprovalWorkflow(range:"60-6000",stepCount:4, currency:CurrencyEnum.RMB)
            workflow2.addToWorkFlowStep(step1).addToWorkFlowStep(step2)
            
            def workflow3 = new ResourceApprovalWorkflow(range:"0-60",stepCount:2, currency:CurrencyEnum.RMB)

            def systemProperty = new SystemProperty(
                    treelevelTopUserBusinessInfo1:"shi.li@hp.com",
					userStaleDays:Integer.valueOf(2),
					emailFrom:"stack-system@hp.com",
					eachResourcePageCount: 100,
					userGuideUrl:"http://cdc-operation-aries.asiapacific.hpqcorp.net/stack/userguide.ppt")

            systemProperty.addToResourceApprovalWorkflow(workflow1).addToResourceApprovalWorkflow(workflow2).addToResourceApprovalWorkflow(workflow3)
            systemProperty.save(flush:true)

			/*add default image*/
            def mongoSettings = grailsApplication.config.mongo
			Mongo mongo = new Mongo(mongoSettings.host, mongoSettings.port.intValue())
			def db = mongo.getDB(mongoSettings.databaseName)
			def gridfs = new GridFS(db,mongoSettings.bucket)

			def file = new File("web-app/images/noImageAvailable.JPG")
			GridFSInputFile gfsFile = gridfs.createFile(file.getBytes());
			gfsFile.setContentType("image/jpeg")
			gfsFile.setFilename("default_image");
			gfsFile.save();
        }
	}
	def destroy = {
	}
}
