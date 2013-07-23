<style type="text/css">
element.style{
	margin-top: -15px;
} 
</style>
<script>
	function validateResourceTypeForm(){
		$("#resourceTypeForm").validationEngine('attach', {
			onValidationComplete: function(form, status){
				if (status){
					$.ajax({
						url:'<g:createLink action="addResourceType"/>',  
						type:'POST',
						data:$("#resourceTypeForm").serialize(),
						success:function(data){  
							$('#addResourceType').modal('hide');
			            	$('#SRM-BODY-CONTENT').html(data);
			            }   
			     });
				}
			}  
		});
	}
	$(document).ready(function(){		
		//validate resourceType form
		validateResourceTypeForm();
	})
</script>
<g:form id="addResourceTypeForm" name="resourceTypeForm">
	<div id="addResourceType" class="modal hide" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-header">
			<button type="button" class="close pull-right" data-dismiss="modal" aria-hidden="true">
				<i class='icon-off'></i>
			</button>
			<h3><g:message code="modual.addResourceType.label"/></h3>
		</div>
		<div class="modal-body">
			<div id="create-resourceType" class="content span12" style="margin-top:25px" role="main">
				<g:render template="formAddResourceType" />
			</div>
		</div>
		<div class="modal-footer">
			<g:submitButton class="btn btn-primary pull-right span3" name="create" value="${message(code: 'default.button.create.label', default: 'Create')}"/>
			<div class='pull-right'>&nbsp;&nbsp;</div>
			<button class="btn span3 pull-right" data-dismiss="modal" aria-hidden="true">
				<g:message code='default.button.cancel.label' />
			</button>
		</div>
	</div>
</g:form>