<!-- Modal viewRequest-->
<g:form id="showUserDetailsForm">
	<div id="showUserDetails-${it.id}" class="modal hide">
		<div class="modal-header">
			<button type="button" class="close pull-right" data-dismiss="modal"
				aria-hidden="true">
				<i class='icon-off'></i>
			</button>
			<h3 id="myModalLabel">
				<g:message code="modal.userdetails.label" />
			</h3>
		</div>
		<div class="modal-body">
		
		<g:form method="post">
			<g:hiddenField name="id" value="${user?.id}" />
			<g:hiddenField name="version" value="${user?.version}" />
			<fieldset class="form">
				<g:render template="formEditUserDetails" />
			</fieldset>
		</g:form>
		</div>
		<div class="modal-footer">
			<g:submitToRemote url="[action:'saveUserDetails']"
				class="btn btn-primary pull-right span3"
				value="${message(code: 'saveClose.button.label', default: 'Save')}"
				update="SRM-BODY-CONTENT" onComplete="callQueryUsers(${currentPage }, ${pageCounts},queryParams)" after="hideModal('showUserDetails-${it.id}')" />
			<div class='pull-right'>&nbsp;</div>
			<button class="btn span3 pull-right" data-dismiss="modal"
				aria-hidden="true">
				<g:message code='close.button.label' />
			</button>
		</div>
	</div>
</g:form>