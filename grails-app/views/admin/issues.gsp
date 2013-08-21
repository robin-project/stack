<div class="tab-content">
	<div class="tab-pane active" id="tab5">
		<div id="issueDash">
			<input type="hidden" id="offsetInput" value="1">
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

		</div>
		<div id="loadMoreIssue" class="pagination ajax_paginate">
			<a href="#" onclick="loadMoreIssue()"><g:message code="default.paginate.more"/></a>
		</div>
		<div id="end">
	</div>
</div>


<script>
function loadMoreIssue(){
    /* add code to fetch new content and add it to the DOM */
    var value = $("#offsetInput").attr("value");
	
    $.ajax({
        dataType: "html",
        url: "issueList?offset="+value,
        success: function(html){
            if(html){
                
                if (html.length>5){
                	$("#issueDash").append(html);

                }else{
                	$('#loadMoreIssue').hide();
                }
            }
            $("body,html").scrollTo("#end");
            $("#offsetInput").attr("value",parseInt(value)+1);
        }
    });
}

	$(document).ready(function(){		
			if($("#issueDash > div .alert").size()<12){
				$('#loadMoreIssue').hide();
			}
	});
</script>
