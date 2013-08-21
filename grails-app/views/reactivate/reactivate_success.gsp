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
					<strong><font size="5"><g:message code="reactivate.success.msg1"/></font></strong><p/>
				</div>
	            <div>
					<g:message code="reactivate.success.msg2.1"/>&nbsp;<a><%=request.getParameter("email") %></a>&nbsp;<g:message code="reactivate.success.msg2.2"/>
				</div>
				<div align="center" class="span10 well-small">
					<div class="span6">
						<g:link class="btn btn-primary" uri="/"><g:message code="reactivate.success.btn.return"/></g:link>
						
					</div>
					<div>
						<g:link class="btn btn-default" uri="/signup/index"><g:message code="reactivate.success.btn.resend"/></g:link>
					</div>
				</div>
			</div>
		</div>
	</div>

</body>
</html>