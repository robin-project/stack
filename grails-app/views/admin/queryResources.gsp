<script>
	var subAction = "subAction=query&";
	function initArriveDate(){
		var dateStr = "${flash.arriveDateValue}";
     	if (dateStr!=null && dateStr!=""){
         	var strArr = dateStr.split(" ");
         	if (strArr.length==3 && strArr[0]!="" && strArr[1]!="" && strArr[2]!=""){
	         	var d = new Date(new Number(strArr[2]),new Number(strArr[0]), new Number(strArr[1]));
	         	var date = [d.getDate(), d.getMonth(), d.getFullYear()].join(' ');
				$("#arriveDateInputId").attr('value',date);
             }
        }
	}
	function callQueryResources(curNum, maxNum, params, action){
		$.ajax({
			url:'queryResources',
			data: "pageId=" + curNum + "&"+action + params,
			cache: false,
			success: function(data,textStatus){
				$('#QUERY_RESOURCE_DIV').html(data);
				if (curNum == 1){
					$("#PAGE_PREV").attr('class','disabled');
				}
				if (curNum+'' == maxNum+''){
					$("#PAGE_NEXT").attr('class','disabled');
				}
				$("#PAGE_"+curNum).attr('class','active');
				initArriveDate();
			}
		});
	}

	function saveActionResource(id){
		var curNum = new Number(1);
		var maxNum = new Number(${pageCounts});
		var queryParams = $("#queryResourceForm").serialize() + "&actionComment="+$(".actionComment").val();
		if (id=="reAssignedResourceId"){	//get reAssigned user EID if it is for transferring
			var reAssignEid = $("#reAssignedEId").val();
			queryParams = queryParams + "&reAssignedUserEid="+reAssignEid;
		}
		queryParams = queryParams + "&actionId="+$("#reAssignActionArgId").val()+"&actionResList="+$("#actionResListId").val();
		callQueryResources(curNum, maxNum, queryParams, subAction);
		$('#'+id).modal('hide');
	}

	function getSelectValues(){
		var selectedGroups = new Array();
		$("input[name='resource[]']:checked").each(function() {
		    selectedGroups.push($(this).val());
		});
		return selectedGroups;
	}

	function getPageRecords(pageId, maxPage, type){
		var curNum = new Number(pageId);
		var maxNum = new Number(maxPage);
		if (curNum > maxNum || curNum < 1){
			return;
		}
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
		loadPageClass(curNum, maxNum);
		var sortName = $("#sortNameId").val();
		var queryParams = $("#queryResourceForm").serialize();
		callQueryResources(curNum, maxNum, queryParams, subAction);
	}

	function exportResource(){
		location.href="${createLink(action: 'exportResource', params:[
			queryContent:"${params.queryContent}",userBusinessInfo1:"${params.userBusinessInfo1}",userBusinessInfo2:"${params.userBusinessInfo2}",userBusinessInfo3:"${params.userBusinessInfo3}", queryResourceEid:"${params.queryResourceEid}",
			type:"${params.type}",serialNr:"${params.serialNr}",supplier:"${params.supplier}", model:"${params.model}",purpose:"${params.purpose}",productNr:"${params.productNr}",
			normalCode:"${params.normalCode}",allocatedCode:"${params.allocatedCode}",brokenCode:"${params.brokenCode}",retiredCode:"${params.retiredCode}",
			lostCode:"${params.lostCode}",returnedItioCode:"${params.returnedItioCode}",transferredCode:"${params.transferredCode}",inQuestionCode:"${params.inQuestionCode}",
			arriveDate_day:"${params.arriveDate_day}", arriveDateType:"${params.arriveDateType}",arriveDate_month:"${params.arriveDate_month}",arriveDate_year:"${params.arriveDate_year}",arriveDateValue:"${flash.arriveDateValue}",ownerCascade:"${params.ownerCascade}"])}";
	}

	function sortTable(sortProp, currPage, pages){
		$("#sortNameId").remove();
		$("#sortNameId").attr("value", sortProp);
		
		var orderName = "desc";
		if ("${params.sortName}"==sortProp){
			if ("${params.orderName}"=='desc'){
				orderName = "asc";
			}
		}
		var queryParams = $("#queryResourceForm").serialize();
		callQueryResources(currPage, pages, queryParams +"&sortName="+sortProp+"&orderName="+orderName, subAction);
	}

	function refreshArriveType(type){
		$("#arriveTypeId").value = type;
		$("#typeBtnId").html(type);
		$("#arriveDateInputId").attr('value',null);
		var curNum = new Number(${currentPage});
		var maxNum = new Number(${pageCounts});
		var action = null;
		$.ajax({
			url:'queryResources',
			data: "refreshArriveType="+type,
			cache: false,
			success: function(data,textStatus){
				$('#RESOURCE_CONDITION_ID').html(data);
			}
		});
	}

	function loadPageClass(curNum, maxNum){
		if (curNum == 1){
			if (maxNum == 1){
				$("#PAGE_LAST").attr("class", "disabled");
			}else{
				$("#PAGE_LAST").attr("class", "");
			}
			$("#PAGE_FIRST").attr("class", "disabled");
		}
		if(curNum>1 && curNum <= maxNum){
			$("#PAGE_FIRST").attr("class", "");
			if (curNum+"" == maxNum+""){
				$("#PAGE_LAST").attr("class", "disabled");
			}else{
				$("#PAGE_LAST").attr("class", "");
			}
		}
	}

	function fadeOutMsg(){
		if ("${flash.actionMessage}"!=""){
			$('.alert.alert-success').fadeOut(5000);
		}
		if ("${flash.errorMessage}"!=""){
			$('.alert.alert-error').fadeOut(5000);
		}
	}

	//validate email form
	function validateEmailForm(){
		$("#emailResourceForm").validationEngine('attach', {
			onValidationComplete: function(form, status){
				if (status){
					var queryParams = $("#emailResourceForm").serialize() + "&" + $("#queryResourceForm").serialize();
					$.ajax({
						url:'<g:createLink action="emailResources"/>',  
						type:'POST',
						data: queryParams.toString(),
						complete: function(data){  
							$("#emailResourceId").modal('hide');
							var sortName = $("#sortNameId").val();
							callQueryResources(1, "${pageCounts}", queryParams + "&" + sortName, subAction);
		                } 
			     	});
				}
			}  
		});
	}

	function closeComment(){
		$('.table td i.icon-comment').popover('hide');
	}

	//get the resource's log comment
	var actionId = null;
	$(document).ready(function(){
		//popup the resource comments
    	$('.table td i.icon-comment').on('click', function (e){
        	var resId = this.id;
        	var logInputs = $("#model-"+resId).find("input");
        	var commentTrs = "<thead><tr class='odd'><th><g:message code='comment.popover.operateUser.head'/></th><th><g:message code='comment.popover.logStatus.head'/></th><th><g:message code='comment.popover.assignedUser.head'/></th><th><g:message code='comment.popover.logDetail.head'/></th><th><g:message code='comment.popover.logDate.head'/></th></tr><thead><tbody>";
        	for (var i=0; i<logInputs.length; i++){
            	var logAttrs = logInputs[i].value.split("##");
        		commentTrs = commentTrs + "<tr><td>"+logAttrs[0]+"</td><td>"+logAttrs[1]+"</td><td>"+logAttrs[4]+"</td><td>"+logAttrs[2]+"</td><td>"+logAttrs[3]+"</td></tr>";
            }
        	commentTrs = commentTrs + "</tbody>";
        	$(this).attr("data-content", commentTrs);
        	$('.table td i.icon-comment').not(this).popover('hide');
    	});

    	$('.table td i.icon-comment').popover({
    		html:'true',
  			placement: 'right',
  			title:'<div class="span11"><strong>Comment Details</strong></div><a href="javascript:closeComment()"><i class="icon-off"></i></a>'
    	});
    	
		//initial form validation
		validateEmailForm();

		fadeOutMsg();
		actionId = null;		
     	$('input, textarea').placeholder();
     	$('#checkAllAuto').click(
     	  function(){
     		    $(".check_class").attr('checked', $('#checkAllAuto').is(':checked'));
     	     }
     	);

     	$('.action-class').click(
    		function(){
    			var resList = getSelectValues();
    			actionId = this.id;
    			$.ajax({
    				url:'selectedResources',
    				data: "checkedResource=" + resList + "&actionId=" + actionId,
    				cache: false,
    				success: function(data,textStatus){
    					$('#'+actionId+'-resource').html(data);
    				}
    			});
    		}
    	);

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
        });
        loadPageClass(new Number("${currentPage}"), new Number("${pageCounts}"));
	});

</script>
<div class="tab-content" id="QUERY_RESOURCE_DIV">
	<div class="tab-pane active span12">
		<!-- Query Condition -->
		<div class="container-fluid span12">
			<g:formRemote name="queryResourceForm" url="[action:'queryResources',controller:'admin', params:[subAction:'query']]" update="SRM-BODY-CONTENT">
				<g:render template="formQueryResources"/>
			</g:formRemote>
		</div>
		<!-- Query Result -->
		<g:if test="${resources!=null}">
			<div class="container-fluid" id="QUERY_RESULT_ID">
				<div class="span12 well">
					<g:if test="${flash.actionMessage != null}">
						<div class="span12 alert alert-success" role="status">
							<button type="button" class="close" data-dismiss="alert">&times;</button>
							${flash.actionMessage}
						</div>
					</g:if>
					<g:if test="${flash.errorMessage != null}">
						<div class="span12 alert alert-error" role="status">
							<button type="button" class="close" data-dismiss="alert alert-error">&times;</button>
							${flash.errorMessage}
						</div>
					</g:if>
					<div class="span5">
						<div class="span5 btn-group">
							<button class="btn dropdown-toggle" data-toggle="dropdown">
								<i class="icon-tasks"></i> &nbsp;<g:message code="admin.query.action.label"/>&nbsp;<span class="caret"></span>
							</button>
							<ul class="dropdown-menu">
								<li><a class="action-class" id="transferred" data-target="#transferredResourceId" data-toggle="modal"><g:message code="admin.query.transfer.label"/>&nbsp;</a></li>
								<li><a class="action-class" id="broken" data-target="#brokenResourceId" data-toggle="modal"><g:message code="admin.query.broken.label"/>&nbsp;</a></li>
								<li><a class="action-class" id="returned" data-target="#returnedResourceId" data-toggle="modal"><g:message code="admin.query.returned.label"/>&nbsp;</a></li>
								<li><a class="action-class" id="retired" data-target="#retiredResourceId" data-toggle="modal"><g:message code="admin.query.retired.label"/>&nbsp;</a></li>
								<li><a class="action-class" id="returnedItio" data-target="#returnedItioResourceId" data-toggle="modal"><g:message code="admin.query.returnitio.label"/>&nbsp;</a></li>
								<li><a class="action-class" id="lost" data-target="#lostResourceId" data-toggle="modal"><g:message code="admin.query.lost.label"/>&nbsp;</a></li>
								<li><a class="action-class" id="reAssigned" data-target="#reAssignedResourceId" data-toggle="modal"><g:message code="admin.query.reAssigned.label"/>&nbsp;</a></li>
							</ul>
						</div>
					</div>
					<div class="pull-right">
						<a id="emailId" data-target="#emailResourceId" data-toggle="modal" href="#" target="_blank"><g:message code="admin.query.result.process1"/></a>&nbsp;|&nbsp;
						<a href="javascript:exportResource()"><g:message code="admin.query.result.process2"/></a>
					</div>
				</div>
				<!-- Result Table -->
				<g:render template="resourceResultsTemplate"></g:render>
				
				<!-- render Modals  -->
				<g:render template="returnToItioModalTemplate"></g:render>
				<g:render template="returnModalTemplate"></g:render>
				<g:render template="retiredModalTemplate"></g:render>
				<g:render template="brokenModalTemplate"></g:render>
				<g:render template="lostModalTemplate"></g:render>
				<g:render template="transferredModalTemplate"></g:render>
				<g:render template="reAssignedModalTemplate"></g:render>
				<g:render template="emailResourceModal" bean="${params }"></g:render>
			</div>
		</g:if>
	</div>
</div>
