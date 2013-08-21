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
		String email = params.userBusinessInfo2.toLowerCase()
		String password = params.password
		
		EmailValidator emailValidator = EmailValidator.getInstance()
		if (!emailValidator.isValid(email)){
			log.debug "email format is invalid."
			flash.message = message(code: "email.verify.msg1")
			redirect(uri:'/signup/index')
			return
		}else{
			if (!email.endsWith("@hp.com")){
				log.debug "email format is not ends with @hp.com."
				flash.message = message(code: "email.verify.msg2")
				redirect(uri:'/signup/index')
				return
			}
		}
		if (password==null ||password.trim().length()<6){
			log.debug "password format is invalid."
			flash.message = message(code: "password.verify.msg")
			redirect(uri:'/signup/index')
			return
		}
		
		//check verification code
		if (!jcaptchaService.validateResponse("imageCaptcha", session.id, params.captchaResponse))
		{
			log.debug "verify code is invalid."
			flash.message = message(code: "code.verify.msg")
			redirect(uri:'/signup/index')
			return
		}
		
		//find if the user exists
		def user = User.findByUserBusinessInfo2(email)
		//create or update user by email and password
		if (user == null){
			log.debug "user is not existed!"
			flash.message = message(code: "email.not.exist.msg")
			redirect(uri:'/signup/index')
			return
		}
		if (user.status.equals(UserStatusEnum.REMOVED)){
			log.debug "user status is removed!"
			flash.message = message(code: 'email.not.exist.msg')
			redirect(uri:'/signup/index')
			return
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
			log.debug "send confirmation email to "+email+" is faild!"
			redirect(uri:'/reactivate/reactivate_failure')
			return
		}
		redirect(uri: "/signup/count_down")
	}
	
	def count_down(){
	}
}
