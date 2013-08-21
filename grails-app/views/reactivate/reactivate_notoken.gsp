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
						<a href="/stack/signup" class="btn btn-danger"><g:message code="reactivate.failure.btn.retry"/></a>
					</div>
					<div>
						<g:link class="btn btn-default" uri="/"><g:message code="reactivate.failure.btn.gohome"/></g:link>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>