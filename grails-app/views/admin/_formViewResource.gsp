<!-- Modal viewRequest-->
<style>
.avatar{ max-width:20px; myimg:expression(onload=function(){ this.style.width=(this.offsetWidth > 20)?"20px":"auto"}); }

</style>
<g:form id="viewForRequestForm">
	<div id="viewForRequest-${it.id}" class="modal hide">
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
							<label class="badge">${it.requestDetail.quantityAllocate} /${it.requestDetail.quantityNeed}</label></td>
						</tr>
					</thead>
					<tbody>
						<g:each in="${it.activities}" var="activity">
							<tr>
								<td>&nbsp;&nbsp;&nbsp;</td>
								<!-- class warn success info -->
								<td><avatar:gravatar
										email="${activity.activityUser.userBusinessInfo2}"/></td>
								<td>
									${activity.activityUser.userBusinessInfo3}
								</td>
								<td>
									${message(code:activity.activityType.labelCode)}
								</td>
								<td>
									<g:formatDate date='${activity.dateCreated}' format='yyyy-MM-dd' />
								</td>
							</tr>
						</g:each>
					</tbody>
				</table>
			</div>
		</div>

		<div class="modal-footer">
<%--			<g:submitToRemote url="[action:'allocate']"--%>
<%--				class="btn btn-primary pull-right span3"--%>
<%--				value="${message(code: 'allocate.button.label', default: 'Allocate')}"--%>
<%--				update="SRM-BODY-CONTENT" after="hideModal('addResourceType')" />--%>
<%--			<div class='pull-right'>&nbsp;</div>--%>
			<button class="btn btn-primary span3 pull-right" data-dismiss="modal"
				aria-hidden="true">
				<g:message code='admin.ok.btn.label' />
			</button>
		</div>

	</div>
</g:form>
