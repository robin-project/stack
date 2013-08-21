		<div class="span12">
				<div class="control-group">
					 <label class="control-label span3"><g:message code="users.name.label" default="Name" /></label>
					 <g:textField name="userBusinessInfo3" value="${user?.userBusinessInfo3}" disabled="true" />
				</div>
				<div class="control-group">
					 <label class="control-label span3"><g:message code="users.EID.label" default="EID" /></label>
					 <g:textField class="validate[required]" name="userBusinessInfo1" id="eid-${user.id}" value="${user?.userBusinessInfo1}"  disabled="true"/>
						<button type="button" onclick="document.getElementById('eid-${user.id}').disabled=false" style="vertical-align:top"><i class="icon-edit"></i></button>
				</div>
				<div class="control-group">
					 <label class="control-label span3"><g:message code="users.email.label" default="Email" /></label>
					 <g:textField class="validate[required, custom[email]]" name="userBusinessInfo2" id="email-${user.id}" value="${user?.userBusinessInfo2}"   disabled="true"/>
						<button type="button" onclick="document.getElementById('email-${user.id}').disabled=false" style="vertical-align:top"><i class="icon-edit"></i></button>
				</div>
				<div class="control-group">
					 <label class="control-label span3"><g:message code="users.status.label" default="Status" /></label>
					 <g:select name="status" id="status-${user.id}" from="${com.hp.it.cdc.robin.srm.constant.UserStatusEnum?.values()}" 
										keys="${com.hp.it.cdc.robin.srm.constant.UserStatusEnum.values()*.name()}" 
										required="" 
										value="${user?.status?.name()}"
										disabled="true"/>
						<button type="button" onclick="document.getElementById('status-${user.id}').disabled=false" style="vertical-align:top"><i class="icon-edit"></i></button>
				</div>
				<div class="control-group">
					 <label class="control-label span3"><g:message code="users.role.label" default="Role" /></label>
					 <g:select name="role" id="role-${user.id}" from="${com.hp.it.cdc.robin.srm.constant.RoleEnum?.values()}" 
									   keys="${com.hp.it.cdc.robin.srm.constant.RoleEnum.values()*.name()}" 
									   required="" 
									   value="${user?.role?.name()}"
									   disabled="true"/>
						<button type="button" onclick="document.getElementById('role-${user.id}').disabled=false" style="vertical-align:top"><i class="icon-edit"></i></button>
				</div>
		</div>
