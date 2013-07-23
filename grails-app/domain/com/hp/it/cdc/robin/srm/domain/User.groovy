package com.hp.it.cdc.robin.srm.domain

import com.hp.it.cdc.robin.srm.constant.RoleEnum
import com.hp.it.cdc.robin.srm.constant.UserStatusEnum
import org.bson.types.ObjectId

class User implements Serializable{
	
	ObjectId id
	transient springSecurityService
	
	String password
	String userBusinessInfo1 //EmployeeID
	String userBusinessInfo2 //Email
	String userBusinessInfo3 //firstName LastName from LDAP
	User manager
    Date lastValidateTs = new Date()
	UserStatusEnum status
	RoleEnum role
	String userApprovalPreferences
	
	Date dateCreated
	Date lastUpdated
	
    static constraints = {
		manager nullable:true
		userBusinessInfo1 matches: "[0-9]+", unique:true
		userBusinessInfo2 email:true, unique:true
		userApprovalPreferences nullable:true
		password nullable:true, minLenght: 6, matches: /^[\d\p{L}]*$/
    }
	
	static mapping = {
		password column: '`password`'
	}
	
	def beforeInsert() {
		encodePassword()
	}
	
	def beforeUpdate() {
	}
	
	protected void encodePassword() {
		password = springSecurityService.encodePassword(password)
	}
		
	String toString(){
		return userBusinessInfo1 + " "+userBusinessInfo2 + " "+userBusinessInfo3
	}
}

class UserApprovalPreferences {
	String description
	static constraints = {
	}
}

