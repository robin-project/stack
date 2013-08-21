<!-- Modal viewRequest-->
<g:form id="formAliasConfigForAllocate">
	<div id="aliasConfigForAllocate" class="modal hide">
		<div class="modal-header">
			<button type="button" class="close pull-right" data-dismiss="modal"
				aria-hidden="true">
				<i class='icon-off'></i>
			</button>
			<h3 id="myModalLabel">
				<g:message code="modal.aliasConfig.label" />
			</h3>
		</div>
		<div class="modal-body">
			<!-- list location code -->
			<div>
				<table class="table table-bordered table-striped">
				<div id="configInfo">
						<div class="alert alert-success" role="status">
							<button type="button" class="close" data-dismiss="alert">&times;</button>
							${message(code: 'flash.updateAliasConfig.success',default:'Update  AliasConfig  Successfully!!!')}
						</div>
				</div>
				<div id="configErr">
						<div class="alert alert-error" role="status">
							<button type="button" class="close" data-dismiss="alert">&times;</button>
							${message(code: 'flash.updateAliasConfig.failure',default:'Update  AliasConfig  Failure!!!')}
						</div>
				</div>
					<thead>
						<tr>
							<th>
								${message(code: 'configuration.locationCode.label', default: 'LocationCode')}
							</th>
							<th>
								${message(code: 'configuration.alias.label', default: 'Alias')}
							</th>
						</tr>
					</thead>
					<tbody>
						<g:each in="${locationList}" status="i" var="location">
							<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
							<tr>
							<g:hiddenField name="id" value="${location?.id}" />
								<td>${location.locationCode}</td>
								<td>
									<g:textField  name="alias" id="alias-${location.id}" 
										value="${location.alias}" />
									<button type="button" onclick="updateAliasConfig('${location.id}')" style="vertical-align: top">
										<i class="icon-circle-arrow-up"></i>
									</button>
								</td>
							</tr>
						</g:each>
					</tbody>
				</table>
			</div>
			<!-- list location code -->
		</div>
		<div class="modal-footer">
			<div class='pull-right'>&nbsp;</div>
			<button class="btn span3 pull-right" onclick="sync()" data-dismiss="modal"
				aria-hidden="true">
				<g:message code='close.button.label' />
			</button>
		</div>
	</div>
</g:form>
<script>
$(document).ready(function(){	
	$("#configInfo").hide();
	$("#configErr").hide();
});

function updateAliasConfig(id){
	var alias=document.getElementById('alias-'+id).value;
	$.ajax({
		url:'saveAliasConfig',  
		type:'POST',
		data:"id=" + id+"&alias="+alias,
		error:function(data){  
			$("#configInfo").show();
        	//$('#formAliasConfig').html(data);
        }   
 	});//end ajax
 	
	$.ajax({
		url:'saveAliasConfig',  
		type:'POST',
		data:"id=" + id+"&alias="+alias,
		success:function(data){
			$("#configErr").show();
        }   
 	});//end ajax
}

function sync(){
	$.ajax({
		url:'allocateResources',  
		cache: false,
		success: function(html) {
			$('#SRM-BODY-CONTENT').html(html);
		}
 	});//end ajax
}

</script>