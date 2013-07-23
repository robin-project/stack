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
	$("#reactiveForm").validate({
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
		}
	});
});
</script>
<style type="text/css">
#reactiveForm label.error {
	margin-left: 10px;
	width: auto;
	display: inline;
	color:red;
}
#reactiveForm input.error{
border: 2px solid red;
background-color: #FFFFD5;
margin: 0px;
}
</style>
</head>
<body>
	<div class="tabbable span12">
		<div class="span12">
			<ul class="nav nav-tabs">
				<li class="active"><a href="#tab1" data-toggle="tab"><strong>Forgot Password</strong></a></li>
			</ul>
		</div>
		<div>
			<div class="span12 text-left">
				<div>
					<div>
						<strong><font color="red"><g:message code="reactivate.note"/></font></strong><p/>
					</div>
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
					<g:form id="reactiveForm" url="[controller:'reactivate', action:'reactive']">
						<div class="input-control text ${hasErrors(bean: userInstance, field: 'userBusinessInfo2', 'error')} ">
							<g:textField placeholder="Your HP Email" name="userBusinessInfo2" value="${userInstance?.userBusinessInfo2}" />
							<p/><g:message code="format.emailMsg"/>
						</div>
						<p />
						<div
							class="input-control text ${hasErrors(bean: userInstance, field: 'password', 'error')} ">
							<g:passwordField placeholder="New Password" name="password"
								value="${userInstance?.password}" />
							<p/><g:message code="format.passwdMsg"/>
						</div>
						<div class="input-control form-horizontal">
							<g:textField placeholder="Verification" name="captchaResponse" value=""/>							
							<jcaptcha:jpeg name="imageCaptcha" height="100px" width="100px" />
							<button id="refreshCaptcha" type="button" class="btn btn-small btn-default"><i class="icon-refresh"></i></button>
						</div>
						<div class="control-group well-small">
							<div class="controls">
								<g:submitButton class="btn btn-success" name="${message(code:'reactivate.index.btn', default:'Sign up/Reactive') }"/>
							</div>
						</div>
					</g:form> 
				</div>
			</div>
		</div>
	</div>
</body>
</html>