package com.hp.it.cdc.robin.srm.service

import java.security.PublicKey
import java.security.cert.Certificate
import java.security.cert.CertificateExpiredException
import java.security.cert.CertificateFactory
import java.security.cert.CertificateNotYetValidException
import java.security.cert.X509Certificate

class X509Service {
	static PublicKey _pbk


	boolean validate(Certificate clientCertificate, String certPath) {
		if (_pbk == null){
			CertificateFactory cf=CertificateFactory.getInstance("X.509")
			FileInputStream in2=new FileInputStream(certPath)
			Certificate caCert=cf.generateCertificate(in2)
			_pbk=caCert.getPublicKey()
			if (_pbk == null) return false
		}

		try{
			clientCertificate.verify(_pbk)
			log.info "public key trusted"
		}catch(Exception e){
			log.error e
			return false;
		}


		try{
			((X509Certificate)clientCertificate).checkValidity(new Date());
		}catch(CertificateExpiredException e){ 
			log.error "Certificate Expired"
		}catch(CertificateNotYetValidException e){ 
			log.error "Certificate not valid yet"
	    }
		return true;
	}
}
