<%@ page import="com.hp.it.cdc.robin.srm.domain.ResourceType"%>
<%@ page import="com.hp.it.cdc.robin.srm.domain.Purchase"%>
<script>
	function hideModal(id){
		$('#'+id).modal('hide')
	}

	function validatePuchaseForm(){
		$("#purchaseForm").validationEngine('attach', {
			onValidationComplete: function(form, status){
				if (status){
					$.ajax({
						url:'<g:createLink action="putInPool"/>',  
						type:'POST',
						data:$("#purchaseForm").serialize(),
						success:function(data){  
			            	$('#SRM-BODY-CONTENT').html(data);
			            }   
			     	});
				}
			}  
		});
	}

	$(document).ready(function(){	
		validatePuchaseForm();
		enableDatepicker();	
		var serialhtml=$("#serialInput").html()		
		$("#quantity").change(
			function() {
				var content="";
				for (var i=1;i<=$("#quantity").val();i++){
					content+=serialhtml.replace(/serial_\d+/g,"serial_" + i)
				}
				$("#serialInput").html(content);

				$('#totalPrice').val($('#unitPrice').val() * $('#quantity').val());
			})

		$("#unitPrice").change(
			function() {
				$('#totalPrice').val($('#unitPrice').val() * $('#quantity').val());
		})
			
		$("#unitCurrency").change(
				function(){
					   $('#totalCurrency').val($('#unitCurrency').val());
		})
			
		$("#resourceType").change();	
		$('#arriveDatePicker').on('changeDate', function(ev) {
 	         $("#arriveDate_month").attr("value",ev.date.getMonth() +1);
 	         $("#arriveDate_day").attr("value",ev.date.getDate());
 	         $("#arriveDate_year").attr("value",ev.date.getFullYear());
 	       }
		
		);
	});

</script>
<div class="tab-content">
	<div class="tab-pane active" id="tab3">
		<div class="row-fluid">
			<div class="row-fluid span12">
				<g:if test="${flash.message}">
					<div class="alert alert-success" role="status">
						<button type="button" class="close" data-dismiss="alert">&times;</button>
						${flash.message}
					</div>
				</g:if>
				<g:if test="${flash.error}">
					<div class="alert alert-error" role="status">
						<button type="button" class="close" data-dismiss="alert">&times;</button>
						${flash.error}
					</div>
				</g:if>
				<g:hasErrors bean="${newPurchaseInstance}">
					<ul class="alert alert-error" role="alert">
						<button type="button" class="close" data-dismiss="alert">×</button>
						<g:eachError bean="${newPurchaseInstance}" var="error">
							<li
								<g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message
									error="${error}" /></li>
						</g:eachError>
					</ul>
				</g:hasErrors>
				<g:hasErrors bean="${resourceTypeInstance}">
					<ul class="alert alert-error" role="alert">
						<button type="button" class="close" data-dismiss="alert">×</button>
						<g:eachError bean="${resourceTypeInstance}" var="error">
							<li
								<g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message
									error="${error}" /></li>
						</g:eachError>
					</ul>
				</g:hasErrors>
				<g:form name="purchaseForm" >
					<div
						class="row-fluid fieldcontain ${hasErrors(bean: newPurchaseInstance, field: 'resourceType', 'error')} ">
						<label for="resourceType" class="span2"> <g:message
								code="purchase.resourceType.label" default="Type" />

						</label>
						<g:select id="resourceType" name="resourceType.id"
							from="${com.hp.it.cdc.robin.srm.domain.ResourceType.list()}"
							optionKey="id" required=""
							value="${newPurchaseInstance?.resourceType?.id}"
							class="many-to-one span4"
							onchange="${remoteFunction(action: 'retrievePictures',
                       									update: 'resourceTypePictures',
												 		params: '\'resourceTypeId=\' + this.value')}" />

						<a href="#addResourceType" role="button" class="btn"
							data-toggle="modal" style="vertical-align: top;"><i
							class="icon-wrench"></i>&nbsp;</a>
					</div>

					<!-- pictures -->
					<div class="row-fluid">
						<label class="span2"> <g:message
								code="purchase.resourceTypePictures.label"/>

						</label>
						<div class="span7">
							<ul class="thumbnails" style="margin-left: -20px"
								id="resourceTypePictures">

							</ul>
						</div>
					</div>
					
					<div
						class="control-group fieldcontain ${hasErrors(bean: newPurchaseInstance, field: 'arriveDate', 'error')} ">
						<label class="span2" for="arriveDate"><g:message
								code="purchase.arriveDate.label" default="Arrive Date" /></label>
						<div id="arriveDatePicker" class="controls input-append date form_date" data-date=""
							data-date-format="dd MM yyyy" data-link-field="arriveDate"
							data-link-format="yyyy-mm-dd">
							<input size="16" type="text" name="arriveDareInput"
								value="" class="validate[required]"
								readonly> <span class="add-on"><i class="icon-th"></i></span>
						</div>
						<input type="hidden" id="arriveDate" name="arriveDate" value="date.struct" />
						<input type="hidden" name="arriveDate_day" id="arriveDate_day"
							value="<g:formatDate date='${newPurchaseInstance?.arriveDate}' format='dd' />" />
						<input type="hidden" name="arriveDate_month" id="arriveDate_month"
							value="<g:formatDate date='${newPurchaseInstance?.arriveDate}' format='MM' />" />
						<input type="hidden" name="arriveDate_year" id="arriveDate_year"
							value="<g:formatDate date='${newPurchaseInstance?.arriveDate}' format='yyyy' />" />
					</div>
					
					<div
						class="fieldcontain ${hasErrors(bean: newPurchaseInstance, field: 'quantity', 'error')} ">
						<label for="quantity" class="span2"> <g:message
								code="purchase.quantity.label" default="Quantity" />

						</label>
						<g:field type="number" name="quantity" class="span7 validate[required,min[1]]" id="quantity"
							value="${newPurchaseInstance.quantity}" value="1" min="1"
							onChange="updateForQuantityChange()" />
					</div>
					
					<div
						class="fieldcontain ${hasErrors(bean: serialNr,'error')} row-fluid">
						<label for="serials" class="span2"> <g:message
								code="purchase.serials.label" default="Serials" />

						</label>
						<div id="serialInput" class="span7" style="margin-left: 0px">
							<g:field type="text" name="serial_1" class="span2 serialInputItem" id="serial_1"/>
						</div>
					</div>

					<div
						class="fieldcontain ${hasErrors(bean: newPurchaseInstance, field: 'unitPrice', 'error')} ">
						<label for="unitPrice" class="span2"> <g:message
								code="purchase.unitPrice.label" default="Unit Price" />

						</label>
						<g:field type="number" name="unitPrice" id="unitPrice"
							value="${newPurchaseInstance.unitPrice}" class="span7 validate[required,min[1]]"
							value="1000" min="0" onChange="updateTotalPrice()" />
						<g:select name="unitCurrency" id="unitCurrency"
							from="${com.hp.it.cdc.robin.srm.constant.CurrencyEnum?.values()}"
							keys="${com.hp.it.cdc.robin.srm.constant.CurrencyEnum.values()*.name()}"
							required="" value="${newPurchaseInstance?.unitCurrency?.name()}"
							class="span2" onChange="updateCurrency()" />
					</div>

					<div
						class="fieldcontain ${hasErrors(bean: newPurchaseInstance, field: 'totalPrice', 'error')} ">
						<label for="totalPrice" class="span2"> <g:message
								code="purchase.totalPrice.label" default="Total Price" />

						</label>
						<g:field type="number" name="totalPrice" id="totalPrice"
							value="${newPurchaseInstance.totalPrice}" class="span7 validate[required,min[1]]"
							value="1000" min="0"/>
						<g:select name="totalCurrency" id="totalCurrency"
							from="${com.hp.it.cdc.robin.srm.constant.CurrencyEnum?.values()}"
							keys="${com.hp.it.cdc.robin.srm.constant.CurrencyEnum.values()*.name()}"
							required="" value="${newPurchaseInstance?.totalCurrency?.name()}"
							class="span2" />
					</div>
					<div
						class="fieldcontain ${hasErrors(bean: purchaseInstance, field: 'comment', 'error')} ">
						<label for="comment" class="span2"> <g:message
								code="purchase.comment.label" default="Comment" />

						</label>
						<g:textArea name="comment" class="span7 offset3 validate[required, minSize[5]]" rows="8"
							value="${purchaseInstance?.comment}" />
					</div>


					<fieldset class="form-actions">
						<g:submitButton class="btn btn-primary pull-right submit" name="putinpool" value="${message(code: 'button.label.putinpool', default: 'Put in pool')}"/>
					</fieldset>
				</g:form>
			</div>
		</div>

		<!-- Modal -->
		<g:render template="addResourceTypeModal"></g:render>
	</div>
</div>



