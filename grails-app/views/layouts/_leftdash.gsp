<div>

	<span> <a href="http://gravatar.com/emails/" target="_blank"
		 data-toggle="tooltip" data-placement="bottom" title=""
		data-original-title="${message(code:'change.avatar')}"><div>
				<avatar:gravatar email='${session["user"].userBusinessInfo2}'
					size="300" cssClass="img-polaroid" ></avatar:gravatar>
			</div></a>
	</span>


</div>

<div class="caption">
	<div class="row-fluid">
		<h3>
			${session["user"].userBusinessInfo3}
		</h3>
		<hr style="margin: 0">
	</div>
	<div class="row-fluid">
		<br/>
		<i class="icon-time"></i>&nbsp;
		<g:message code="joined.on"/><g:formatDate date='${session["user"].dateCreated}' format='yyyy-MM-dd' />
		

		<hr style="margin-bottom: 0">
	</div>

	<div class="row-fluid" style="text-align: center;">
		<div class="span4">
			<h2 style="margin-top:0;margin-bottom:0">${com.hp.it.cdc.robin.srm.domain.Resource.countByCurrentUser(session["user"]) }</h2>
			<small style="font-size: 70%"><g:message code="dash.owned" /></small>
		</div>
		<div class="span4">
			<h2 style="margin-top:0;margin-bottom:0">${com.hp.it.cdc.robin.srm.domain.Request.countBySubmitUserAndStatusAndRequestType(session["user"],com.hp.it.cdc.robin.srm.constant.RequestStatusEnum.NEW, com.hp.it.cdc.robin.srm.constant.RequestTypeEnum.APPLY) }</h2>
			<small style="font-size: 70%"><g:message code="dash.requested" /></small>
		</div>
		<div class="span4">
			<h2 style="margin-top:0;margin-bottom:0">${com.hp.it.cdc.robin.srm.domain.Request.countByStatusAndRequestTypeAndNextActionUserBusinessInfo1(com.hp.it.cdc.robin.srm.constant.RequestStatusEnum.NEW, com.hp.it.cdc.robin.srm.constant.RequestTypeEnum.TRANSFER,session["user"].userBusinessInfo1) }</h2>
			<small style="font-size: 70%"><g:message code="dash.toaccept" /></small>
		</div>
		
	</div>
	<hr style="margin: 0">
</div>


