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
			<div class="span12 pull-left">
				<div align="center">
					<strong><font size="5"><g:message code="reactivate.failure.title"/></font></strong><p/>
				</div>
				<g:if test="${flash.errorMsg}">
	                <div class="message" role="status"><font color="red">${flash.errorMsg}</font></div>
	            </g:if>
				<div>
					<strong><g:message code="reactivate.failure.msg1.1"/>&nbsp;<a>${flash.message }</a><g:message code="reactivate.failure.msg1.2"/></strong>
				</div>
				<div align="center" class="span10 well-small">
					<div class="span6 well-small">
						<g:submitToRemote url="[action:'index',controller:'signup']" class="btn btn-danger" value="${message(code: 'reactivate.failure.btn.retry', default: 'Retry activation')}" update="SRM_COMMON_MAIN_BODY_CONTENT"/>
					</div>
					<div class="well-small">
						<g:submitToRemote class="btn btn-default" url="[action:'index',controller:'signup']" value="${message(code:'reactivate.failure.btn.gohome', default:'Go home') }" update="SRM_COMMON_MAIN_BODY_CONTENT"></g:submitToRemote>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>