<div>
	<p>
		<strong>Total : </strong>
		${totalCounts }
		Results
	</p>
</div>
<div class="row-fluid">
	<table class="ajax table table-bordered table-striped table-hover">
		<thead>
			<tr class="odd">
				<th scope="col"><input type="checkbox" id="checkAllAuto" /></th>
				<th scope="col"><a
					href="javascript:sortTable('displayedModel', ${currentPage },${pageCounts })"
					target="_blank">
						${message(code: 'admin.query.result.tsm', default: 'Type-Supplier-Model')}
				</a><g:if test="${params.orderName=='desc'&&params.sortName=='displayedModel'}"><i class="icon-chevron-down"></i></g:if><g:elseif test="${params.orderName=='asc'&&params.sortName=='displayedModel'}"><i class="icon-chevron-up"></i></g:elseif></th>
				<th scope="col"><a
					href="javascript:sortTable('displayedProductNr', ${currentPage },${pageCounts })"
					target="_blank">
						${message(code: 'admin.query.result.product', default: 'ProductNr')}
				</a><g:if test="${params.orderName=='desc'&&params.sortName=='displayedProductNr'}"><i class="icon-chevron-down"></i></g:if><g:elseif test="${params.orderName=='asc'&&params.sortName=='displayedProductNr'}"><i class="icon-chevron-up"></i></g:elseif></th>
				<th scope="col"><a
					href="javascript:sortTable('serial',${currentPage }, ${pageCounts })"
					target="_blank">
						${message(code: 'admin.query.result.serial', default: 'Serial')}
				</a><g:if test="${params.orderName=='desc'&&params.sortName=='serial'}"><i class="icon-chevron-down"></i></g:if><g:elseif test="${params.orderName=='asc'&&params.sortName=='serial'}"><i class="icon-chevron-up"></i></g:elseif></th>
				<th scope="col"><a
					href="javascript:sortTable('status', ${currentPage },${pageCounts })"
					target="_blank">
						${message(code: 'admin.query.result.status', default: 'Status')}
				</a><g:if test="${params.orderName=='desc'&&params.sortName=='status'}"><i class="icon-chevron-down"></i></g:if><g:elseif test="${params.orderName=='asc'&&params.sortName=='status'}"><i class="icon-chevron-up"></i></g:elseif></th>
				<th scope="col"><a
					href="javascript:sortTable('purpose', ${currentPage },${pageCounts })"
					target="_blank">
						${message(code: 'admin.query.result.purpose', default: 'Purpose')}
				</a><g:if test="${params.orderName=='desc'&&params.sortName=='purpose'}"><i class="icon-chevron-down"></i></g:if><g:elseif test="${params.orderName=='asc'&&params.sortName=='purpose'}"><i class="icon-chevron-up"></i></g:elseif></th>
				
				<th scope="col"><a
					href="javascript:sortTable('currentUser',${currentPage }, ${pageCounts })"
					target="_blank">
						${message(code: 'admin.query.result.owner', default: 'Owner')}
				</a><g:if test="${params.orderName=='desc'&&params.sortName=='currentUser'}"><i class="icon-chevron-down"></i></g:if><g:elseif test="${params.orderName=='asc'&&params.sortName=='currentUser'}"><i class="icon-chevron-up"></i></g:elseif></th>
				<th scope="col"><a
					href="javascript:sortTable('displayedArriveDate',${currentPage }, ${pageCounts })"
					target="_blank">
						${message(code: 'admin.query.result.arrive', default: 'ArriveDate')}
				</a><g:if test="${params.orderName=='desc'&&params.sortName=='displayedArriveDate'}"><i class="icon-chevron-down"></i></g:if><g:elseif test="${params.orderName=='asc'&&params.sortName=='displayedArriveDate'}"><i class="icon-chevron-up"></i></g:elseif></th>
			</tr>
		</thead>
		<tbody id="bodyId">
			<g:each in="${resources}" status="i" var="res">
				<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					<td class="check"><input class="check_class" type="checkbox"
						name="resource[]" value="${res.id}" /></td>
					<td>
						${res.displayedModel}
					</td>
					<td>
						${res.displayedProductNr}
					</td>
					<td>
						${res.serial}
					</td>
					<td><g:message code='${res.status.labelCode}' /></td>
					<td>
						${res.purpose}
					</td>
					<td><g:if test="${res.currentUser!=null}">
							${res.currentUser.userBusinessInfo2}
						</g:if></td>
					<td>
						${res.displayedArriveDate }
					</td>
				</tr>
			</g:each>
		</tbody>
	</table>
</div>
<!-- Pagination -->
	<div class="pagination pagination-right row-fluid">
		<ul>
			<li id="PAGE_FIRST" class="disabled"><a href="javascript:getPageRecords(1, ${pageCounts}, 'Cur')">First</a></li>
			<g:if test="${currentPage==1 }">
				<li id="PAGE_PREV" class="disabled"><a
					href="javascript:getPageRecords(${currentPage }, ${pageCounts}, 'Prev')">Prev</a></li>
			</g:if>
			<g:else>
				<li id="PAGE_PREV"><a
					href="javascript:getPageRecords(${currentPage }, ${pageCounts}, 'Prev')">Prev</a></li>
			</g:else>
			<li><a>${currentPage } of ${pageCounts}</a></li>
			<g:if test="${currentPage==pageCounts }">
				<li id="PAGE_NEXT" class="disabled"><a
					href="javascript:getPageRecords(${currentPage }, ${pageCounts}, 'Next')">Next</a></li>
			</g:if>
			<g:else>
				<li id="PAGE_NEXT"><a
					href="javascript:getPageRecords(${currentPage }, ${pageCounts}, 'Next')">Next</a></li>
			</g:else>
				<li id="PAGE_LAST"><a href="javascript:getPageRecords(${pageCounts }, ${pageCounts}, 'Cur')">Last</a></li>
			&nbsp;&nbsp;
			<i class="icon-hand-right"></i>&nbsp;<g:textField id="gotoPageId" class="input-small" name="gotoPage"/>&nbsp;<g:message code="label.resource.page.title"/>
		</ul>
	</div>
