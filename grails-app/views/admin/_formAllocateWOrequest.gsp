<!-- Modal viewRequest-->
<g:form name="allocateForm" id="allocateForRequestForm">
	<div id="allocateWOrequest" class="modal hide">
		<div class="modal-header">
			<button type="button" class="close pull-right" data-dismiss="modal"
				aria-hidden="true">
				<i class='icon-off'></i>
			</button>
			<h3 id="myModalLabel">
				<g:message code="modal.viewrequest.label" />
			</h3>
		</div>
		<div class="modal-body">
			<div id="create-resourceType" class="content span12" role="main">

				<div class="row-fluid">
					<div class="row-fluid">
						<div class="input-prepend">
		  					<span class="add-on">To:</span>
							<g:render contextPath="../query" template="formQueryUsers"  model="['formId':"user_lookup"]"/>
						</div>
						<g:select name="purpose" id="purpose"
							from="${com.hp.it.cdc.robin.srm.constant.PurposeEnum?.values()}"
							keys="${com.hp.it.cdc.robin.srm.constant.PurposeEnum.values()*.name()}" />
					</div>
					
					<div class="well">
						<div id="demand">
							<div class="control-group">
								<g:select class="resourceTypeSelection validate[required]" name="resourceType_1"
									from="${com.hp.it.cdc.robin.srm.domain.ResourceType.list().sort(new java.util.Comparator<com.hp.it.cdc.robin.srm.domain.ResourceType>() {
 										public int compare(com.hp.it.cdc.robin.srm.domain.ResourceType lhs, com.hp.it.cdc.robin.srm.domain.ResourceType rhs) {
    									    int level1 = lhs.resourceTypeName.toLowerCase().compareTo(rhs.resourceTypeName.toLowerCase())
  											if (level1 != 0){
  												return level1
  											}else{
  												int level2 = (lhs.model.toLowerCase()).compareTo(rhs.model.toLowerCase())
  												if (level2 != 0){
  													return level2
  												}else{
  													return (lhs.supplier.toLowerCase()).compareTo(rhs.supplier.toLowerCase())
  									
  												}
  											}
  										}
								})}"
									optionKey="id" noSelection="['':' ']"/>
								<g:select class="serialSelection validate[required]" name="serialNr_1" style="width:30%"
									 from="${serials}"/>
								<button type="button" class="btn btn-small" style="vertical-align: top;">
									<i class="icon-minus"></i>
								</button>
							</div>
						</div>
					<div>
						<button type="button" class="btn btn-small">
							<i class="icon-plus"></i>
						</button>
					</div>
				</div>
				</div>
			</div>
		</div>

		<div class="modal-footer">
			<g:submitButton class="btn btn-primary pull-right span3" name="transfer" 
				value="${message(code: 'allocate.button.label', default: 'Allocate')}"/>
				
			<div class='pull-right'>&nbsp;</div>
			<button class="btn span3 pull-right" data-dismiss="modal"
				aria-hidden="true">
				<g:message code='default.button.cancel.label' />
			</button>
		</div>

	</div>
</g:form>

<script>

	function validateAllocateForm(){
		$("#user_lookup").attr("class", "basicTypeahead validate[required]");
    	$("#allocateForm").validationEngine('attach', {
			onValidationComplete: function(form, status){
				if (status){
					$.ajax({
						url:'<g:createLink action="demand"/>',  
						type:'POST',
						data:$("#allocateForm").serialize(),
						success:function(data){
							$('#allocateWOrequest').modal('hide');
							$('#SRM-BODY-CONTENT').html(data);
		                }  
			     });
				}
			}  
		});
	}
	
	$(document).ready(function() {
				var demandcursor = 1
				var demand_resource_type_html = $("#demand").html()

				$("#demand ~ > .btn").click(
						function() {
							demandcursor++
							$("#demand").append(
									demand_resource_type_html.replace(
											/resourceType_\d+/g, "resourceType_" + demandcursor)
											.replace(/serialNr_\d+/g, "serialNr_" + demandcursor)
							);
						});
				$("#demand").on("click", ".btn", function() {
					//$(this).parent().toggle( "Highlight", {}, 500 );
					$(this).parent().remove()
				})

				$("#demand").on("change",".resourceTypeSelection",function() {
					var resourceTypeSelection = $(this)		
					$.ajax({
						url:'loadNormalSerials',
						data: "typeId=" + this.value + "&selectionName="+this.name, 
						cache: false,
						complete: function(html) {
							resourceTypeSelection.siblings(".serialSelection").html(html.responseText);
						}
		     		});
				});
				//validate form 
				validateAllocateForm();
			});
</script>