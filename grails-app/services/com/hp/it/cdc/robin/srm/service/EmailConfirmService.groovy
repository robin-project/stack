package com.hp.it.cdc.robin.srm.service

import java.util.Map;

import org.springframework.transaction.annotation.Transactional;
import com.grailsrocks.emailconfirmation.EmailConfirmationService
import com.hp.it.cdc.robin.srm.domain.SrmPendingEmailConfirmation
import com.hp.it.cdc.robin.srm.domain.Resource

class EmailConfirmService extends EmailConfirmationService{

	@Transactional
	def sendConfirmation(Map args) {
		if (log.infoEnabled) {
			log.info "Sending email confirmation mail to ${args.to}, callback events will be prefixed with " +
					 "[${args.event ? args.event+'.' : ''}] in namespace [${args.eventNamespace ?: EVENT_NAMESPACE}], user data is [${args.id}])"
		}
		
		def conf = new SrmPendingEmailConfirmation(
			emailAddress:args.to,
			userToken:args.id,
			confirmationEvent:makeConfirmationEventString(args),
			pendingPassword: args.pendingPassword)
		makeToken(conf)
		
		if (log.debugEnabled) {
			log.debug "Created email confirmation token [${conf.confirmationToken}] for mail to ${conf.emailAddress}"
		}
		if (!conf.save()) {
			throw new IllegalArgumentException( "Unable to save pending confirmation: ${conf.errors}")
		}
		//remove the old pending confirmation email
		def srmPendings = SrmPendingEmailConfirmation.findAllByEmailAddress(args.to)
		if (srmPendings){
			srmPendings.each {
				SrmPendingEmailConfirmation srmPending = it
				if (srmPending.id != conf.id){
					log.info "Remove the old pending confirmation id [${srmPending.id}]"
					srmPending.delete()
				}
			}
		}
		def binding = args.model ? new HashMap(args.model) : [:]
	
		binding['uri'] = makeURL(conf.confirmationToken)

		if (log.infoEnabled) {
			log.info( "Sending email confirmation mail to $args.to - confirmation link is: ${binding.uri}")
		}
		
		def defaultView = args.view == null
		def viewName = defaultView ? "/emailConfirmation/mail/confirmationRequest" : args.view
		def pluginName = defaultView ? "email-confirmation" : args.plugin

		try {
			mailService.sendMail {
				to args.to
				from args.from ?: pluginConfig.from
				subject args.subject
				def bodyArgs = [view:viewName, model:binding]
				if (pluginName) {
					bodyArgs.plugin = pluginName
				}
				body( bodyArgs)
			}
		} catch (Throwable t) {
			log.warn "Mail sending failed but you're in development mode so I'm ignoring this fact, you can confirm using this link: ${binding.uri}"
			log.error "Mail send failed", t
			throw t
		}
		return conf
	}
	
    @Transactional
	def checkConfirmation(String confirmationToken) {
		if (log.traceEnabled) {
            log.trace("checkConfirmation looking for confirmation token: $confirmationToken")
        }

		def conf
        if (confirmationToken) {
            conf = SrmPendingEmailConfirmation.findByConfirmationToken(confirmationToken)
        }

		if (conf && (conf.confirmationToken == confirmationToken)) {
			if (log.debugEnabled) {
				log.debug( "Notifying application of valid email confirmation for user token ${conf.userToken}, email ${conf.emailAddress}")
			}
			def result = fireEvent(EVENT_TYPE_CONFIRMED, conf.confirmationEvent, [email:conf.emailAddress, id:conf.userToken], {
                onConfirmation?.clone().call(conf.emailAddress, conf.userToken)					    
			})
			
			conf.delete()
			return [valid: true, actionToTake:result, email: conf.emailAddress, token:conf.userToken]
		} else {
			if (log.traceEnabled) {
			    log.trace("checkConfirmation did not find confirmation token: $confirmationToken")
		    }
			def result = fireEvent(EVENT_TYPE_INVALID, null, [token:confirmationToken], {
                onInvalid?.clone().call(confirmationToken)					    
			})
			
			return [valid:false, actionToTake:result]
		}
	}
}
