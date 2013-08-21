<script>
	function addNewOption(name){
		$(name).bind();
		jQuery(name).customComboBox({
			tipClass:"",
			tipText:"{NEW}",
			index:"first",
			prefix:"",
			allowed:/[A-Za-z0-9\$\.\s]/
		});
	}

	function loadAllTypeSupplierModel(){
		$.ajax({
			url:'loadAllTypes',
			cache: false,
			complete: function(html) {
				$("select[name='resourceTypeName']").html(html.responseText);
				addNewOption("select[name='resourceTypeName']");
			}
 		});//end load types
 		$.ajax({
			url:'loadAllSuppliers',
			cache: false,
			complete: function(html) {
				$("select[name='supplier']").html(html.responseText);
				addNewOption("select[name='supplier']");
			}
 		});//end load suppliers
 		$.ajax({
			url:'loadAllModels',
			cache: false,
			complete: function(html) {
				$("select[name='model']").html(html.responseText);
				addNewOption("select[name='model']");
			}
 		});//end load models

	}

 	function validateResourceTypeForm(){
 		$("#inlineAddResourceType").validationEngine('attach', {
 			onValidationComplete: function(form, status){
 				if (status){
 					$.ajax({
 						url:'<g:createLink action="addResourceType"/>',  
 						type:'POST',
 						data:$("#inlineAddResourceType").serialize(),
 						success:function(data){  
 							$("#inlineEdit select").val("");
 							$("#newProductNrId").val("");
 							//unbind all events
 							$("select[name='resourceTypeName'] , select[name='supplier'] , select[name='model']").unbind();
 							//refresh form selections
 							loadAllTypeSupplierModel();
 							//refresh table records
 			            	$('#currentResourceType').html(data);
 			            }   
 			     });
 				}
 			}  
 		});
 	}

	$(document).ready(function(){		
		//validate resourceType form
		validateResourceTypeForm();
		$("#addResourceType").on("hide",function(){
			$.ajax({
				url:'addResources',
						cache: false,
						success: function(html) {
							$('#SRM-BODY-CONTENT').html(html);
						}
		     		});
		})
		$("#addResourceType").on("show",function(){
			$(".messageAddResourceType").remove()
		})

	})

</script>

	<div id="addResourceType" class="modal hide" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-header">
			<button type="button" class="close pull-right" data-dismiss="modal" aria-hidden="true">
				<i class='icon-off'></i>
			</button>
			<h3><g:message code="modual.addResourceType.label"/></h3>
		</div>
		<div class="modal-body">
			<div id="create-resourceType" role="main">
				<g:render template="formAddResourceType" />
				<g:render template="currentResourceTypes"/>
			</div>
		</div>
%{-- 		<div class="modal-footer"> --}%
%{-- 			<g:submitButton class="btn btn-primary pull-right span3" name="ok" value="${message(code: 'admin.ok.btn.label', default: 'Ok')}"/>
			<div class='pull-right'>&nbsp;&nbsp;</div> --}%
%{-- 			<button class="btn span3 pull-right" data-dismiss="modal" aria-hidden="true">
				<g:message code='default.button.ok.label' />
			</button> --}%
		%{-- </div> --}%
	</div>
