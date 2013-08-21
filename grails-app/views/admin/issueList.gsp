			<g:each in="${issueInstanceList}" status="i" var="issueInstance">
				<g:if test="${i % 3 == 0}">
					<div class="row-fluid">
				</g:if>
				<div class="alert alert-block span4">
					<button type="button" class="close" data-dismiss="alert">×</button>
					<h4 class="alert-heading">
						${fieldValue(bean: issueInstance, field: "issueType")}
					</h4>
					<p>
						${fieldValue(bean: issueInstance, field: "detail")}
					</p>
				</div>
				<g:if test="${i % 3 == 2}">
					</div>
				</g:if>
			</g:each>