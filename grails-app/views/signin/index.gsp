<%@ page import="com.hp.it.cdc.robin.srm.domain.User"%>
<!DOCTYPE html>
<html>
<head>
<meta name="layout" content="common_main">
<r:require modules="bootstrap" />
<script>
$(document).ready(function(){
	//login validation
	$("#signinForm").validate({
		rules: {
			userBusinessInfo2: {
				 required: true,
				 email:true
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
#signinForm label.error {
	margin-left: 10px;
	width: auto;
	display: inline;
	color:red;
}
#signinForm input.error{
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
				<li class="active"><a href="#tab1" data-toggle="tab"><strong>Sign In</strong></a></li>
			</ul>
		</div>
		<div>
			<div class="span12">
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
				<g:form id="signinForm" url="[action:'login',controller:'signin']">
				<div>
					<div class="input-control text ${hasErrors(bean: userInstance, field: 'userBusinessInfo2', 'error')} ">
						<g:textField placeholder="Your HP Email" name="userBusinessInfo2" value="${userInstance?.userBusinessInfo2}" />
						<p/><g:message code="format.emailMsg"/>
					</div>
					<p />
					<div
						class="input-control text ${hasErrors(bean: userInstance, field: 'password', 'error')} ">
						<g:passwordField placeholder="New Password" name="password" value="${userInstance?.password}" />
						<p/><g:message code="format.passwdMsg"/>
					</div>
					<div class="control-group">
						<g:submitButton class="btn btn-success" name="${message(code:'signin.label', default:'Sign in') }" />
						<g:submitToRemote class="btn btn-danger" url="[action:'index',controller:'reactivate']" value="${message(code:'forgot.password.label', default:'Sign in') }" update="SRM_COMMON_MAIN_BODY_CONTENT"></g:submitToRemote>
					</div>
				</div>
				</g:form>
			</div>
		</div>
	</div>

</body>
</html>