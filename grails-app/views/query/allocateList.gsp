<g:each in="${requestInstanceList}" status="i" var="requestInstance">
	<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
		<td><div class="btn-group">
				<button class="btn dropdown-toggle" data-toggle="dropdown">
					<i class="icon-tasks"></i> &nbsp;
					<g:message code="action.button.label" />
					&nbsp;<span class="caret"></span>
				</button>
				<ul class="dropdown-menu">
					<li><a href="#allocateForRequest-${requestInstance.id}"
						role="button" data-toggle="modal"> <i class="icon-ok-sign"></i>&nbsp;<g:message
								code="requestallocate.button.label" />&nbsp;
					</a></li>
					<li><a href="#viewForRequest-${requestInstance.id}"
						role="button" data-toggle="modal"> <i class="icon-eye-open"></i>&nbsp;<g:message
								code="requestview.button.label" />&nbsp;
					</a></li>
					<li><a href="#" role="button" data-toggle="modal"
						onclick="closeRequest(${requestInstance.id});"> ${message(code:"requestclose.button.label")}
					</a>
				</ul>

			</div>
			<form id="closeRequest-${requestInstance.id}" style="display: none">
				<g:hiddenField name="requestId" value="${requestInstance.id}" />

				<g:submitToRemote id="closeRequestSubmit-${requestInstance.id}"
					class="hide" url="[action:'closeRequest']"
					update="SRM-BODY-CONTENT" value="" />

			</form></td>
		<td>req-apply-${requestInstance.id}
		</td>


		<td>
			${requestInstance.requestDetail.resourceType.resourceTypeName}- ${requestInstance.requestDetail.resourceType.supplier}-
			${requestInstance.requestDetail.resourceType.model}
		</td>
		<td><g:message code='${requestInstance.status.labelCode}.render' />


			<label class="badge">
				${requestInstance.requestDetail.quantityAllocate} /${requestInstance.requestDetail.quantityNeed}
		</label></td>
		<td>
			${requestInstance.submitUser.userBusinessInfo3}
		</td>
		<td>
			${requestInstance.requestDetail.purpose}
		</td>
	</tr>
</g:each>

