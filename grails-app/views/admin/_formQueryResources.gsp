<%@ page import="com.hp.it.cdc.robin.srm.constant.*" %>
<%@ page import="com.hp.it.cdc.robin.srm.domain.*" %>

<div id="RESOURCE_CONDITION_ID" class="row-fluid span12">
	<!-- left -->
	<div class="row-fluid span5">
		<div class="row-fluid">
			<label class="span3"><g:message code="admin.query.type.label"/></label>
			<g:select id="type_select" name="type" noSelection="['':'']" from="${ResourceType.findAll().resourceTypeName.unique()}" value="${params.type }"/>
		</div>
		<div class="row-fluid">
			<label class="span3"><g:message code="admin.query.supplier.label"/></label>
			<g:select id="supplier_select" value="${params.supplier }" name="supplier" noSelection="['':'']" from="${ResourceType.findAll().supplier.unique()}"/>
		</div>
		<div class="row-fluid">
			<label class="span3"><g:message code="admin.query.model.label"/></label>
			<g:select id="model_select" name="model" value="${params.model }" noSelection="['':'']" from="${ResourceType.findAll().model.unique()}"/>
		</div>
		<div class="row-fluid">
			<label class="span3"><g:message code="admin.query.product.label"/></label>
			<g:textField name="productNr" value="${params.productNr}"/>
		</div>
		<div class="row-fluid">
			<label class="span3"><g:message code="admin.query.serial.label"/></label>
			<g:textField name="serialNr" value="${params.serialNr}"/>
			<input type="hidden" name="sortName" id="sortNameId"  value="${params.sortName}" />
		</div>
	</div>
	
	<!-- rights -->
	<div class="row-fluid span6">
		<div class="row-fluid">
			<label class="span3"><g:message code="admin.query.owner.label"/></label>
			<g:render contextPath="../query" template="formQueryUsers" />
		</div>
		<div class="row-fluid">
			<label class="span3"><g:message code="admin.query.purpose.label"/></label>
			<g:select name="purpose" noSelection="['':'']" from="${Usage.PurposeEnum.values().purposeCode}" value="${params.purpose }"/>
		</div>
		<div class="row-fluid">
			<label class="span3"><g:message code="admin.query.arrive.label"/></label>
			<div class="input-prepend">
			  	<div id="arriveDatePicker" class="controls input-append date form_date btn-group" data-date=""
						data-date-format="yyyy-mm-dd" data-link-field="arriveDate"
						data-link-format="yyyy-mm-dd">
					<button class="btn dropdown-toggle input-small" data-toggle="dropdown">
			    		<span id="typeBtnId">${params.arriveDateType}</span>&nbsp;<span class="caret"></span>
			   		</button>
			    	<ul class="dropdown-menu">
			      		<li><a href="javascript:refreshArriveType('On')" class="action-class" id="onId">${message(code:"label.arrive.type.on") }&nbsp;</a></li>
						<li><a href="javascript:refreshArriveType('Before')" class="action-class" id="beforeId">${message(code:"label.arrive.type.before") }&nbsp;</a></li>
						<li><a href="javascript:refreshArriveType('On Before')" class="action-class" id="onBeforeId">${message(code:"label.arrive.type.onbefore") }&nbsp;</a></li>
						<li><a href="javascript:refreshArriveType('On After')" class="action-class" id="onAfterId">${message(code:"label.arrive.type.onafter") }&nbsp;</a></li>
			    	</ul>
					<input class="input-small" id="arriveDateInputId" size="16" type="text" value=""> <span class="add-on"><i class="icon-th"></i></span>
				</div>
				<input type="hidden" name="arriveDateType" id="arriveTypeId"  value="${params.arriveDateType}" />
				<input type="hidden" name="arriveDate" value="date.struct" />
				<input type="hidden" name="arriveDate_day" id="arriveDate_day" value="<g:formatDate date='${params.arriveDate}' format='dd' />"/>
				<input type="hidden" name="arriveDate_month" id="arriveDate_month" value="<g:formatDate date='${params.arriveDate}' format='MM' />"/>
				<input type="hidden" name="arriveDate_year" id="arriveDate_year" value="<g:formatDate date='${params.arriveDate}' format='yyyy' />"/>
			</div>
		</div>
		<div class="row-fluid">
			<label class="span3"><g:message code="admin.query.status.label"/></label>
			<g:checkBox name="retiredCode" value="${params.retiredCode }"/>&nbsp;<g:message code="admin.query.status.val4"/>&nbsp;&nbsp;
			<g:checkBox name="normalCode" value="${params.normalCode}"/>&nbsp;<g:message code="admin.query.status.val1"/>&nbsp;&nbsp;
			<g:checkBox name="lostCode" value="${params.lostCode }"/>&nbsp;<g:message code="admin.query.status.val5"/>&nbsp;&nbsp;
			<g:checkBox name="allocatedCode" value="${params.allocatedCode }"/>&nbsp;<g:message code="admin.query.status.val2"/>&nbsp;&nbsp;
			<g:checkBox name="brokenCode" value="${params.brokenCode}"/>&nbsp;<g:message code="admin.query.status.val3"/>&nbsp;&nbsp;
			<g:checkBox name="transferredCode" value="${params.transferredCode }"/>&nbsp;<g:message code="admin.query.status.val7"/>&nbsp;&nbsp;
			<g:checkBox name="returnedItioCode" value="${params.returnedItioCode }"/>&nbsp;<g:message code="admin.query.status.val6"/>
		</div>
	</div>

	<div class="span11 row-fluid well-small">
		<div class="text-right">
			<g:submitButton id="findId" name="${message(code:'admin.query.btn.find', default:'Find resource') }" class="btn btn-primary"/>
		</div>
	</div>
</div>
<script type="text/javascript">
	function initArriveDate(){
		var dateStr = "${params.arriveDate}";
		if (dateStr!=null && dateStr!=''){
			var d = new Date(dateStr);
		    var date = [d.getDate(), d.getMonth()+1, d.getFullYear()].join(' ');
			$("#arriveDateInputId").attr('value',date);
		}
	}
	var dataSet =  ['${flash.userEmailSet}'];
	var array = new Array();
	$(document).ready(function(){	
		enableDatepicker();		
		initArriveDate();
     	$("#arriveDatePicker").on('changeDate', function(ev) {
     		$("#arriveDate_month").attr("value",ev.date.getMonth() +1);
	        $("#arriveDate_day").attr("value",ev.date.getDate());
	        $("#arriveDate_year").attr("value",ev.date.getFullYear());
     	});

		$("#arriveDateInputId").change(function(){
			var val = $("#arriveDateInputId").val();
			if (val==null || val==""){
				$("#arriveDate_year").attr("value", null);
				$("#arriveDate_month").attr("value", null);
				$("#arriveDate_day").attr("value", null);
				$("#arriveTypeId").attr("value", "On");
				$("#typeBtnId").html("On");
			}
		});
		//initialize owner info
		if ("${params.userBusinessInfo2}"!=""){
			$("#queryContent").attr("value", "${params.userBusinessInfo2}");
			$("#userBusinessInfo2").attr("value", "${params.userBusinessInfo2}");
		}

		//remove owner email
		$("#queryContent").change(function(){
			var value = $("#queryContent").val();
			if (value==null || value==""){
				$("#userBusinessInfo2").attr("value", null);
			}
		})

     	//cascade select type-supplier-model
     	$("#type_select").change(function() {
     		$.ajax({
				url:'${request.contextPath}/query/loadSuppliers',
				data: "id=" + this.value,
				cache: false,
				success: function(html) {
					$("#supplier_select").html(html);
				}
     		});
        });	 

     	$("#model_select").mousedown(function(){
     		$.ajax({
				url:'${request.contextPath}/query/loadModel',
				data: "id=" + $("#supplier_select").val(),
				cache: false,
				success: function(html) {
					$("#model_select").html(html);
				}
     		});
         });
     	$("#supplier_select").change(function() {
     		$.ajax({
				url:'${request.contextPath}/query/loadModel',
				data: "id=" + this.value,
				cache: false,
				success: function(html) {
					$("#model_select").html(html);
				}
     		});
        });
        
	})
</script>			