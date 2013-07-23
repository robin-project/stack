package com.hp.it.cdc.robin.srm.service

import com.hp.it.cdc.robin.hpdata.ldap.PersonSummary
import com.hp.it.cdc.robin.hpdata.ldap.impl.LdapLookupService
import com.hp.it.cdc.robin.srm.constant.ActivityTypeEnum
import com.hp.it.cdc.robin.srm.constant.RequestStatusEnum
import com.hp.it.cdc.robin.srm.constant.RequestTypeEnum
import com.hp.it.cdc.robin.srm.constant.RoleEnum
import com.hp.it.cdc.robin.srm.constant.UserStatusEnum
import com.hp.it.cdc.robin.srm.domain.Activity
import com.hp.it.cdc.robin.srm.domain.Request
import com.hp.it.cdc.robin.srm.domain.SystemProperty
import com.hp.it.cdc.robin.srm.domain.User

class ValidateUserService {
	static ldap = new LdapLookupService()
	
    def service() {
		syncUser()
		removeStaleUsers()
		closeOpenApplyRequestUnderRemovedUsers()
    }
	
	def closeOpenApplyRequestUnderRemovedUsers(){
		log.info "=======================Close open apply request under removed users======================="
		def removedUsers = User.findAllByStatus(UserStatusEnum.REMOVED)
		log.debug removedUsers
		List results = new ArrayList()
		removedUsers.each{
			def allRequests = Request.findAllBySubmitUserAndRequestType(it,RequestTypeEnum.APPLY)
			for (def req: allRequests){
				if (RequestStatusEnum.CLOSED !=req.status && RequestStatusEnum.REJECTED != req.status){
					log.info "Close open request:"+req.id
					req.status=RequestStatusEnum.CLOSED
					req.addToActivities(new Activity(activityType:ActivityTypeEnum.CLOSED,comment:"close request for user is removed",activityUser:User.findByUserBusinessInfo2(SystemProperty.get(1).systemAdminUserBusinessInfo1)))
					req.save(flush:true)
				}
			}
		}
		log.info "=======================END Close open apply request under removed users======================="
	}
	
	def removeStaleUsers(){
		log.info "=======================Remove stale users======================="
		def staleUsers= User.findAllByLastValidateTsLessThan(new Date(new Date().getTime()-SystemProperty.first().userStaleDays*24*60*60*1000))
		staleUsers.remove(User.first())
		staleUsers.each{
			log.info  "remove user:"+it.id +","+  it.userBusinessInfo1 +","+ it.userBusinessInfo2 +","+ it.userBusinessInfo3
			it.status=UserStatusEnum.REMOVED
			it.save(flush:true)
		}
		log.info "=======================END Remove stale users======================="
	}
	
	def syncUser(){
		log.info "=======================Synchronize User from LDAP======================="
		try
		{
			def personSummary = ldap.getPersonSummaryByEmail(SystemProperty.first().treelevelTopUserBusinessInfo1)
			loopAllUsers(personSummary,1, null)
		}
		catch(Exception e) {
			log.error e
		}
		log.info "=======================END Synchronize User from LDAP======================="
	}

	def loopAllUsers(Object p, int depth, Object manager){
		User newLevel = updateUser(p, depth, manager)
		List<PersonSummary> list = ldap.getEmployeesInManager(p.email)
		for(personSummary in list) {
			loopAllUsers(personSummary, depth+1, newLevel)
		}
	}

	def updateUser(Object p,int depth, Object manager){
		try{
			log.info "    "* depth +"|"+"====" + p.employeeNr +", "+p.email + ", " +p.fullName
			if(p.employeeNr == null) return

			def user = User.findByUserBusinessInfo1(p.employeeNr)
			if (user == null){
				user = new User()
				user.status=UserStatusEnum.INACTIVE
				user.role=RoleEnum.USER
			}else{
				if (user.status==UserStatusEnum.REMOVED){
					user.status=UserStatusEnum.ACTIVE // reactivate user when he comes back to organization
				}
			}
			
			if (manager != null){
				user.manager=manager
			}

			user.lastValidateTs = new Date()
			user.userBusinessInfo1 = p.employeeNr
			user.userBusinessInfo2 = p.email
			user.userBusinessInfo3 = p.fullName
			user.save(flush:true)
			
			return user
		}catch(Exception e){
			log.error e
		}
	}
}
