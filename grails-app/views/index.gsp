<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!-->
<html lang="en" class="no-js">
<!--<![endif]-->
<head>
<meta http-equiv="X-UA-Compatible" content="chrome=1,IE=edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><g:message code="srm.application.name.label" /></title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<r:require modules="bootstrap,scrollto" />
<r:layoutResources />
<link rel="shortcut icon"
	href="${resource(dir: 'images', file: 'favicon.ico')}"
	type="image/x-icon">
<style type="text/css">
.or {
	padding: 10px 0;
	line-height: 1em;
	text-align: center;
	clear: both;
	width: 100%;
	float: left;
}

.or .line {
	display: inline-block;
	width: 40%;
	border-top: 2px solid #999;
	margin-top: .5em;
	float: left;
}

.or .text {
	display: inline-block;
	width: 20%;
	float: left;
}

#footer {
        height: 30px;
        background-color: #f5f5f5;
      }

#learnMoreContent{
background-color: #f5f5f5;
}

.opacity30 {

	filter:alpha(opacity=30);

	-moz-opacity:0.3;

	-khtml-opacity: 0.3;

	opacity: 0.3;

}

.opacity70 {

	filter:alpha(opacity=70);

	-moz-opacity:0.7;

	-khtml-opacity: 0.7;

	opacity: 0.7;

}

</style>
<link rel="stylesheet" href='<g:resource  dir="css" file="grumble/grumble.css" />' type="text/css" />
<script src='<g:resource  dir="js" file="grumble/Bubble.js" />' type="text/javascript"></script>
<script src='<g:resource  dir="js" file="grumble/jquery.grumble.js" />' type="text/javascript"></script>
</head>
<body>
	<browser:choice>
		<browser:isMsie versionGreater="8"></browser:isMsie>
		<browser:isSafari></browser:isSafari>
		<browser:isChrome></browser:isChrome>
		<browser:isFirefox></browser:isFirefox>
		<browser:otherwise>
			<DIV class="alert alert-error">
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
		</browser:otherwise>
	</browser:choice>
	<a href="https://github.com/robin-hp/stack" target="_blank"><img src="${resource(dir: 'images', file: 'forkus_github.png')}" class="pull-right"/></a>
	<div id="body" class="container">
		<div id="spacer-top" class="spacer row-fluid"></div>
		<div id="login" class="row-fluid">
			<div class="span5 offset1" style="height: 360px">
				<br /> <br /> <img
					src="${resource(dir: 'images', file: 'sketched-laptop.jpg')}" />
			</div>
			<div class="span4" style="height: 360px">
				<span class="text-info"><center>
						<h1 style="font-size: 800%">Stack</h1>
					</center></span>
				<div style="height: 80px"></div>
				<div>
					<div class="span12">
						<span class="span12" />
			<g:if test="${flash.message}">
				<div class="alert alert-error" role="status">
					<button type="button" class="close" data-dismiss="alert">&times;</button>
					${flash.message}
				</div>
			</g:if>
						<g:form
							url="${grailsApplication.config.grails.serverSecureURL+'/signin/loginWithDb'}"
							style="margin:0px">

							<g:submitButton class="btn btn-info span12"
								name="login_classb" value="${message(code:'login.classb')}"></g:submitButton>


							<span class="muted pull-right"> <a
								href="http://intranet.hp.com/HPIT/GetIT/DigitalBadge/Pages/InstallCACertificate_IE.aspx"><small><g:message
											code="login.classb.applyhere" /></small></a></span>
						</g:form>
						<div class="or">
							<span class="line"></span><span class="text">Or</span><span
								class="line right"></span>
						</div>

						<g:form url="[action:'login',controller:'signin']"
							style="margin:0px">
							<div
								class="${hasErrors(bean: userInstance, field: 'userBusinessInfo2', 'error')} ">
								<g:textField placeholder="Your HP Email" class="span12"
									name="userBusinessInfo2"
									value="${userInstance?.userBusinessInfo2}" required=""/>
							</div>
							<div
								class="${hasErrors(bean: userInstance, field: 'password', 'error')} ">
								<g:passwordField placeholder="Stack Password" class="span12"
									name="password" value="${userInstance?.password}" required=""/>
							</div>
							<div class="control-group">
								<g:submitButton class="btn btn-info span12" name="login_srm"
									name="${message(code:'login.srm')}" />
								<span class="muted pull-right  grumble_tip"><g:link
										controller="signup">
										<small><g:message code="login.hint.forgetpassord" /></small>
									</g:link></span>
							</div>
							<br />
							<br />
						</g:form>
					</div>
				</div>
			</div>
		</div>
		<div id="spacer-bottom" class="spacer row-fluid"></div>
	</div>
	<div id="footer">
		<div class="container">
			<div class="row-fluid">
					<center><a id="learnMore" href="#" class="opacity70">Learn more</a></center>
			</div>
		</div>
	</div>
	<div id="learnMoreContent" style="display: none">
		<div class="container">
			<div class="row-fluid">
				<div class="span3">
					<div class="thumbnail">
						<img src="${resource(dir: 'images', file: 'hp_logo.png')}"
							style="width:100px;height:100px" class="opacity70" />
						<div class="caption">
							<p class="muted credit">This is a Hewlett-Packard site, owned
								by Information Technology Development Service China Center
								Operation Team</p>
						</div>
					</div>
				</div>
				<div class="span3">
					<div class="thumbnail">
						<img src="${resource(dir: 'images', file: 'mongodb_logo.png')}"
							style="width:100px;height:100px" class="opacity70" />
						<div class="caption">
							<p class="muted credit">Powered by <a href="http://www.mongodb.com" target="_blank">MongoDB</a>,which is an open-source, 
							document-oriented database designed for ease of development and scaling.</p>
						</div>
					</div>
				</div>
				<div class="span3">
					<div class="thumbnail">
						<img src="${resource(dir: 'images', file: 'grails_logo.jpg')}"
							style="width:100px;height:100px" class="opacity70" />
						<div class="caption">
							<p class="muted credit">Powered by <a href="http://www.grails.org/" target="_blank">Grails</a>,which is an Open Source, 
							full stack, web application framework based on <a href="http://groovy.codehaus.org/" target="_blank">Groovy</a> & convention over configuration</p>
						</div>
					</div>
				</div>
				<div class="span3">
					<div class="thumbnail">
						<img src="${resource(dir: 'images', file: 'bootstrap_logo.png')}"
							style="width:100px;height:100px"  class="opacity70" />
						<div class="caption">
							<p class="muted credit">Powered by <a href="http://twitter.github.io/bootstrap/" target="_blank">Bootstrap</a>,which is a sleek, intuitive, and powerful front-end framework for faster and easier web development.</p>
		
						</div>
					</div>
				</div>
			</div>
			<div class="row-fluid" id="end">&nbsp;</div>
		</div>
	</div>

	<g:javascript library="application" />
	<g:javascript library="placeholder" />
	<script>

		$(document).ready(
				function() {
					
					$('#body').css("height",
							$(window).innerHeight() - $('#footer').height());
					$('.spacer').css(
							"height",
							($(window).height() - $('#login').height() - $(
									'#footer').height()) / 2);

					if (($(window).height() - $('#login').height() - $(
							'#footer').height()) / 2 <= 0) {
						$('#footer').css("display", "none");
					}
					$('#learnMore').click(function() {
						$('#learnMoreContent').show();
						$('body,html').scrollTo('#end');
					});
					$('input, textarea').placeholder();


					/* add the hint to help understanding process */
					$("#login [type=submit]").click(function(){
						document.cookie = "fish=" + new Date()
					})
					/*var current_dt = new Date()
					var end_dt = new Date("10/10/2013 18:00")
					if(current_dt<end_dt){*/
						/*if(document.cookie == null || document.cookie.indexOf('fish')<0 )
						{*/
							$('.grumble_tip').grumble(
								{
									text: 'Click here to signup with HP email first',
									/*type: 'alt-',*/
									angle: 120,
									distance: 3,
									showAfter: 2000,
									hideAfter: 8000,
								}
							)
						/*}*/
					/*}*/
				});
	</script>
	<r:layoutResources />
</body>
</html>
