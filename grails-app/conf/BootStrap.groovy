import com.hp.it.cdc.robin.srm.constant.RoleEnum
import com.hp.it.cdc.robin.srm.constant.UserStatusEnum
import com.hp.it.cdc.robin.srm.domain.Issue
import com.hp.it.cdc.robin.srm.domain.ResourceApprovalWorkflow
import com.hp.it.cdc.robin.srm.domain.ResourceType
import com.hp.it.cdc.robin.srm.domain.Step
import com.hp.it.cdc.robin.srm.domain.SystemProperty
import com.hp.it.cdc.robin.srm.domain.User

import com.mongodb.Mongo
import com.mongodb.gridfs.GridFS
import com.mongodb.gridfs.GridFSDBFile
import com.mongodb.gridfs.GridFSInputFile

class BootStrap {
	def grailsApplication

	def init = { servletContext ->
		if(!User.count()) {
			def user_list = [
					[name:"Jesus,God", email:"srm.admin@hp.com", id:"00000000"],
					[name:"Wen-Qin,Song", email:"wenqin.song@hp.com", id:"20184323"],
					[name:"Ting,Jiang", email:"tingj@hp.com", id:"21932182"],
					[name:"Li-Peng,Zhu", email:"li-peng.zhu@hp.com", id:"21879109"],
					[name:"Da,Zhang", email:"da.zhang@hp.com", id:"21929675"],
					[name:"Cheng,Zhong", email:"czhong@hp.com", id:"21669898"],
                    [name:"Yang,Chen", email:"yang.chen@hp.com", id:"20154734"],
                    [name:"Manhong,Yang", email:"manhong.yang@hp.com", id:"20036255"],
                    [name:"Pei-Pei,Xie", email:"pei-pei.xie@hp.com", id:"21348853"],
                    [name:"Wen-Bin,Wang", email:"wen-binw@hp.com", id:"00647651"],
					[name:"Tao,Chen", email:"tao.chen@hp.com", id:"20154508"],
					[name:"Xue-Tao,Wang", email:"xue-taow@hp.com", id:"20147837"],
                    [name:"Li,Shi", email:"shi.li@hp.com", id:"00645948"],
					[name:"Remove Me", email:"srm.remove@hp.com", id:"00000001"]
				]
			
			user_list.each{
				new User(password:"12qwaszx",
				userBusinessInfo1:it.id,userBusinessInfo2:it.email,userBusinessInfo3:it.name,
				status:UserStatusEnum.ACTIVE, role:RoleEnum.ADMIN,userApprovalPreferences:"blabla").save()
			}
		}
		if(!ResourceType.count()) {
			new ResourceType(model:'ProBook 6555b', resourceTypeName:'Laptop',supplier:'HP', productNr:'PRO8888').save()
			new ResourceType(model:'ProBook 8440b', resourceTypeName:'Laptop',supplier:'HP', productNr:'PRO8NEX8').save()
		}
		if(!Issue.count()) {
			for(int i=0; i<50;i++){
				new Issue(issueType:com.hp.it.cdc.robin.srm.constant.IssueTypeEnum.IsolatedResources,detail:i+" blablah fake isolated devices.....................................").save()
			}
		}
        if(!SystemProperty.count()){
            def step1 = new Step(stepType:"actionUserBusinessInfo1",stepValue:"21348853")
            def step2 = new Step(stepType:"treeLevel",stepValue:"1")
            def step3 = new Step(stepType:"treeLevel",stepValue:"2")
            def step4 = new Step(stepType:"actionUserBusinessInfo1",stepValue:"00647651")
            def workflow1 = new ResourceApprovalWorkflow(stepCount:6)
            workflow1.addToWorkFlowStep(step1).addToWorkFlowStep(step2).addToWorkFlowStep(step3).addToWorkFlowStep(step4)
            def systemProperty1 = new SystemProperty(
            		identifier:"platinum",
                    logoImageUrl:"http://logoImageUrl.com",
                    faviconUrl:"http://faviconUrl.com",
                    resourceApprovalWorkflow:workflow1,
                    treelevelTopUserBusinessInfo1:"shi.li@hp.com",
					systemAdminUserBusinessInfo1:"srm.admin@hp.com",
					userStaleDays:Integer.valueOf(2),
					emailFrom:"stack-system@hp.com",
					eachResourcePageCount: 100)
            systemProperty1.save(flush:true)

            def workflow2 = new ResourceApprovalWorkflow(stepCount:4)
            workflow2.addToWorkFlowStep(step1).addToWorkFlowStep(step2)
            def systemProperty2 = new SystemProperty(
            		identifier:"iridium",
                    logoImageUrl:"http://logoImageUrl.com",
                    faviconUrl:"http://faviconUrl.com",
                    resourceApprovalWorkflow:workflow2,
                    treelevelTopUserBusinessInfo1:"shi.li@hp.com",
					systemAdminUserBusinessInfo1:"srm.admin@hp.com",
					userStaleDays:Integer.valueOf(2),
					emailFrom:"stack-system@hp.com",
					eachResourcePageCount: 100)
            systemProperty2.save(flush:true)

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
