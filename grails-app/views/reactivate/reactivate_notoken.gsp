<%@ page import="com.hp.it.cdc.robin.srm.domain.User"%>
<!DOCTYPE html>
<html>
<head>
<meta name="layout" content="common_main">
<r:require modules="bootstrap" />
</head>
<body>
	<div class="tabbable span12">
		<div class="span12">
			<ul class="nav nav-tabs">
				<li class="active"><a href="#tab1" data-toggle="tab">
					<strong><g:message code="reactivate.tab"/></strong></a></li>
			</ul>
		</div>
		<div>
			<div class="span12">
				<div align="center">
					<strong><font size="5"><g:message code="reactivate.failure.title"/></font></strong><p/>
				</div>
				<div>
					<strong><g:message code="reactivate.failure.msg2"/></strong><p/>
				</div>
				<div align="center" class="span10 well-small">
					<div class="span6">
						<g:submitToRemote url="[action:'index',controller:'reactivate']" class="btn btn-danger" value="${message(code: 'reactivate.failure.btn.retry', default: 'Retry activation')}" update="SRM_COMMON_MAIN_BODY_CONTENT"/>
					</div>
					<div>
						<g:submitToRemote class="btn btn-default" url="[action:'index',controller:'signup']" value="${message(code:'reactivate.failure.btn.gohome', default:'Go home') }" update="SRM_COMMON_MAIN_BODY_CONTENT"></g:submitToRemote>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>