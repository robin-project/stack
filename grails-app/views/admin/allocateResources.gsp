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


			<div class="navbar">
              <div class="navbar-inner">
                <ul class="nav">
                  <li><a href="#allocateWOrequest" data-toggle="modal"> 
						<i class="icon-exclamation-sign"></i> &nbsp; 
						<g:message code="allocateWOrequest.button.label" />
					</a></li><li class="divider-vertical"></li>
                  <li><a id="bookTime" href=""data-toggle="modal"> 
						<i class="icon-envelope"></i> &nbsp; 
						<g:message code="booktime.button.label" />
					</a></li><li class="divider-vertical"></li>
                  <li class="pull-right"><g:render contextPath="../query" template="formQueryUsers"  model="['formId':"allocateUserFilter"]"/></li>
                </ul>
              </div>
            </div>
			
			<input type="hidden" id="offsetInput" value="1">
			<table class="table table-hover table-striped">
				<thead>
					<tr>
						<th></th>
						<th>
							${message(code: 'action.label', default: 'Action')}
						</th>

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
							${message(code: 'request.manager.label', default: 'Manager')}
						</th>
						<th>
							<a href="#aliasConfigForAllocate" data-toggle="modal" class="btn btn-mini"><i class="icon-tasks"></i></a>${message(code: 'request.location.label', default: 'Location')}
							
						</th>
					</tr>
				</thead>
				<tbody id="allocateList">
					<g:render contextPath="/query" template="allocateList"/>
				</tbody>
			</table>

		</div>
	</div>
</div>

		<%--<div id="loadMore" class="pagination ajax_paginate">
			<a href="#" onclick="loadMoreAllocate()"><g:message code="default.paginate.more"/></a>
		</div>--%>
		<div id="end">
</div>

<g:render template="formAllocateWOrequest"/>

<g:render template="formAliasConfigForAllocate"
	collection="${locationList}" />
	
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
                if (html.length>5){
                	$("#allocateList").append(html);
                	$("body,html").scrollTo("#end");
                }else{
                	$('#loadMore').hide();
                }
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

	$(document).ready(function(){		
			if($("#allocateList > tr").size()<10){
				$('#loadMore').hide();
			}
			$("#allocateUserFilter").css("margin-top","5px").css("margin-bottom","5px");

			$('#allocateUserFilter-userBusinessInfo1').on("change",function(){
				    $.ajax({
        				dataType: "html",
        				url: "${request.contextPath}/query/allocateList?userBusinessInfo1="+$(this).val(),
        				async: false,
        				success: function(html){
            				if(html){
                				$("#allocateList").html(html)
                				$('#loadMore').hide();
            				}
       					 }
    				});//end ajax

    				$.ajax({
        				dataType: "html",
        				url: "renderAllocateModels?userBusinessInfo1="+$(this).val(),
        				async: false,
        				success: function(html){
            				if(html){
                				$("#allocateModals").html(html);
                			}
        			        }
    				});//end ajax

    				$.ajax({
        				dataType: "html",
        				url: "renderViewModels?userBusinessInfo1="+$(this).val(),
        				async: false,
        				success: function(html){
            				if(html){
                				$("#viewModals").html(html);}
    						}
    				});//end ajax
			})//end on change

            $("#bookTime").click(function(){
                var subject = "Get your approved IT resources"
                //var body = " \n  Request ID \t  Resource  \t  Purpose  \t Quantity \t Submitter "
                var body = " \n "
                var greeting = "Hi all, \nThe IT resources you applied below are approved. Plz come to my cube (B7, 1st floor, Building C, VIA) to get it 2:00pm---5:30pm today. Thanks! \n"
                var signature = "\n Best Regards! \n "
                var to = ""
                $("#allocateList tr").
                    map(function(){
                        if($("td:first-child input",this)[0].checked){
                            //console.dir($("td",this)[3].innerText)
                            body += $("td",this)[2].innerText.trim() + " \t " + $("td",this)[3].innerText.trim().replace("\n","\t") + " \t " +  $($("td",this)[4]).attr('data-quantity') +  " \t " + $("td",this)[5].innerText.trim() + " \n "
                            to += $("td",this)[5].title + ";"
                        }
                    })
                var mailto = "mailto:"+ to +"?subject="+ subject +"&body=" + encodeURIComponent(greeting+body+signature)
                $(this).attr('href',mailto)
            })
	});//end document ready
</script>





