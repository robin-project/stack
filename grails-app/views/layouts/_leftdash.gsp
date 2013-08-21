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
	<g:render template="/query/dashboardNumbers"/>
	<hr style="margin: 0">
</div>


