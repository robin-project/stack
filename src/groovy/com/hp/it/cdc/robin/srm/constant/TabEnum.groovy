package com.hp.it.cdc.robin.srm.constant

enum TabEnum {

	TAB_ADMIN_ALLOCATE_RESOURCES(10001, "tab.allocate.resources.label"),
	TAB_ADMIN_RETURN_RESOURCES(10002, "tab.return.resources.label"),
	TAB_ADMIN_ADD_RESOURCES(10003, "tab.add.resources.label"),
	TAB_ADMIN_QUERY_RESOURCES(10004, "tab.query.resources.label"),
	TAB_ADMIN_ISSUES(10005, "tab.issues.label"),
	TAB_ADMIN_MANAGE_USERS(10006, "tab.manage.user.label"),
	TAB_ADMIN_REPORTS(10007, "tab.reports.label"),
	
	TAB_USER_MY_RESOURCES(20001, "tab.my.resources.label"),
	TAB_USER_MY_REQUESTS(20002, "tab.my.requests.label"),
	TAB_USER_MY_APPROVALS(20003, "tab.my.approvals.label")
	
	TabEnum(Integer tabId, String tabLabelCode){
		this.tabId=tabId
		this.tabLabelCode=tabLabelCode
	}
	
	Integer tabId
	String tabLabelCode
}
