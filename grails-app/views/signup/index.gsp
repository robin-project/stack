<%@ page import="com.hp.it.cdc.robin.srm.domain.User"%>
<!DOCTYPE html>
<html>
<head>
<meta name="layout" content="common_main">
<r:require modules="bootstrap" />
<script>
$(document).ready(function(){
	$("#refreshCaptcha").click(function() {
		$("#imageCaptcha").fadeOut(500, function() {
			var captchaURL = $("#imageCaptcha").attr("src");	
			captchaURL = captchaURL.replace(captchaURL.substring(captchaURL.indexOf("=")+1, captchaURL.length), Math.floor(Math.random()*9999999999));
			$("#imageCaptcha").attr("src", captchaURL);
		});
		$("#imageCaptcha").fadeIn(300);
	});

	//form validation
	$("#signupForm").validate({
		rules: {
			userBusinessInfo2: {
				 required: true,
				 email:true
			},
			captchaResponse: {
				required: true,
				minlength:5
			},
			password:{
				required: true,
				minlength:6
			}
		},
		messages: {
			userBusinessInfo2: {
				 required: "${message(code:'validate.input.required.msg', args:['Email'])}",
				 email: "${message(code:'validate.email.format.msg')}"
			},
			captchaResponse: {
				 required: "${message(code:'validate.input.required.msg', args:['VerifyCode'])}",
				 length:"${message(code:'validate.verifyCode.length.msg')}"
			},
			password: {
				 required: "${message(code:'validate.input.required.msg', args:['Password'])}",
				 minlength:"${message(code:'validate.input.length.msg', args:['Password', 6])}"
			}
		}
	});
});
</script>
<style type="text/css">
#signupForm label.error {
	margin-left: 10px;
	width: auto;
	display: inline;
	color:red;
}
#signupForm input.error{
border: 2px solid red;
background-color: #FFFFD5;
margin: 0px;
}
</style>
</head>
<body>

	<div id="signupDiv" class="span12" >
		
			<ul class="nav nav-tabs">
				<li class="active"><a href="#tab1" data-toggle="tab"><strong>Sign up/Reactivate</strong></a></li>
			</ul>
		
<%--		<div class="span8 well-small text-center">--%>
<%--			<div>--%>
<%--				<h2><font color="#01F1FA"><g:message code="signup.msg1"/></font></h2>--%>
<%--			</div>--%>
<%--			<div>--%>
<%--				<p><font color="white"><g:message code="signup.msg2"/></font></p>--%>
<%--				<p><font color="white"><g:message code="signup.msg3"/></font></p>--%>
<%--			</div>--%>
<%--		</div>--%>
		<div class="span3 well-small">
			<g:if test="${flash.message}">
				<p class="text-error">${flash.message}</p>
            </g:if>
            <g:hasErrors bean="${userInstance}">
                <ul class="errors" role="alert">
                    <g:eachError bean="${userInstance}" var="error">
                    <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
                    </g:eachError>
                </ul>
             </g:hasErrors>
			<g:form name="signupForm" url="[action:'authenticate',controller:'signup']">
				<div class="control-group">
					<div class="controls">
						<div class="input-control text ${hasErrors(bean: userInstance, field: 'userBusinessInfo2', 'error')} ">
							<g:textField placeholder="${message(code:'email.common.tip') }" name="userBusinessInfo2" value="${userInstance?.userBusinessInfo2}" />
							<div><g:message code="format.emailMsg"/></div>
						</div>
					</div>
				</div>

				<div class="control-group">
					<div class="controls">
						<div
							class="input-control text ${hasErrors(bean: userInstance, field: 'password', 'error')} ">
							<g:passwordField placeholder="${message(code:'password.signup.tip') }" name="password" value="${userInstance?.password}" />
							<div><g:message code="format.passwdMsg"/></div>
						</div>
					</div>
				</div>
				<div class="control-group">
					<div class="controls">
						<div class="input-control text" >
							<g:textField id="verifyId" placeholder="${message(code:'verification.tip') }" name="captchaResponse" value=""/>
							<div>							
								<jcaptcha:jpeg id="VERIFY_CODE" name="imageCaptcha" height="100px" width="100px" />
								<button id="refreshCaptcha" type="button" class="btn btn-small btn-default"><i class="icon-refresh"></i></button>
							</div>
						</div>
					</div>
				</div>
				<div class="control-group">
					<div class="controls">
						<g:submitButton class="btn btn-success pull-center" name="${message(code:'signup.label', default:'Sign up now') }"/>
					</div>
				</div>
			</g:form>
		</div>
	</div>
</body>
</html>
