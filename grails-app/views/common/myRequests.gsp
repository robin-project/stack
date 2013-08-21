<script>
function toggle(id){
    console.log(id);
    $('div.nav.nav-list div.tab-pane:not(#'+id+')').hide();
    // $('ul > div.tab-pane:not(#'+id+')').hide();
    $('.tab-pane #'+id).toggle('fast');
}

function loadNewData(){
    /* add code to fetch new content and add it to the DOM */
    $("#requests-tab").append("<div class='loader'></div>");
    $(".pagination").hide();
    var value = $("#offsetInput").attr("value");

    $.ajax({
        dataType: "html",
        url: "${request.contextPath}/query/displayRequest?offset="+value,
        success: function(html){
            if(html){
                $(".pagination").show();
                $(html).insertAfter(".tab-pane:last");
                // $("#requests-tab").append(html);
            }
            $("#offsetInput").attr("value",parseInt(value)+1);
            $(".loader").remove();
        }
    });
}
</script>
<div class="tab-content">
    <div class="tab-pane active" id="requests">
        <div class="row-fluid span12">
            <div class="tabbable">
                <ul class="nav nav-list" id="requests-tab">
                    <li class="nav-header"><h5>Open requests</h5></li>
                    <div class="nav nav-list" id="open-requests">
                        <g:render template="/query/requests" model="[requests:openRequests]"/>
                    </div>
                    <br />
                    <li class="nav-header"><h5>Closed requests</h5></li>
                    <div class="nav nav-list" id="closed-requests">
                        <g:render template="/query/requests" model="[requests:closedRequests]"/>
                    </div>
                    <g:if test="${closedRequestsCount > 15}">
                        <div class="pagination ajax_paginate">
                            <a href="javascript:void(0)" onclick="loadNewData()">
                                <g:message code="default.paginate.more"/>
                            </a>
                        </div>
                    </g:if>
                    <input type="hidden" id="offsetInput" value="1">
                </ul>
            </div>
        </div>
    </div>
</div>