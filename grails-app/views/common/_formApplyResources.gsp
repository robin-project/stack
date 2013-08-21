<script>
	function validateApplyForm(){
		$("#applyForm").validationEngine('attach', {
			onValidationComplete: function(form, status){
				if (status){
					$.ajax({
						url:'<g:createLink action="apply"/>',  
						type:'POST',
						data:$("#applyForm").serialize(),
						async: false,
						complete:function(data){
							$('#applyResources').modal('hide');
			            	$('#SRM-BODY-CONTENT').html(data);
			            	$('#TAB-20001 > a').click();
			            	refreshNumber();
		                }  
			     });
				}
			}  
		});
	}

	$(document).ready(function(){
				var cursor = 1
				var resource_type_html = $("#app_res").html()

				$("#app_res ~ > .btn").click(
					function() {
						cursor++
						$("#app_res").append(	
							resource_type_html
								.replace(/type_\d+/g,"type_" + cursor)
								.replace(/resourceType_\d+/g,"resourceType_" + cursor)
								.replace(/quantityNeed_\d+/g,"quantityNeed_" + cursor));
				});

				/*delegate the delete btn behavior*/
				$("#app_res").on("click", ".btn", function() {
					$(this).parent().remove()
				});

				/*$("#app_res").on("change",".resourceTypeSelection",function() {
					var resourceTypeSelection = $(this)
					var typeChoice = this.value
					console.log(this.name +"  " + this.value)
					$.map( $("option",resourceTypeSelection.siblings(".detailSelection")) , 
						function(option){
							if($(option).html() == "---Resource---")
								return
							if($(option).attr('data-filter-one').indexOf(typeChoice) > -1){
								$(option).css('display','')
							}else{
								$(option).css('display','none')
							}
						}
					)
				})*/

				$("#app_res").on("change",".resourceTypeSelection",function() {
					var resourceTypeSelection = $(this)		
					$.ajax({
						url:'loadActiveResourceTypeByName',
						data: "ResourceTypeName=" + this.value + "&selectionName="+this.name, 
						complete: function(html) {
							resourceTypeSelection.siblings(".detailSelection").html(html.responseText);
						}
		     		});
				});

		//form validation
		validateApplyForm();
	});
</script>
<g:form name="applyForm" class="form-horizontal">
	<div id="applyResources" class="modal hide fade" tabindex="-1"
		role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal"
				aria-hidden="true">
				<i class='icon-off'></i>
			</button>
			<h4>
				<g:message code="modal.applyResources.label" />
			</h4>
		</div>
		<div class="modal-body">
			<div id="apply-resource" class="content span12" role="main">
				<fieldset class="form">
					<!-- Purpose -->
					<div class="control-group">
						<label for="purpose" class="span2"> 
							<g:message code="flash.applyResources.purpose" default="Purpose" />
						</label>
						<g:select name="purpose" id="purpose" class="span6"
							from="${com.hp.it.cdc.robin.srm.constant.PurposeEnum?.values()}"
							keys="${com.hp.it.cdc.robin.srm.constant.PurposeEnum.values()*.name()}" />
					</div>
					<!-- Resources -->
					<div id="app_res">
						<div class="control-group">
							<g:select name="type_1" class="resourceTypeSelection validate[required]"
								from="${com.hp.it.cdc.robin.srm.domain.ResourceType.findAllByIsBlockIsNullOrIsBlock(false).resourceTypeName.unique().sort(new java.util.Comparator<String>() {
 										public int compare(String lhs, String rhs) {
    									   return lhs.toLowerCase().compareTo(rhs.toLowerCase())
  										}
								})}"
								noSelection="['':'--Category--']"
								style="width:25%" />
							<select name="resourceType_1" class="detailSelection validate[required]" style="width:50%" id="resourceType_1">
								<option value="">---Choose resource category---</option>
							</select>
							<g:field class="validate[required, min[1]]" type="number" name="quantityNeed_1" value="1"
								style="width:10%" />
							<button type="button" class="btn btn-small">
								<i class="icon-minus"></i>
							</button>
						</div>
					</div>
					<!-- Add resouce btn -->
					<div class="control-group">
						<button type="button" class="btn btn-small">
							<i class="icon-plus"></i>
						</button>
					</div>
					<!-- Comment -->
					<div class="control-group">
						<g:textArea name="comment" class="validate[required, minSize[5]]"
							placeholder="${message(code: 'hint.applyResources.comments')}"
							style="width:97%" />
					</div>
				</fieldset>
			</div>
		</div>
		<div class="modal-footer">
			<button class="btn span6 pull-left" data-dismiss="modal"
				aria-hidden="true">
				<g:message code='default.button.cancel.label' />
			</button>
			<g:submitButton class="btn btn-primary pull-right span6" name="apply" value="${message(code: 'default.button.apply.label', default: 'Apply')}"/>
		</div>
	</div>
</g:form>

