<!-- Modal allocateResource-->
<g:form id="allocateForRequestForm">
	<input type="hidden" name="requestId" value="${it.id}"/>
	<div id="allocateForRequest-${it.id}" class="modal hide">
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
				<table class="table table-hover table-condensed">
					<thead>
						<tr>
							<td colspan="4">
								${it.requestDetail.resourceType.resourceTypeName + " " + it.requestDetail.resourceType.model + (it.requestDetail.resourceType.productNr==null?"":"-"+it.requestDetail.resourceType.productNr) + " ("+ it.requestDetail.resourceType.supplier +")"}
							</td>
							<td><g:message code='${it.status.labelCode}.render'/>
							<label class="badge">${it.requestDetail.quantityAllocate} /${it.requestDetail.quantityNeed}</label>
							</td>
						</tr>
					</thead>
					<tbody>
<%--						<g:each in="${it.activities}" var="activity">--%>
<%--							<tr>--%>
<%--								<td>&nbsp;&nbsp;&nbsp;</td>--%>
<%--								<!-- class warn success info -->--%>
<%--								<td><avatar:gravatar--%>
<%--										email="${activity.activityUser.userBusinessInfo2}" /></td>--%>
<%--								<td>--%>
<%--									${activity.activityUser.userBusinessInfo3}--%>
<%--								</td>--%>
<%--								<td>--%>
<%--									${message(code:activity.activityType.labelCode)}--%>
<%--								</td>--%>
<%--								<td>--%>
<%--									<g:formatDate date='${activity.dateCreated}' format='yyyy-MM-dd' />--%>
<%--								</td>--%>
<%--							</tr>--%>
<%--						</g:each>--%>
					</tbody>
				</table>
				<div class="well">
					<div id="app_res-${it.id}">
						<div class="control-group">
							<g:select class="resourceTypeSelection" name="resourceType_1"
								from="${com.hp.it.cdc.robin.srm.domain.ResourceType.list()}"
								optionKey="id" noSelection="['':' ']" 
								required=""
								style="width:60%" />
							<span class="serialSelection" style="width:30%">
								<g:select name="serialNr_1" style="width:30%"
								 from="${serials}"/>
							</span>
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

		<div class="modal-footer">
			<g:submitToRemote url="[action:'allocate']"
				class="btn btn-primary pull-right span3"
				value="${message(code: 'allocate.button.label', default: 'Allocate')}"
				update="SRM-BODY-CONTENT" after="hideModal('allocateForRequest-${it.id}')" />
			<div class='pull-right'>&nbsp;</div>
			<button class="btn span3 pull-right" data-dismiss="modal"
				aria-hidden="true">
				<g:message code='default.button.cancel.label' />
			</button>
		</div>

	</div>
</g:form>
<script>
	$(document).ready(function() {
				var cursor = 1
				var resource_type_html = $("#app_res-${it.id}").html()

				$("#app_res-${it.id} ~ > .btn").click(
						function() {
							cursor++
							$("#app_res-${it.id}").append(
									resource_type_html.replace(
											/resourceType_\d+/g,
											"resourceType_" + cursor).replace(
											/serialNr_\d+/g,
											"serialNr_" + cursor))
						})
				$("#app_res-${it.id}").on("click", ".btn", function() {
					//$(this).parent().toggle( "Highlight", {}, 500 );
					$(this).parent().remove()
				})

				$("#app_res-${it.id}").on("change",".resourceTypeSelection",function() {
					var resourceTypeSelection = $(this)		
					$.ajax({
						url:'loadNormalSerials',
						data: "typeId=" + this.value + "&selectionName="+this.name, 
						cache: false,
						success: function(html) {
							resourceTypeSelection.siblings(".serialSelection").html(html);
						}
		     		});
				})
			});
</script>