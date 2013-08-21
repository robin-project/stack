<style type="text/css">
.popover-content {
	color:red;
}	
</style>
<script>
	function validateAssignedActionForm(){
		$("#reAssignedUserLookup").attr("class", "validate[required, minSize[3]]");
		$("#actionResForm").validationEngine('attach', {
			onValidationComplete: function(form, status){
				if (status){
					if ($("#reAssignedEId").val()==null || $("#reAssignedEId").val()==""){
						$("#reAssignedUserLookup").popover({
							trigger:'manual',
				    		html:'true',
				  			placement: 'right',
				  		    content:"<g:message code='resource.reassigned.user.invalid'/>"
				    	});
						$("#reAssignedUserLookup").popover("show");
					}else{
						saveActionResource('reAssignedResourceId');
					}
				}
			}  
		});
	}
	$(document).ready(function() {
		validateAssignedActionForm();
		$("#reAssignedUserLookup-userBusinessInfo1").on("change",function(){
			$("#reAssignedEId").attr("value", $(this).val());
			if ($(this).val()!=null && $(this).val()!=""){
				$("#reAssignedUserLookup").popover("hide");
			}
		});//end on change
	});
</script>
<div class="accordion" id="accordion2">
	<div class="accordion-group">
	    <div class="accordion-heading">
	      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseOne">
	        <Strong>Action Comment : &nbsp;</Strong><i class="icon-comment"></i>
	      </a>
	    </div>
	    <div id="collapseOne" class="accordion-body collapse">
	      <div class="accordion-inner">
	        <g:textArea name="actionComment" class="actionComment span12" placeholder="${message(code: 'hint.resource.action.comments')}"/>
	      </div>
	    </div>
	</div>
	<g:if test="${flash.args[0] == 'reAssigned'}">
	   	<div class="row-fluid">
	   		<div class="input-prepend">
		  		<span class="add-on">To:</span>
				<g:render contextPath="../query" template="formQueryUsers"  model="['formId':"reAssignedUserLookup"]"/>
			</div>
	    		<input type="hidden" id="reAssignedEId">
		</div>
	</g:if>
</div>
<div>
	<div>
		<g:if test="${checkedResults != null}">
			<Strong><g:message code="admin.query.resource.title" args="${flash.args }"/></Strong>
		</g:if>
	</div>
	<div>
		<g:if test="${checkedResults == null}">
			<p class="text-error"><strong>Please select the resources!</strong></p>
		</g:if>
		<g:else>
			<div>
				<input type="hidden" id="reAssignActionArgId" value="${flash.args }">
				<input type="hidden" id="actionResListId" value="${flash.actionRes }">
				<table class="table table-bordered table-striped table-hover">
					<thead>
						<tr class="odd">
							<th scope="col">${message(code: 'admin.query.result.id', default: 'Resource Id')}</th>
						    <th scope="col">${message(code: 'admin.query.result.supplier', default: 'Supplier')}</th>
						    <th scope="col">${message(code: 'admin.query.result.model', default: 'Model')}</th>
						    <th scope="col">${message(code: 'admin.query.result.serial', default: 'Serial')}</th>
						</tr>
					</thead>
					<tbody id="bodyId">
						<g:each in="${checkedResults}" status="i" var="res">
							<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
								<td>${res.getPrintableId()}</td>
								<td>${res.purchase.resourceType.supplier}</td>
								<td>${res.purchase.resourceType.model}</td>
								<td>${res.serial}</td>
							</tr>
						</g:each>
					</tbody>
				</table>
			</div>
		</g:else>
	</div>
</div>
