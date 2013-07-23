package com.hp.it.cdc.robin.srm.form

import com.hp.it.cdc.robin.hpdata.ldap.ILdapLookupService
import com.hp.it.cdc.robin.hpdata.ldap.impl.LdapLookupService
import com.hp.it.cdc.robin.srm.domain.SrmPendingEmailConfirmation
import com.hp.it.cdc.robin.srm.domain.User
import com.hp.it.cdc.robin.srm.constant.RoleEnum
import com.hp.it.cdc.robin.srm.constant.UserStatusEnum
import org.apache.commons.validator.EmailValidator
import com.hp.it.cdc.robin.srm.domain.SystemProperty

class SignupController {
	
	transient emailConfirmService
	
	transient jcaptchaService
	
	transient springSecurityService

	def index(){
		
	}
	
	def authenticate(){
		log.info params
		String email = params.userBusinessInfo2 
		String password = params.password
		
		EmailValidator emailValidator = EmailValidator.getInstance()
		if (!emailValidator.isValid(email)){
			flash.message = message(code: "email.verify.msg1")
			redirect(uri:'/')
			return
		}else{
			if (!email.endsWith("@hp.com")){
				flash.message = message(code: "email.verify.msg2")
				redirect(uri:'/')
				return
			}
		}
		
		def person = null
		try{
			person = getPersonSummaryFromLdap(email)
		}catch(Exception e){
			log.error e
			flash.message = message(code: "email.verify.ldap")
			redirect(uri:'/')
			return
		}
		if (person == null){
			flash.message = message(code: "email.verify.msg3", args: [email])
			redirect(uri:'/')
			return
		}
		if (password==null ||password.trim().length()<6){
			flash.message = message(code: "password.verify.msg")
			redirect(uri:'/signup/index')
			return;
		}
		
		//check verification code
		if (!jcaptchaService.validateResponse("imageCaptcha", session.id, params.captchaResponse))
		{
			flash.message = message(code: "code.verify.msg")
			redirect(uri:'/')
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
			log.error 'Send email to ['+email+'] Faild, root cause : '+e.getMessage() + "\n"+e
		}
		flash.message = email
		if (pending == null){
			redirect(uri:'/reactivate/reactivate_failure')
			return
		}
		redirect(uri: "/signup/count_down")
	}
	
	def count_down(){
	}
	
	def static getPersonSummaryFromLdap(String email){
		ILdapLookupService ladp = new LdapLookupService()
		def person = null
		try{
			person = ladp.getPersonSummaryByEmail(email)
		}catch(Exception e){
			return null
		}
		return person
	}
}
