package com.hp.it.cdc.robin.srm.form

class SignoutController {

    def index() { 
		log.info params
		session.removeAttribute("user")
		redirect(url:"/")
	}
}
