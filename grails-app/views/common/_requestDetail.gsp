
<!--Details box-->
<div class="box">
    <div class="box-header">
        <h3 class="box-title"><g:message code="request.details.label" default="Details" /></h3>
    </div>
    <div class="box-body" style="padding-top:15px;">
        <div class="container-fluid">
            <div class="row-fluid">
                 <div class="span8">
                    <!--Activities-->
                    <g:each in="${req.activities}" var="activity">
                        <ul class="thumbnails"></ul>
                        <ul class="thumbnails">
                            <li class="span2">
                                <avatar:gravatar email='${activity.activityUser?.userBusinessInfo2}'
                                            size="60" cssClass="img-rounded"></avatar:gravatar>
                            </li>
                            <li class="bubble span10">
                                <header>
                                    <span class="label label-info">
                                        ${activity.activityUser?.userBusinessInfo3}
                                    </span>
                                    <g:if test="${activity.activityType==com.hp.it.cdc.robin.srm.constant.ActivityTypeEnum.DECLINED}">
                                        <span class="label label-warning">
                                    </g:if>
                                    <g:else>
                                        <span class="label label-success">
                                    </g:else>
                                        ${message(code:activity.activityType.labelCode)}
                                    </span>
                                    <span class="label">
                                        <g:formatDate format="yyyy-MM-dd" date="${activity.dateCreated}"/>
                                    </span>
                                </header>
                                        <p class="muted">${activity.comment?.encodeAsHTML()}</p>
                            </li>
                        </ul>
                    </g:each>
                </div>
                <div class="span4">
                    <table class="table table-striped table-hover">
                        <tr>
<g:if test="${req.requestType == com.hp.it.cdc.robin.srm.constant.RequestTypeEnum.TRANSFER}">
                       <img width="300" height="150" src="<g:createLink controller='picture' action='get'/>?fileName=${req.requestDetail?.resource?.purchase?.resourceType?.pictureNames[0]}">
                    </g:if>
                    <g:else>
                        <img width="300" height="150" src="<g:createLink controller='picture' action='get'/>?fileName=${req.requestDetail?.resourceType?.pictureNames[0]}">
                    </g:else>
                        </tr>
                        <tr>
                            <td><g:message code="request.status.label" default="Status" />:</td>
                            <td>${message(code:req.status.labelCode)}</td>
                        </tr>
                        <tr>
                        <td><g:message code="request.resourceType.label" default="Resource" />:</td>
                            <td>
                                <g:if test="${req.requestType!=com.hp.it.cdc.robin.srm.constant.RequestTypeEnum.TRANSFER}">
<%--                                    ${req.requestDetail?.resourceType?.resourceTypeName}--%>
<%--                                    ${req.requestDetail?.resourceType?.productNr}--%>
                                    ${req.requestDetail?.resourceType?.toRequestString()}
                                </g:if> 
                                <g:else>
<%--                                    ${req.requestDetail?.resource?.purchase?.resourceType?.resourceTypeName}--%>
<%--                                    ${req.requestDetail?.resource?.purchase?.resourceType?.productNr}--%>
                                     ${req.requestDetail?.resource?.purchase?.resourceType?.toString()}
                                </g:else>
                            </td>
                        </tr>
                        <tr>
                            <g:if test="${req.requestType!=com.hp.it.cdc.robin.srm.constant.RequestTypeEnum.TRANSFER}">
                                <td><g:message code="request.quantity.label" default="Quantity" />:</td>
                                    <td>${req.requestDetail?.quantityNeed}</td>
                            </g:if>
                            <g:else>
                                <g:if test="${req.status==com.hp.it.cdc.robin.srm.constant.RequestStatusEnum.NEW}">
                                    <td><g:message code="request.transferTo.label" default="Transfer To" />:</td>
                                    <td>${com.hp.it.cdc.robin.srm.domain.User.findByUserBusinessInfo1(req.nextActionUserBusinessInfo1)?.userBusinessInfo3}</td>
                                </g:if>
                            </g:else>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!--Comments box-->
<g:if test="${approval}">
    <div class="box">
        <div class="box-header">
            <h3 class="box-title">Waiting for your approval....</h3>
        </div>
        <div class="box-body">
            <g:form>
                <input type="hidden" name="requestId" value="${req.id }">
                <textarea class="field span12" rows="3" id="approval-comment${req.id }" name="comment"
                    placeholder="Add some comment here..."></textarea>
                <fieldset>
                    <g:if test="${req.requestType==com.hp.it.cdc.robin.srm.constant.RequestTypeEnum.TRANSFER}">
                        <g:submitToRemote url="[controller:'common', action:'acceptTransfer']"
                            class="btn btn-primary pull-right"
                            value="${message(code: 'button.label.accept', default: 'Accept')}"
                            update="SRM-BODY-CONTENT" />
                    </g:if>
                    <g:else>
                        <g:submitToRemote
                            url="[controller:'common', action:'approveRequest']"
                            class="btn btn-primary pull-right"
                            value="${message(code: 'button.label.approve', default: 'Approve')}"
                            update="SRM-BODY-CONTENT" after="loading()"
                            onSuccess="loadingDone()" onFailure="loadingDone()"/>
                    </g:else>
                    <div class='pull-right'>&nbsp;</div>
                    <g:submitToRemote 
                        url="[controller:'common', action:'declineRequest']"
                        class="btn pull-right"
                        value="${message(code: 'button.label.decline', default: 'Decline')}"
                        update="SRM-BODY-CONTENT" />
                </fieldset>
            </g:form>
        </div>
    </div>
</g:if>