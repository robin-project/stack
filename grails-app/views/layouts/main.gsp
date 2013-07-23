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
<g:setProvider library="jquery" />
<r:require modules="bootstrap" />
<!-- r:require module="jquery-ui" /-->
<link rel="shortcut icon"
	href="${resource(dir: 'images', file: 'favicon.ico')}"
	type="image/x-icon">
<link rel="apple-touch-icon"
	href="${resource(dir: 'images', file: 'apple-touch-icon.png')}">
<link rel="apple-touch-icon" sizes="114x114"
	href="${resource(dir: 'images', file: 'apple-touch-icon-retina.png')}">
<!-- link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}" type="text/css"-->
<!-- link rel="stylesheet" href="${resource(dir: 'css', file: 'mobile.css')}" type="text/css"-->
<link rel="stylesheet"
	href="${resource(dir: 'css', file: 'stickyfooter.css')}"
	type="text/css">
<link rel="stylesheet"
	href="${resource(dir: 'css', file: 'datetimepicker.css')}"
	type="text/css">

<link rel="stylesheet"
	href="${resource(dir: 'css', file: 'bubble.css')}"
	type="text/css">
	
<link rel="stylesheet" href="${resource(dir: 'css', file: 'validationEngine.jquery.css')}" type="text/css"/>

<script type="text/javascript" >
	function toggleToTab(id){
		$('.nav-tabs >li.active').removeClass('active')
		$('#'+id).addClass('active')
	}
	
	function enableTooltip(){
		if ($("[title]").length) {
				$("[title]").tooltip();
		}
	}
	
	function fixPlaceHolderForIE8(){
		 $('input, textarea').placeholder();
	}
	
	function enableDatepicker(){
	 	$(".form_date").datetimepicker({
        	format: "dd MM yyyy",
        	minView: "2",
        	autoclose: true,
        	todayBtn: true,
        	pickerPosition: "bottom-left",
    	});
	}
</script>

<r:layoutResources />
<g:layoutHead />
</head>
<style type="text/css">
.tab-content {
	overflow: visible;
}	
</style>
<body>
	<g:render contextPath="/layouts" template="topmenu" />
	
	<div id="wrap">
		<div class="container">
			<g:if test="${session["user"]}">
				<div class="row-fluid">
					<div class="span2 pull-left">
						<g:render contextPath="/layouts" template="leftdash" />
					</div>
					<div class="span10">
						<g:render contextPath="/layouts" template="tabs" />
						<g:render contextPath="/layouts" template="content" />
					</div>
				</div>
			</g:if>
		</div>
		<%--		<div id="push"></div>--%>
	</div>
	
	<!--<g:render contextPath="/layouts" template="footer" />-->


	<g:javascript library="application" />
	<g:javascript library="iFrame" />
	<g:javascript library="placeholder" />
	<g:javascript library="datetimepicker"/>
	<g:javascript library="validateEngine" />
	<g:javascript library="validateEngineEn" />
	
	<g:javascript>
		
		$(document).ready(function(){		
			enableTooltip();
			fixPlaceHolderForIE8();
		});
		
	</g:javascript>
	<r:layoutResources />
</body>
</html>