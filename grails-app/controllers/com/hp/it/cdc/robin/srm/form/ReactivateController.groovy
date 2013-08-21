package com.hp.it.cdc.robin.srm.form

import com.grailsrocks.emailconfirmation.EmailConfirmationService

import com.hp.it.cdc.robin.hpdata.ldap.ILdapLookupService
import com.hp.it.cdc.robin.hpdata.ldap.impl.LdapLookupService
import com.hp.it.cdc.robin.srm.domain.User;
import com.hp.it.cdc.robin.srm.constant.RoleEnum
import com.hp.it.cdc.robin.srm.constant.UserStatusEnum
import com.hp.it.cdc.robin.srm.domain.SrmPendingEmailConfirmation
import org.apache.commons.validator.EmailValidator
import com.hp.it.cdc.robin.srm.domain.SystemProperty

class ReactivateController {
	
	def emailConfirmService
	
	def jcaptchaService
	
	transient springSecurityService

    def index() { }
	
	def active() {
		log.info params
		render params.id	
		def callbackHit = false
		def pending = SrmPendingEmailConfirmation.findByConfirmationToken(params.id)
				
		if (pending == null){
			log.debug "pending email confirmation can not found!"
			redirect(uri:'/reactivate/reactivate_notoken')
			return
		}
		
		emailConfirmService.metaClass.event = { String topic, data ->
			fail "Should never call this event variant"
		}
		emailConfirmService.metaClass.event = { Map args ->
			//update the user to valid if topic is confirmed
			if (args.topic == "signupConfirmation.confirmed"){
				def user = User.findByUserBusinessInfo2(args.data.email)
				if (user == null){
					log.debug "user is not found!"
					flash.errorMsg = message(code: 'reactivate.failure.user.notFound', args: [pending.emailAddress])
					return [value:[action:'reactivate_failure']]
				}
				if (user.status.equals(UserStatusEnum.REMOVED)){
					log.debug "user status is removed!"
					flash.errorMsg = message(code: 'reactivate.failure.status.removed', args: [user.userBusinessInfo2])
					return [value:[action:'reactivate_failure']]
				}
				user.status = UserStatusEnum.ACTIVE
				user.password = pending.pendingPassword
				user.save(flush:true)
				log.debug 'save user...'
			}
			callbackHit = true
			
			return [value:[controller:'signin', action:'index']]
			
		}
		def res = emailConfirmService.checkConfirmation(pending.confirmationToken)
		if (!callbackHit){
			flash.message = pending.emailAddress
			redirect(uri:'/reactivate/reactivate_failure')
			return
		}
		redirect(uri:'/')
	}
	
	def reactivate_failure(){
		
	}
	
	def reactivate_success(){
		
	}
	
	def reactivate_notoken(){
		
	}
}
