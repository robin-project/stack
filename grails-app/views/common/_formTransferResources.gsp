<g:form name="tranferForm" class="form-horizontal">
	<div id="transferResources" class="modal hide fade" tabindex="-1"
		role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal"
				aria-hidden="true">
				<i class='icon-off'></i>
			</button>
			<h4>
				<g:message code="modal.transferResources.label" />
			</h4>
		</div>
		<div class="modal-body">
			<div class="content span12" role="main">
				<fieldset class="form">
					<!-- Purpose -->
					<div class="row-fluid">
						<div class="span6">
							<div class="control-group" style="height:100%">
								<!-- <input type="text" id="people_find" style="width:90%">
								</input>
								<input type="hidden" name="eid" id="trans_to_eid"></input>
								<br></br>
								<div id="rep_transfer_user"></div> -->
								<div class="input-prepend">
  									<span class="add-on">To:</span>
									<g:render contextPath="../query" template="formQueryUsers" />
								</div>
								<div id="rep_transfer_user"></div>
							</div>
						</div>
						<div class="span6">
							<div class="control-group well">
								<g:field type="hidden" name="resourceId" id="transferResourceId"></g:field>
								<div id="rep_transfer_res"></div> 
							</div>
						</div>
					</div>
					
					<!-- Comment -->
					<div class="row-fluid">
						<div class="span12">
							<g:textArea name="comment" class="validate[required, minSize[5]]"
								placeholder="${message(code: 'hint.transferResource.comments')}"
								style="width:98%"/>
						</div>
					</div>
				</fieldset>
			</div>
		</div>
		<div class="modal-footer">
			<button class="btn span6 pull-left" data-dismiss="modal"
				aria-hidden="true">
				<g:message code='default.button.cancel.label' />
			</button>
			<g:submitButton class="btn btn-primary pull-right span6" name="transfer" 
				value="${message(code: 'modal.button.transfer.label', default: 'Transfer')}"/>
		</div>
	</div>
</g:form>

<script>

	user_lookup_callback_function = function(item){
		var user = new Object()
		user.name=item.split("  ")[0]
		user.email=item.split("  ")[2]
		user.eid=item.split("  ")[1]
		userFormatSelection(user)
	}

	function userFormatResult(user) {
       return user.name + " " +  user.email + "  " + user.eid
    }

    function userFormatSelection(user) {
    	//$("#trans_to_eid").val(user.eid)
    	var content = "<div style='margin-top:20px' class='well'><p>Name : " + user.name + "</p><p>Email : " + user.email + "</p><p>EID : " + user.eid + "</p></div>"
    	$("#rep_transfer_user").html(content)
       	return user.name
    }

    function validateTransferForm(){
    	$("#user_lookup").attr("class", "basicTypeahead validate[required]");
    	$("#tranferForm").validationEngine('attach', {
			onValidationComplete: function(form, status){
				if (status){
					$.ajax({
						url:'<g:createLink action="transfer"/>',  
						type:'POST',
						data:$("#tranferForm").serialize(),
						async: false,
						complete:function(data){
							$('#transferResources').modal('hide');
			            	$('#SRM-BODY-CONTENT').html(data);
			            	$('#TAB-20001 > a').click();
		                }  
			     });
				}
			}  
		});
    }

    $(document).ready(function(){
        validateTransferForm();
    });

    <!--
	$("#people_find").select2({
			placeholder: "Search for user",
			minimumInputLength: 2,
			ajax: {
		        url: "http://localhost:8080/srm-web/common/lookupUser",
		        dataType: 'json',
		        quietMillis: 1000,
		        data: function (term, page) {
		            return {email:term}
		        },
		        results: function (data, page) {
		            console.log(data)
		            return {results: data.users}
		        },
    		},
    		formatResult: userFormatResult,
    		formatSelection: userFormatSelection,
    		dropdownCssClass: "bigdrop",
    		escapeMarkup: function (m) { return m; }
    })
    -->

</script>

