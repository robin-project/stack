package com.hp.it.cdc.robin.srm.form

import java.security.cert.CertificateFactory
import java.security.cert.X509Certificate

import javax.servlet.http.HttpServletRequest

import org.apache.commons.validator.EmailValidator
import org.springframework.web.context.request.RequestContextHolder
import org.springframework.web.context.request.ServletRequestAttributes

import com.hp.it.cdc.robin.srm.constant.UserStatusEnum
import com.hp.it.cdc.robin.srm.domain.User

class SigninController {

	transient springSecurityService
	def authenticateService
	def x509Service

	def index() {

		redirect(uri:'/')
	}

	def login(){
		String email = params.userBusinessInfo2.toLowerCase()
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

		if (password==null ||password.trim().length()<6){
			flash.message = message(code: "password.verify.msg")
			redirect(uri:'/')
			return;
		}

		//check if the email and password and active
		def user = User.findByUserBusinessInfo2(email);

		if (user == null){
			flash.message = message(code: "signin.email.invalid")
			redirect(uri:'/')
			return
		}
		if (user.status!=UserStatusEnum.ACTIVE){
			flash.message = message(code: "signin.isvalid.msg")
			redirect(uri:'/')
			return
		}
		if (user.password != springSecurityService.encodePassword(password.trim())){
			flash.message = message(code: "signin.password.invalid")
			redirect(uri:'/')
			return
		}

		session.setAttribute("user", user);
		redirect(uri:'/common/index')
	}


	def loginWithDb(){
		X509Certificate[] certificates = (X509Certificate[]) request.getAttribute("javax.servlet.request.X509Certificate");

		boolean istrust = false
		String email

		//		TrustManagerFactory factory = TrustManagerFactory.getInstance("X509");
		//		KeyStore ks = KeyStore.getInstance("PKCS12");
		//		ks.load(getClass().getResourceAsStream("ssl/keystore"), "password".toCharArray());
		//		factory.init(ks);
		//
		//		for (TrustManager tm: factory.getTrustManagers()){
		//			if (tm instanceof X509TrustManager){
		//				try{
		//					tm.checkClientTrusted((X509Certificate[])certificates, "RSA");
		//					istrust=true
		//				}catch(Exception e){
		//					log.error e
		//				}
		//			}
		//		}

		istrust=true // to remove this
		certificates.each {
			if(x509Service.validate(it,grailsApplication.config.cacertpath)){
				log.info it.subjectX500Principal.toString()
				//2013-07-18 16:17:53,831 [http-8443-1] INFO  form.SigninController  - EMAILADDRESS=wenqin.song@hp.com, CN=Wen-Qin Song, OU=WEB, O=Hewlett-Packard Company
				email = it.subjectX500Principal.toString().find(/EMAILADDRESS=(\w)*(.)*(-)*hp.com/).replace("EMAILADDRESS=", "")
				//			log.info "issuer DN: " + it.issuerX500Principal.name
				//			log.info "subject DN: " + it.subjectX500Principal.name
				//			log.info "validity: " + it.notAfter
				//			log.info "serial number: " +it.serialNumber
				//			log.info "version: " + it.version
			}
		}

		if (email == null){
			flash.message = message(code: "signin.email.invalid")
			redirect(uri:'/')
			return
		}else{
			log.info "login with:" + email
		}

		def user = User.findByUserBusinessInfo2(email)
		log.info user

		if (user == null){
			flash.message = message(code: "signin.email.invalid")
			redirect(uri:'/')
			return
		}
		if (user.status!=UserStatusEnum.ACTIVE){
			flash.message = message(code: "signin.isvalid.msg")
			redirect(uri:'/')
			return
		}

		session.setAttribute("user", user);
		if (istrust){
			redirect(uri:'/common/index')
		}else{
			flash.message = message(code: "signin.email.invalid")
			redirect(uri:'/')
			return
		}
	}


}
