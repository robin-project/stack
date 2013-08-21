package com.hp.it.cdc.robin.srm.service

import com.hp.it.cdc.robin.srm.constant.IssueTypeEnum
import com.hp.it.cdc.robin.srm.constant.ResourceStatusEnum
import com.hp.it.cdc.robin.srm.constant.UserStatusEnum
import com.hp.it.cdc.robin.srm.domain.Issue
import com.hp.it.cdc.robin.srm.domain.Resource
import com.hp.it.cdc.robin.srm.domain.User

class FindIssueService {

    def service() {
		cleanExistingIssues()
		findIsolatedResources()
		//findActiveUserHavingNoResource()
    }
	
	def cleanExistingIssues(){
		Issue.deleteAll()
	}
	def findActiveUserHavingNoResource(){
		log.info "=======================Find active user having no resource======================="
		
		def allocatedUsers= Resource.findAllByStatus(ResourceStatusEnum.ALLOCATED).currentUser.userBusinessInfo1.unique()

		def search= User.createCriteria()
		def users= search.list{
			not {'in'("userBusinessInfo1",allocatedUsers)}
			eq("status",UserStatusEnum.ACTIVE)
			lt("dateCreated",new Date(new Date().getTime()-5*24*60*60*1000)) //created more than 5 days
		}
		
		
		users.remove(User.first())

		users.each{
			try{
				log.info "No resource found for user "+ it.userBusinessInfo1+"," + it.userBusinessInfo2+","+ it.userBusinessInfo3
				new Issue(issueType:IssueTypeEnum.NoResourceFound,
				detail: "User "+ it.userBusinessInfo1+"," 
				+ it.userBusinessInfo2+", "
				+ it.userBusinessInfo3+" has no resource").save()
			}catch(Exception e){
				log.error e
			}
		}
		log.info "=======================END Find active user having no resource======================="
		
	}
	
	def findIsolatedResources(){
		log.info "=======================Find isolated resource======================="
		def removedUsers = User.findAllByStatus(UserStatusEnum.REMOVED)
		removedUsers.each{
			def isolatedResources = Resource.findAllByCurrentUser(it)
			if (isolatedResources.size()>0){
				try{
					log.info "Isolated Resources for user:" + it.userBusinessInfo1+"," + it.userBusinessInfo2+","+ it.userBusinessInfo3
					new Issue(issueType:IssueTypeEnum.IsolatedResources,
					detail: "User "+ user.userBusinessInfo1+", "
					+ user.userBusinessInfo2+", "
					+ user.userBusinessInfo3+" is removed, but isolated resources found under his/her name:"+isolatedResources).save()
				}catch(Exception e){
					log.error e
				}
			}
		}
		log.info "=======================END Find isolated resource======================="
	}

}
