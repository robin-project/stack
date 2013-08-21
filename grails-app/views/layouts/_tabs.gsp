<g:if
	test="${session["user"].role>=com.hp.it.cdc.robin.srm.constant.RoleEnum.ADMIN  && session["view"]=="ADMIN"}">
	<!-- admin menu -->
	<div class="row-fluid">
		<div class="span12">
			<div class="row-fluid">
				<ul class="nav nav-tabs">
					<li id="TAB-10003" class='active'><g:remoteLink action="addResources"
							update="SRM-BODY-CONTENT" after="toggleToTab('TAB-10003')"><i class="icon-edit"></i>&nbsp;
							<g:message code="tab.add.resources.label" default="Add resources" />
						</g:remoteLink></li>
					<li id="TAB-10001"><g:remoteLink
							action="allocateResources" update="SRM-BODY-CONTENT"
							after="toggleToTab('TAB-10001')"><i class="icon-share"></i>&nbsp;
							<g:message code="tab.allocate.resources.label"
								default="Allocate resources" />
						</g:remoteLink></li>
					<%-- <li id="TAB-10002"><g:remoteLink action="returnResources"
											update="SRM-BODY-CONTENT" after="toggleToTab('TAB-10002')">
											<g:message code="tab.return.resources.label"
												default="Return resources" />
										</g:remoteLink></li>--%>

					<li id="TAB-10004"><g:remoteLink action="queryResources"
							update="SRM-BODY-CONTENT" after="toggleToTab('TAB-10004')"><i class="icon-search"></i>&nbsp;
							<g:message code="tab.query.resources.label"
								default="Query resources" />
						</g:remoteLink></li>
					<li id="TAB-10005"><g:remoteLink action="issues"
							update="SRM-BODY-CONTENT" after="toggleToTab('TAB-10005')"><i class="icon-check"></i>&nbsp;
							<g:message code="tab.issues.label" default="Issues" />
						</g:remoteLink></li>
					<li id="TAB-10006"><g:remoteLink action="manageUsers"
							update="SRM-BODY-CONTENT" after="toggleToTab('TAB-10006')"><i class="icon-user"></i>&nbsp;
							<g:message code="tab.manage.user.label" default="Manager users" />
						</g:remoteLink></li>
					<g:link controller="common" action="index"  class="btn pull-right">
						<i class="icon-hand-left"></i>&nbsp;<g:message code="myresources.label" default="My resources" />
					</g:link>
				</ul>

			</div>
		</div>
		<!--/span-->
	</div>
	<!--/admin menu-->

</g:if>
<g:else>
	<!-- user menu -->
	<div class="row-fluid">
		<div class="span12">
			<div class="row-fluid">
				<ul class="nav nav-tabs">
					<li id="TAB-20001" class='active'><g:remoteLink
							action="myResources" update="SRM-BODY-CONTENT"
							after="toggleToTab('TAB-20001')"><i class="icon-briefcase"></i>&nbsp;
							<g:message code="tab.my.resources.label" default="My resources" />
						</g:remoteLink></li>
					<li id="TAB-20002"><g:remoteLink action="myRequests"
							update="SRM-BODY-CONTENT" after="toggleToTab('TAB-20002')"><i class="icon-tags"></i>&nbsp;
							<g:message code="tab.my.requests.label" default="My requests" />
						</g:remoteLink></li>
					<li id="TAB-20003"><g:remoteLink action="myApprovals"
							update="SRM-BODY-CONTENT" after="toggleToTab('TAB-20003')" onSuccess="refreshApprovlesCount()"><i class="icon-bookmark"></i>&nbsp;
							<g:message code="tab.my.approvals.label" default="My approvals" />
							<g:approvalsCount user="${session["user"]}"/>
							%{-- <span id="tab_alert_approval_number" class="badge badge-important">${com.hp.it.cdc.robin.srm.domain.Request.countByNextActionUserBusinessInfo1(session["user"].userBusinessInfo1)}</span> --}%
							%{-- <g:render template="/query/loadTabAlertApprovalNumber"/> --}%
						</g:remoteLink></li>
						
					<g:if
						test="${session["user"].role>=com.hp.it.cdc.robin.srm.constant.RoleEnum.ADMIN}">
						<g:link controller="admin" action="index" class="btn pull-right">
								<i class="icon-hand-right"></i>&nbsp;<g:message code="workasadmin.label" default="Work as admin" />
							</g:link>
					</g:if>
				</ul>
			</div>
		</div>
		<!--/span-->
	</div>
	<!--/user menu-->
</g:else>
