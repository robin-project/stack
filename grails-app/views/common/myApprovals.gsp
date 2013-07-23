<script type="text/javascript">
$('#Approval-Tab a:first').tab('show');
$('.alert.alert-success').fadeOut(5000);

function loading(){
   // $("#loading-indicator").show();
}

function loadingDone(){
   // $("#loading-indicator").hide();
}

function loadingMoreApprovals(){
    $("#Approval-Tab").append("<div class='loader'></div>");
    $(".pagination").hide();
    var value = $("#offsetInput").attr("value");

    $.ajax({
        dataType: "html",
        url: "${request.contextPath}/query/displayApprovalTab?offset="+value,
        success: function(html){
            if(html){
                $(".pagination").show();
                $("#Approval-Tab").append(html);
            }
            $("#offsetInput").attr("value",parseInt(value)+1);
            $(".loader").remove();
        }
    });

    $.ajax({
        dataType: "html",
        url: "${request.contextPath}/query/displayApprovalContent?offset="+value,
        success: function(html){
            if(html){
                $("#Approval-Content").append(html);
            }
        }
    });
}
</script>
<div class="tab-content">
    <div class="tab-pane active" id="approvals">
        <div class="container-fluid">
            <div class="row-fluid">
                <g:if test="${!openApprovals}">
                    <g:if test="${flash.message}">
                        <div class="alert alert-success" role="status">
                            <button type="button" class="close" data-dismiss="alert">&times;</button>
                            ${flash.message}
                        </div>
                    </g:if>
                    <g:if test="${flash.error}">
                        <div class="alert alert-error">
                            <button type="button" class="close" data-dismiss="alert">&times;</button>
                            ${flash.error}
                        </div>
                    </g:if>
                    <div class="alert alert-info">
                        <button type="button" class="close" data-dismiss="alert">&times;</button>
                        <g:message code="no.open.approval"/>
                    </div>
                </g:if>
                <g:else>
                    <div class="span3">
                        <div class="tabbable tabs-left">
                            <ul class="nav nav-list" id="Approval-Tab">
                                <g:render template="/common/approvalTab" model="[openApprovals:openApprovals]"/>
                                <input type="hidden" id="offsetInput" value="1">
                            </ul>
                            <div class="pagination ajax_paginate"><a href="javascript:void(0)" onclick="loadingMoreApprovals()"><g:message code="default.paginate.more"/></a></div>
                        </div>
                    </div>
                    <div class="span9">
                        <g:if test="${flash.message}">
                            <div class="alert alert-success" role="status">
                                <button type="button" class="close" data-dismiss="alert">&times;</button>
                                ${flash.message}
                            </div>
                        </g:if>
                        <div class="tab-content" id="Approval-Content">
                            <g:render template="/common/approvalContent" model="[openApprovals:openApprovals]"/>
                        </div>
                    </div>
                </g:else>
            </div>
        </div>
    </div>
</div>