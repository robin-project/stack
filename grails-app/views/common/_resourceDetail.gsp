<div id="viewResource" class="modal hide fade" tabindex="-1"
		role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal"
				aria-hidden="true">
				<i class='icon-off'></i>
			</button>
			<h4>
				View resource
			</h4>
		</div>
		<div class="modal-body">
			<div class="tabbable tabs-below">
			  <div class="tab-content" style="min-height:200px;">
			  	<div class="tab-pane active" id="A">
                	<div class="well span8" style="margin-bottom:0px;line-height: 26px;">
                		%{-- <div class='row-fluid'>${res.getPrintableId()}</div> --}%
                		<div class='row-fluid'>${message(code:'resource.type.name.label')} : ${res.purchase.resourceType.resourceTypeName}</div>
                		<div class='row-fluid'>${message(code:'resource.type.modal.label')} : ${res.purchase.resourceType.model}  ${res.purchase.resourceType.productNr}</div>
                		<div class='row-fluid'>${message(code:'resource.type.supplier.label')} : ${res.purchase.resourceType.supplier}</div>
                		<div class='row-fluid'>${message(code:'resource.purpose.label')} :${res.purpose}</div>
				       	<div class='row-fluid'>${message(code:'resource.serial.label')} : ${res.serial}</div>
				       	<div class='row-fluid'>
				        	${message(code:'resource.status.label')}  : <label class='badge badge-success'>${message(code:res.status.labelCode)}</label>
				        </div>
                	</div>
                	<div class="span4">
                		<img src="<g:createLink controller='picture' action='get'/>?fileName=${res.purchase.resourceType.pictureNames[0]}"></img>
                		<table class="table table-striped table-hover">
	                        <tbody>
	                        <tr>
	                        </tr>
	                        <tr>
	                            <td colspan="2">
	                                ${res.purchase.resourceType.toString()}
	                            </td>
	                        </tr>
	                    	</tbody>
                    	</table>
                	</div>
                </div>
                %{-- <div class="tab-pane" id="B">
  	                <table class="table table-condensed">
  	                	<tr class="odd"><th>Operator</th><th>Comment</th><th>DateCreated</th></tr>
  	                	<g:each in="${res.resourceLogs}" var="resLog">
						<tr>
							<td>${resLog.operateUser.userBusinessInfo2}</td>
							<td>${resLog.logdetail}</td>
							<td>${resLog.dateCreated}</td>
						</tr>  	                
						</g:each>
					</table>
                </div> --}%
                <div class="tab-pane" id="C">
                	<g:form name="tranferForm" class="form-horizontal">
                		<div class="transfer_alert"></div>
						<div class="row-fluid">
							<g:if test="${transfer_req != null}">
     							<div class="span12">
     								<div class="well span12">
     									<div class="row-fluid">Request : ${transfer_req.getPrintableId()}</div>
     									<div class="row-fluid">Status : ${transfer_req.status} </div>
     									
     									<div class="row-fluid">
     										<div class="alert alert-info span10">
	     										<g:set var="transfer_to_user" value="${com.hp.it.cdc.robin.srm.domain.User.findByUserBusinessInfo1(transfer_req.requestDetail.transferToUserBusinessInfo)}" />
	     										<div class="span10">
	     											<i class="icon-user"></i>
	     											${transfer_to_user}<br/>
	     										</div>
											</div>
     									</div>
     									<div class="span12" style="margin-left:0px">
     										<g:textArea class="uneditable-input" name="comment" value="${transfer_req.requestDetail.comment}" style="width:95%;min-height:35px"/>
     								</div>
     								</div>
     								
     							</div>
							</g:if>
							<g:else>
								<div class="span6">
									<div><p><g:message code="myresources.transfer.title"/></p></div>
									<div class="control-group">
										<div class="input-prepend">
		  									<span class="add-on">To:</span>
											<g:render contextPath="../query" template="formQueryUsers"  model="['formId':'user_lookup','status':'ACTIVE;INACTIVE']"/>
										</div>
										<div id="rep_transfer_user">
											<div style="margin-top:3px;margin-bottom:0px;padding:6px" class="well">
												<p>Name : </p>
												<p>Email : </p>
												<p>EID : </p></div>
											</div>
									</div>
								</div>
								<div class="span6">
									<div class="control-group well" style="margin-bottom:3px">
										<g:field type="hidden" name="resourceId" id="transferResourceId" value="${res.id}"></g:field>
										<div id="rep_transfer_res"></div>
										<g:textArea name="comment" class="validate[required, minSize[5]]"
										placeholder="${message(code: 'hint.transferResource.comments')}"
										style="width:95%;min-height:95px"/>
									</div>
									<g:submitButton class="btn btn-primary pull-right span12" name="transfer"  value="${message(code: 'modal.button.transfer.label', default: 'Transfer')}"/>
								</div>
							</g:else>
						</div>
					</g:form>
              	</div>
			  </div>
			  <ul class="nav nav-tabs" style="margin-bottom:3px">
                <li class="active">
                	<a href="#A" data-toggle="tab"><i class="icon-th-large"></i>&nbsp;Detail</a>
                </li>
                %{-- <li>
                	<a href="#B" data-toggle="tab"><i class="icon-list"></i>&nbsp;History</a>
                </li> --}%
                <li>
                	<a href="#C" data-toggle="tab"><i class="icon-random"></i>&nbsp;Transfer</a>
                </li>
              </ul>
			</div>
		</div>
</div>

<script>

	user_lookup_callback_function = function(item){
		var user = new Object()
		user.name=item.split("  ")[0]
		user.email=item.split("  ")[2]
		user.eid=item.split("  ")[1]
		userFormatSelection(user)
	}

    function userFormatSelection(user) {
    	//$("#trans_to_eid").val(user.eid)
    	var content = "<div style='margin-top:3px;margin-bottom:0px;padding:6px' class='well'><p>Name : " + user.name + "</p><p>Email : " + user.email + "</p><p>EID : " + user.eid + "</p></div>"
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
							if(data.status == 500 ){
								var transfer_alert_html = '<div class="alert alert-error" role="status"><button type="button" class="close" data-dismiss="alert">&times;</button>'+ data.responseText +'</div>'
                            	$('.transfer_alert').html(transfer_alert_html)
			            	}else{
			            		$('#viewResource').modal('hide');
								var transfered_res_tile = $("[data-filter-id='${res.id}']")
								for (var i=0; i<6; i++)
								{
								  	transfered_res_tile.fadeToggle()
								}
								jQuery('a',transfered_res_tile).addClass("transfer_res")
				            	//$('#SRM-BODY-CONTENT').html(data);
				            	//$('#TAB-20001 > a').click();
				            	refreshNumber()
			            	}
		                }
			     });
				}
			}  
		});
    }

    $(document).ready(function(){
        validateTransferForm();
    });

</script>