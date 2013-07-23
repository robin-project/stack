<div class="tab-content">
	<div class="tab-pane active" id="tab1">
		<div class="row-fluid">
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
			<input type="hidden" id="offsetInput" value="1">
			<table class="table table-hover table-striped">
				<thead>
					<tr>
						<th><a href="#allocateWOrequest" class="btn btn-primary"
							data-toggle="modal"> <i
								class="icon-exclamation-sign icon-white"></i> &nbsp; <g:message
									code="allocateWOrequest.button.label" />
						</a></th>

						<th>
							${message(code: 'requestid.label', default: 'Request ID')}
						</th>


						<th>
							${message(code: 'resourceType.resourceTypeName.label', default: 'Type')}
						</th>
						
						
						<th>
							${message(code: 'requeststatus.label', default: 'Status')}												
						</th>
						<th>
							${message(code: 'request.by.label', default: 'Request by')}
						</th>
						<th>
							${message(code: 'request.usage.label', default: 'Usage')}
						</th>
					</tr>
				</thead>
				<tbody id="allocateList">
					<g:each in="${requestInstanceList}" status="i"
						var="requestInstance">
						<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
							<td><div class="btn-group">
									<button class="btn dropdown-toggle" data-toggle="dropdown">
										<i class="icon-tasks"></i> &nbsp;
										<g:message code="action.button.label" />
										&nbsp;<span class="caret"></span>
									</button>
									<ul class="dropdown-menu">
										<li><a href="#allocateForRequest-${requestInstance.id}"
											role="button" data-toggle="modal"> <i
												class="icon-ok-sign"></i>&nbsp;<g:message
													code="requestallocate.button.label" />&nbsp;
										</a></li>
										<li><a href="#viewForRequest-${requestInstance.id}"
											role="button" data-toggle="modal"> <i
												class="icon-eye-open"></i>&nbsp;<g:message
													code="requestview.button.label" />&nbsp;
										</a></li>
										<li><a href="#" role="button" data-toggle="modal"
											onclick="closeRequest(${requestInstance.id});">
												${message(code:"requestclose.button.label")}
										</a>
											
									</ul>
									
								</div>
								<form id="closeRequest-${requestInstance.id}"
												style="display: none">
												<g:hiddenField name="requestId"
													value="${requestInstance.id}" />

												<g:submitToRemote
													id="closeRequestSubmit-${requestInstance.id}"
													class="hide"
													url="[action:'closeRequest']" update="SRM-BODY-CONTENT"
													value="" />

											</form>
								</td>
							<td>
								req-apply-${requestInstance.id}
							</td>

				
							<td>
								${requestInstance.requestDetail.resourceType.resourceTypeName}-
								${requestInstance.requestDetail.resourceType.supplier}-
								${requestInstance.requestDetail.resourceType.model}
							</td>
							<td>
								<g:message code='${requestInstance.status.labelCode}.render'/>
										
							
								<label class="badge">${requestInstance.requestDetail.quantityAllocate} /${requestInstance.requestDetail.quantityNeed}</label>
							</td>
							<td>
								${requestInstance.submitUser.userBusinessInfo3}
							</td>
							<td>
								${requestInstance.requestDetail.purpose}
							</td>
						</tr>
					</g:each>

				</tbody>
			</table>

		</div>
	</div>


		<div class="pagination ajax_paginate">
			<a href="#" onclick="loadMoreAllocate()"><g:message code="default.paginate.more"/></a>
		</div>
</div>

<g:render template="formAllocateWOrequest"/>

<div id="allocateModals">
<g:render template="formAllocateResource"
	collection="${requestInstanceList}" />
</div>

<div id="viewModals">	
<g:render template="formViewResource"
	collection="${requestInstanceList}" />
</div>


<script>
function closeRequest(id){
	$('#closeRequestSubmit-'+id).click();
}
function loadMoreAllocate(){
    /* add code to fetch new content and add it to the DOM */
    var value = $("#offsetInput").attr("value");
	
    $.ajax({
        dataType: "html",
        url: "${request.contextPath}/query/allocateList?offset="+value,
        async: false,
        success: function(html){
            if(html){
                $("#allocateList").append(html);
            }
            $("#offsetInput").attr("value",parseInt(value)+1);
        }
    });

    $.ajax({
        dataType: "html",
        url: "renderAllocateModels?offset="+value,
        async: false,
        success: function(html){
            if(html){
                $("#allocateModals").append(html);
            }
        }
    });

    $.ajax({
        dataType: "html",
        url: "renderViewModels?offset="+value,
        async: false,
        success: function(html){
            if(html){
                $("#viewModals").append(html);
            }
        }
    });
}
</script>





