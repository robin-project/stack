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
	
	def reactive(){
		log.info params
		String email = params.userBusinessInfo2
		String password = params.password
		
		EmailValidator emailValidator = EmailValidator.getInstance()
		if (!emailValidator.isValid(email)){
			flash.message = message(code: "email.verify.msg1")
			redirect(uri:'/reactivate/index')
			return
		}else{
			if (!email.endsWith("@hp.com")){
				flash.message = message(code: "email.verify.msg2")
				redirect(uri:'/reactivate/index')
				return
			}
		}
		def person = SignupController.getPersonSummaryFromLdap(email)
		if (person == null){
			flash.message = message(code: "email.verify.msg3", args: [email])
			redirect(uri:'/reactivate/index')
			return
		}
		if (password==null ||password.trim().length()<6){
			flash.message = message(code: "password.verify.msg")
			redirect(uri:'/reactivate/index')
			return;
		}
		if (!jcaptchaService.validateResponse("imageCaptcha", session.id, params.captchaResponse))
		{
			flash.message = message(code: "code.verify.msg")
			redirect(uri:'/reactivate/index')
			return;
		}
		
		//find if the user exists
		def user = User.findByUserBusinessInfo2(email)
		//create or update user by email and password
		if (user == null){
			user = new User()
			user.password = password.trim()
			user.userBusinessInfo2 = email
			user.status = UserStatusEnum.INACTIVE
			user.role = RoleEnum.USER
		}
		//if EID and FullName is the same as LDAP, mark the last validated time to now
		if (person.employeeNr.equals(user.userBusinessInfo1) && person.fullName.equals(user.userBusinessInfo3)){
			user.lastValidateTs = new Date()
		}else{
			//update EID and fullName if not same as LDAP
			user.userBusinessInfo1 = person.employeeNr
			user.userBusinessInfo3 = person.fullName
		}
		if (!user.save(flush:true)){
			throw new IllegalArgumentException( "Unable to save User.....")
		}
		// Send email confirmation
		def pendPwd = springSecurityService.encodePassword(password.trim())
		def pending = null
		try{
			pending = emailConfirmService.sendConfirmation(
			from:SystemProperty.first().emailFrom,
			to:email,
			subject:message(code: "email.confirm.subject"),
			id:"@@"+email+"_Token@@",
			event:"signupConfirmation",
			namespace:"plugin.emailConfirmation",
			pendingPassword: pendPwd)
		}catch(Exception e){
			log.error 'Send email to ['+email+'] Faild, root cause : '+e.getMessage()
		}
		flash.message = email
		if (pending == null){
			redirect(uri:'/reactivate/reactivate_failure')
			return
		}
		redirect(uri: "/signup/count_down")
	}
	
	def active() {
		log.info params
		render params.id	
		def callbackHit = false
		def pending = SrmPendingEmailConfirmation.findByConfirmationToken(params.id)
				
		if (pending == null){
			redirect(uri:'/reactivate/reactivate_notoken')
			return
		}
		
		def person = null
		try{
			person = SignupController.getPersonSummaryFromLdap(pending.emailAddress)
		}catch(Exception e){
			log.error e
			redirect(uri:'/reactivate/reactivate_failure')
			return
		}
		if (person == null){
			redirect(uri:'/reactivate/reactivate_failure')
			return
		}
		
		emailConfirmService.metaClass.event = { String topic, data ->
			fail "Should never call this event variant"
		}
		emailConfirmService.metaClass.event = { Map args ->
			//update the user to valid if topic is confirmed
			println "args============"+args
			if (args.topic == "signupConfirmation.confirmed"){
				def user = User.findByUserBusinessInfo2(args.data.email)
				if (user == null){
					redirect(uri:'/reactivate/reactivate_notoken')
					return
				}
				user.status = UserStatusEnum.ACTIVE
				user.password = pending.pendingPassword
				//update the EID and FullName
				user.userBusinessInfo1 = person.employeeNr
				user.userBusinessInfo3 = person.fullName
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
		redirect(uri:'/signin/index')
	}
	
	def reactivate_failure(){
		
	}
	
	def reactivate_success(){
		
	}
	
	def reactivate_notoken(){
		
	}
}
