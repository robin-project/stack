<div>
	<div>
		<g:if test="${checkedResults != null}">
			<Strong><g:message code="admin.query.resource.title" args="${flash.args }"/></Strong>
		</g:if>
	</div>
	<div>
		<g:if test="${checkedResults == null}">
			<p class="text-error"><strong>Please select the resources to return!</strong></p>
		</g:if>
		<g:else>
			<table class="table table-bordered table-striped table-hover">
				<thead>
					<tr class="odd">
						<th scope="col">${message(code: 'admin.query.result.id', default: 'Resource Id')}</th>
					    <th scope="col">${message(code: 'admin.query.result.supplier', default: 'Supplier')}</th>
					    <th scope="col">${message(code: 'admin.query.result.model', default: 'Model')}</th>
					    <th scope="col">${message(code: 'admin.query.result.serial', default: 'Serial')}</th>
					</tr>
				</thead>
				<tbody id="bodyId">
					<g:each in="${checkedResults}" status="i" var="res">
						<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
							<td>${res.getPrintableId()}</td>
							<td>${res.purchase.resourceType.supplier}</td>
							<td>${res.purchase.resourceType.model}</td>
							<td>${res.serial}</td>
						</tr>
					</g:each>
				</tbody>
			</table>
		</g:else>
	</div>
</div>
