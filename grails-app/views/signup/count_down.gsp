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
					<strong><font size="4"><g:message code="count.down.msg1"/>&nbsp;<a id="emailId">${flash.message}</a><g:message code="count.down.msg2"/></font>&nbsp;<font size="4" color="red"><labe id="timerMsg"></label></font>&nbsp;<font size="4">Seconds</font></strong><p/>
				</div>
			</div>
		</div>
	</div>
	<g:javascript>
		var totalSeconds=5;
		function tick() {
			if (totalSeconds == 0){
				window.location.href="../reactivate/reactivate_success?email="+$("#emailId").text()
				return
			}
			totalSeconds -= 1;
			updateTimer()
			window.setTimeout("tick()", 1000);
		}
		
		function updateTimer() {
			$("#timerMsg").text(totalSeconds);
		}
	</g:javascript>
	<jq:jquery>
		$(document).ready(function() {
			updateTimer();
			window.setTimeout("tick()", 1000);
		});
	</jq:jquery>
</body>
</html>