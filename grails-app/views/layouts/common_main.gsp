<%@ page import="com.hp.it.cdc.robin.srm.domain.User"%>
<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!-->
<html lang="en" class="no-js">
<!--<![endif]-->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title><g:message code="srm.application.name.label" /></title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<r:require modules="bootstrap" />
<link rel="shortcut icon"
	href="${resource(dir: 'images', file: 'favicon.ico')}"
	type="image/x-icon">
<link rel="apple-touch-icon"
	href="${resource(dir: 'images', file: 'apple-touch-icon.png')}">
<link rel="apple-touch-icon" sizes="114x114"
	href="${resource(dir: 'images', file: 'apple-touch-icon-retina.png')}">
<!-- link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}" type="text/css"-->
<!-- link rel="stylesheet" href="${resource(dir: 'css', file: 'mobile.css')}" type="text/css"-->
<r:layoutResources />
<g:javascript library="validate" />
<g:layoutHead />
</head>
<body>
	<browser:choice>
		<browser:isMsie versionLower="9">
			<DIV class="alert">
				<div class="container row-fluid">

					<div class="media offset2 span8">
						<a class="pull-left" href="#"><g:img dir="images"
								file="ie-notice.png" /></a>
						<div class="media-body">
							<g:message code="ie.bad.support" />
						</div>
					</div>

				</div>
			</DIV>
		</browser:isMsie>
		<browser:isSafari></browser:isSafari>
		<browser:isChrome></browser:isChrome>
		<browser:isFirefox></browser:isFirefox>
		<%--			<browser:isOpera></browser:isOpera>--%>
		<%--			<browser:isiPhone></browser:isiPhone>--%>
		<%--			<browser:isiPad></browser:isiPad>--%>
		<%--			<browser:isWindows></browser:isWindows>--%>
		<%--			<browser:isMobile></browser:isMobile>--%>
	</browser:choice>
	<div class="container" id="SRM_COMMON_MAIN_BODY_CONTENT">

		<div class="container-fluid">
			<div class="row-fluid">
				<div class="span12 well-small">
					<div class="span12">
						<g:img dir="images" file="hp_logo.png" />
						<strong><font size="5"><g:message
									code="srm.application.name.label" /></font></strong>
					</div>
<%--					<div class="span7">--%>
<%--						<g:form class="form-horizontal pull-right"--%>
<%--							url="[action:'login',controller:'signin']">--%>
<%--							<g:textField style="width:35%"--%>
<%--								placeholder="${message(code:'email.common.tip') }"--%>
<%--								name="userBusinessInfo2"--%>
<%--								value="${userInstance?.userBusinessInfo2}" />--%>
<%--							<g:passwordField style="width:35%"--%>
<%--								placeholder="${message(code:'password.signin.tip') }"--%>
<%--								name="password" value="${userInstance?.password}" />--%>
<%--							<g:submitButton class="btn btn-primary"--%>
<%--								name="${message(code: 'signin.label', default: 'Sign in')}" />--%>
<%--						</g:form>--%>
<%--					</div>--%>
				</div>
			</div>
		</div>

		<div class="container-fluid ">
			<div class="row-fluid well-small">
				<div class="span12">
					<div class="row-fluid">
						<g:layoutBody />
					</div>
				</div>
			</div>
<%--			<div class="row-fluid well-small">--%>
<%--				<div class="span12">--%>
<%--					<div class="row-fluid">--%>
<%--						<div>--%>
<%--							<strong><g:message code="commonMain.what" /></strong>--%>
<%--							<legend></legend>--%>
<%--						</div>--%>
<%--						<div>--%>
<%--							<g:message code="commonMain.whatMsg1" />--%>
<%--							<p />--%>
<%--							<p />--%>
<%--							<g:message code="commonMain.whatMsg2" />--%>
<%--							<p />--%>
<%--							<g:message code="commonMain.whatMsg3" />--%>
<%--							<p />--%>
<%--							<g:message code="commonMain.whatMsg4" />--%>
<%--							<p />--%>
<%--						</div>--%>
<%--						<div>--%>
<%--							<strong><g:message code="commonMain.question" /></strong>--%>
<%--							<legend></legend>--%>
<%--						</div>--%>
<%--						<div>--%>
<%--							<g:message code="commonMain.question1" />--%>
<%--							<p />--%>
<%--							<p />--%>
<%--							<g:link controller="reactivate" action="index"><g:message code="commonMain.question2.1" /></g:link>&nbsp;--%>
<%--							<g:message code="commonMain.question2.2" />--%>
<%--							<p />--%>
<%--							<g:message code="commonMain.question3" />--%>
<%--							<p />--%>
<%--							<g:message code="commonMain.question4.1" />--%>
<%--							--%>
<%--							<p />--%>
<%--						</div>--%>
<%--					</div>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--			<div class="container-fluid well-small">--%>
<%--				<div class="row-fluid">--%>
<%--					<div class="span4"></div>--%>
<%--					<div class="span2">--%>
<%--						<center>--%>
<%--							<g:message code="copyright.privacy.label" />--%>
<%--						</center>--%>
<%--					</div>--%>
<%--					<div class="span2">--%>
<%--						<center>--%>
<%--							<g:message code="copyright.term.label" />--%>
<%--						</center>--%>
<%--					</div>--%>
<%--					<div class="span4"></div>--%>
<%--				</div>--%>
<%--				<div class="row-fluid">--%>
<%--					<div class="span4"></div>--%>
<%--					<div class="span4">--%>
<%--						<center>--%>
<%--							<g:message code="copyright.robin.label" />--%>
<%--						</center>--%>
<%--					</div>--%>
<%--					<div class="span4"></div>--%>
<%--				</div>--%>
<%--				<div class="row-fluid">--%>
<%--					<div class="span4"></div>--%>
<%--					<div class="span4">--%>
<%--						<center>--%>
<%--							<g:message code="copyright.hp.label" />--%>
<%--						</center>--%>
<%--					</div>--%>
<%--					<div class="span4"></div>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--		</div>--%>
	</div>


	<g:javascript library="application" />
	<g:javascript library="placeholder" />
	<script type="text/javascript">
		$(function() { $('input, textarea').placeholder();})
		 
	</script>
	<r:layoutResources />
</body>
</html>