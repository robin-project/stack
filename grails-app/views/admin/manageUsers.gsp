<%@ page import="com.hp.it.cdc.robin.srm.domain.User"%>
<script>
function hideModal(id){
	$('#'+id).modal('hide')
}

$(document).ready(function() {
	$("#user_lookup").addClass("span9");
	$("#user_lookup-userBusinessInfo1").on("change",function(){
		$("input[name='Find user']").click();
	})

	//go to page
   	$("#gotoPageId").focusout(function(e){
       	var gotoPage = $("#gotoPageId").val();
       	var gotoPageNum = new Number(gotoPage);
       	var maxPageNum = new Number("${pageCounts }");
       	if (gotoPageNum > 0 && gotoPageNum <= maxPageNum){
    		getPageRecords(gotoPage, "${pageCounts }", "cur")
           }else{
           	alert("Please input valid page number!");
           }
       })
});

var queryParams = "queryContent=${params.queryContent}";

function callQueryUsers(curNum, maxNum,params){
	$.ajax({
		url:'manageUsers',
		data: "pageId=" + curNum + "&subAction=query&" + params,
		cache: false,
		success: function(data,textStatus){
			$('#QUERY_USER_DIV').html(data);
			if (curNum == 1){
				$("#PAGE_PREV").attr('class','disabled');
			}
			if (curNum+'' == maxNum+''){
				$("#PAGE_NEXT").attr('class','disabled');
			}
			$("#PAGE_"+curNum).attr('class','active');
		}
	});
}

function getPageRecords(pageId, maxPage, type){
	var curNum = new Number(pageId);
	var maxNum = new Number(maxPage);
	if (type == 'Prev'){
		if (curNum > 1){
			curNum--;
		}else{
			return;
		}
	}else if (type == 'Next'){
		if (curNum < maxNum){
			curNum++;
		}else{
			return;
		}
	}
	var sortName = $("#sortNameId").val();
	var orderName = $("#orderNameId").val();
	callQueryUsers(curNum, maxNum, queryParams + "&sortParams=" + sortName + "&orderParams=" + orderName);
}

function sortTable(sortParams, curNum, maxNum){
	$("#sortNameId").remove();
	$("#sortNameId").attr("value", sortParams);
	
	var orderParams = "desc";
	if ("${params.sortParams}"==sortParams){
		if ("${params.orderParams}"=='desc'){
			orderParams = "asc";
		}
	}
	$("#orderNameId").remove();
	$("#orderNameId").attr("value", orderParams);
	callQueryUsers(curNum, maxNum, queryParams +"&sortParams="+sortParams+"&orderParams="+orderParams);
}

</script>
<div class="tab-content" id="QUERY_USER_DIV">
	<div class="tab-pane active" id="tab6">
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
		<!--Query Users Start-->
		<g:formRemote name="myForm" 
			url="[action:'manageUsers',params:[subAction:'query'],controller:'admin']"
			update="SRM-BODY-CONTENT">
			
			<div>
				<g:render contextPath="../query" template="formQueryUsers"  model="['formId':"user_lookup"]"/>
				<input type="hidden" name="sortName" id="sortNameId"  value="${params.sortParams}" />
				<input type="hidden" name="orderName" id="orderNameId"  value="${params.orderParams}" />
				<g:submitButton name="Find user"
								value="${message(code: 'button.label.finduser', default: 'Find user')}"
								class="btn btn-primary span2" style="vertical-align:top"/>
			</div>
		</g:formRemote>

		<!--Query Users End-->
		<g:if test="${flash.totalCount !=null && flash.totalCount!=''}">
		<div>
			<p>
				<strong>Total : </strong>
				${flash.totalCount}
				<g:message code="users.query.results" default="results found" />
			</p>
		</div>
		
		<!--Results Found Start-->
		<div>
			<table class="table table-bordered table-striped">
				<thead>
					<tr>
						<th><a href="javascript:sortTable('userBusinessInfo3', ${currentPage },${pageCounts })" >${message(code: 'users.name.label', default: 'Name')}</a>
						<g:if test="${params.orderParams=='desc'&&params.sortParams=='userBusinessInfo3'}"><i class="icon-chevron-down"></i></g:if><g:elseif test="${params.orderParams=='asc'&&params.sortParams=='userBusinessInfo3'}"><i class="icon-chevron-up"></i></g:elseif></th>
						<th><a href="javascript:sortTable('userBusinessInfo2', ${currentPage },${pageCounts })">${message(code: 'users.email.label', default: 'Email')}</a>
						<g:if test="${params.orderParams=='desc'&&params.sortParams=='userBusinessInfo2'}"><i class="icon-chevron-down"></i></g:if><g:elseif test="${params.orderParams=='asc'&&params.sortParams=='userBusinessInfo2'}"><i class="icon-chevron-up"></i></g:elseif></th>
						<th><a href="javascript:sortTable('userBusinessInfo1', ${currentPage },${pageCounts })">${message(code: 'users.eid.label', default: 'EID')}</a>
						<g:if test="${params.orderParams=='desc'&&params.sortParams=='userBusinessInfo1'}"><i class="icon-chevron-down"></i></g:if><g:elseif test="${params.orderParams=='asc'&&params.sortParams=='userBusinessInfo1'}"><i class="icon-chevron-up"></i></g:elseif></th>
						<th><a href="javascript:sortTable('userBusinessInfo4', ${currentPage },${pageCounts })">${message(code: 'users.empType.label', default: 'Emp Type')}</a>
						<g:if test="${params.orderParams=='desc'&&params.sortParams=='userBusinessInfo4'}"><i class="icon-chevron-down"></i></g:if><g:elseif test="${params.orderParams=='asc'&&params.sortParams=='userBusinessInfo4'}"><i class="icon-chevron-up"></i></g:elseif></th>
						<th><a href="javascript:sortTable('manager', ${currentPage },${pageCounts })">${message(code: 'users.manager.label', default: 'Manager')}</a>
						<g:if test="${params.orderParams=='desc'&&params.sortParams=='manager'}"><i class="icon-chevron-down"></i></g:if><g:elseif test="${params.orderParams=='asc'&&params.sortParams=='manager'}"><i class="icon-chevron-up"></i></g:elseif></th>
						<th><a href="#aliasConfig" data-toggle="modal" class="btn btn-mini"><i class="icon-tasks"></i></a><a href="javascript:sortTable('userBusinessInfo5', ${currentPage },${pageCounts })">${message(code: 'users.location.label', default: 'Location')}</a>
						<g:if test="${params.orderParams=='desc'&&params.sortParams=='userBusinessInfo5'}"><i class="icon-chevron-down"></i></g:if><g:elseif test="${params.orderParams=='asc'&&params.sortParams=='userBusinessInfo5'}"><i class="icon-chevron-up"></i></g:elseif>	
						</th>
						<th><a href="javascript:sortTable('status', ${currentPage },${pageCounts })">${message(code: 'users.status.label', default: 'Status')}</a>
						<g:if test="${params.orderParams=='desc'&&params.sortParams=='status'}"><i class="icon-chevron-down"></i></g:if><g:elseif test="${params.orderParams=='asc'&&params.sortParams=='status'}"><i class="icon-chevron-up"></i></g:elseif></th>
						<th><a href="javascript:sortTable('role', ${currentPage },${pageCounts })">${message(code: 'users.role.label', default: 'Role')}</a>
						<g:if test="${params.orderParams=='desc'&&params.sortParams=='role'}"><i class="icon-chevron-down"></i></g:if><g:elseif test="${params.orderParams=='asc'&&params.sortParams=='role'}"><i class="icon-chevron-up"></i></g:elseif></th>
					</tr>
				</thead>
				<tbody>
					<g:render template="resultUserTemplate"/>
				</tbody>
			</table>
		</div>
		</g:if>
		<!-- Results Found End -->
		<!-- Pagination -->
		<g:if test="${totalCounts > message(code:"user.page.each.count", default:'10').toInteger()}">
		<div class="pagination pagination-right">
		  <ul>
		  	<g:if test="${currentPage==1 }">
		  		<li id="PAGE_FIRST"><a href="javascript:getPageRecords(1, ${pageCounts}, 'Cur')">First</a></li>
			    <li id="PAGE_PREV" class="disabled"><a href="javascript:getPageRecords(${currentPage }, ${pageCounts}, 'Prev')">Prev</a></li>
		  	</g:if>
		  	<g:else>
		  		<li id="PAGE_FIRST"><a href="javascript:getPageRecords(1, ${pageCounts}, 'Cur')">First</a></li>
		  		<li id="PAGE_PREV"><a href="javascript:getPageRecords(${currentPage }, ${pageCounts}, 'Prev')">Prev</a></li>
		  	</g:else>
		     <li><a>Page ${currentPage } of ${pageCounts}</a></li>
		    <g:if test="${currentPage==pageCounts }">
			    <li id="PAGE_NEXT" class="disabled"><a href="javascript:getPageRecords(${currentPage }, ${pageCounts}, 'Next')">Next</a></li>
		  	</g:if>
		  	<g:else>
		  		<li id="PAGE_NEXT"><a href="javascript:getPageRecords(${currentPage }, ${pageCounts}, 'Next')">Next</a></li>
		  		<li id="PAGE_LAST"><a href="javascript:getPageRecords(${pageCounts}, ${pageCounts}, 'Cur')">Last</a></li>
		  	</g:else>
		  	<li class="pull-right"><i class="icon-hand-right"></i><input id="gotoPageId" class="input-small" name="gotoPage"/><font color="#0088cc"><g:message code="label.resource.page.title"/></font></li>
		  </ul>
		</div>
		</g:if>
	</div>
</div>

<!-- Modal render-->
<g:render template="formShowUserDetails"
	collection="${userList}" />
<g:render template="formAliasConfig"
	collection="${locationList}" />