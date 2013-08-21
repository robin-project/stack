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

.plan-intro{
    font-size:18px;
    padding-bottom:18px;
}
.plan-intro .sub-head{
    font-size:17px;
    color:#777;
    margin-top:-10px;
}

.column {
    -moz-box-sizing: border-box;
    box-sizing: border-box;
    float: left;
    padding: 15px;
}
.columns.equacols .column {
    float: left;
}

</style>
</head>
<body>
    <div class="container">
        <div class="span12">
            <ul class="nav nav-tabs">
                <li class="active">
                    <a href="#tab1" data-toggle="tab">
                        <strong><g:message code="signup.tab.label"/></strong>
                    </a>
                </li>
            </ul>
        </div>
        <div class="span12 plan-intro">
            <div class="row-fluid">
                <div class="span6">
                	<p/>
                    <p class="sub-head"><g:message code="signup.tab.subhead"/></p>
                </div>
                <div class="span6 text-center">
                      <a href="/stack" class="btn"><g:message code="signup.tab.button"/></a>
                </div>
                <br/>
            </div>
        </div>
        <div class="columns equacols" style="padding-bottom:8px">
            <div id="signupDiv" class="row-fluid" >
                <div class="column main span5">
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
                    <g:form name="signupForm" url="[action:'authenticate']">
                        <div class="control-group">
                            <div class="controls">
                                <div class="input-control text ${hasErrors(bean: userInstance, field: 'userBusinessInfo2', 'error')} ">
                                    <p><strong>Email Address</strong></p>
                                    <g:textField placeholder="${message(code:'email.common.tip') }" name="userBusinessInfo2" value="${userInstance?.userBusinessInfo2}" class="span12"/>
                                    %{-- <div><g:message code="format.emailMsg"/></div> --}%
                                </div>
                            </div>
                        </div>
                        <div class="control-group">
                            <div class="controls">
                                <div
                                    class="input-control text ${hasErrors(bean: userInstance, field: 'password', 'error')} ">
                                    <p><strong>Password</strong></p>
                                    <g:passwordField placeholder="${message(code:'password.signup.tip') }" name="password" value="${userInstance?.password}" class="span12"/>
                                    %{-- <div><g:message code="format.passwdMsg"/></div> --}%
                                </div>
                            </div>
                        </div>
                        <div class="control-group">
                            <div class="controls">
                                <div class="input-control text" >
                                    <p><strong>${message(code:'verification.tip') }</strong></p>
                                    <div class="row-fluid">
                                        <div class="span6">
                                       
                                    <g:textField id="verifyId" placeholder="${message(code:'verification.tip') }" name="captchaResponse" value="" class="span12"/>
                                    </div>
                                        <div class="span3 offset1">               
                                            <jcaptcha:jpeg id="VERIFY_CODE" name="imageCaptcha" height="100px" width="100px" />
                                        </div>
                                        <div class="span2">
                                            <button id="refreshCaptcha" type="button" class="btn btn-small btn-default"><i class="icon-refresh"></i></button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="control-group">
                            <div class="controls">
                                <g:submitButton class="btn btn-success span12" name="${message(code:'signup.label', default:'Sign up now') }"/>
                            </div>
                        </div>
                    </g:form>
                </div>
                <div class="span6 pull-right">
                        <img align="right" hight="500" src="${resource(dir: 'images', file: 'sketched-desktop.jpg')}" />
                </div>
            </div>
        </div>
    </div>
</body>
</html>
