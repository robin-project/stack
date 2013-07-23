<!DOCTYPE html>
<html>
<head>
<title><g:if env="development">Grails Runtime Exception</g:if> <g:else>Error</g:else></title>
<meta name="layout" content="main">
<g:if env="development">
	<link rel="stylesheet"
		href="${resource(dir: 'css', file: 'errors.css')}" type="text/css">
</g:if>
</head>
<body>
	<div class="thumbnail" style="height:600px;">
		<img alt="Error" style="width: 300px; height: 200px;"
			src="${resource(dir: 'images', file: 'smellyface.jpg')}">
		<div class="caption" style="vertical-align:middle;">
			<div class="alert alert-error">
				<h3>
					<g:message code="error.awkward"
						default="It's awkward... but some error happened." />
				</h3>
				<g:message code="error.awkward.passage" />
			</div>
<%--			<div style="height: 300px" class="container-fluid">--%>
<%--				<g:if env="development">--%>
<%--					<g:renderException exception="${exception}" />--%>
<%--				</g:if>--%>
<%--			</div>--%>
		</div>
	</div>


</body>
</html>
