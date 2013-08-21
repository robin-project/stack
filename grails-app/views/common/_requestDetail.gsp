<!--Details box-->
<style>
.img-rounded{ max-width:60px; myimg:expression(onload=function(){ this.style.width=(this.offsetWidth < 60)?"60px":"auto"}); }

</style>
<div class="box">
    <div class="box-header">
        <h3 class="box-title"><g:message code="request.details.label" default="Details" /></h3>
    </div>
    <div class="box-body" style="padding-top:15px;">
        <div class="container-fluid">
            <div class="row-fluid">

                <div class="span5">
                    <table class="table table-striped table-hover">
                        <tr>
<g:if test="${req.requestType == com.hp.it.cdc.robin.srm.constant.RequestTypeEnum.TRANSFER}">
                       <img width="400" height="300" src="<g:createLink controller='picture' action='get'/>?fileName=${req.requestDetail?.resource?.purchase?.resourceType?.pictureNames[0]}">
                    </g:if>
                    <g:else>
                        <img width="400" height="300" src="<g:createLink controller='picture' action='get'/>?fileName=${req.requestDetail?.resourceType?.pictureNames[0]}">
                    </g:else>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <g:if test="${req.requestType!=com.hp.it.cdc.robin.srm.constant.RequestTypeEnum.TRANSFER}">
                                    ${req.requestDetail?.resourceType?.toRequestString()}&nbsp;<span class="label label-info">${req.requestDetail?.purpose}</span>
                                </g:if> 
                                <g:else>
                                     ${req.requestDetail?.resource?.purchase?.resourceType?.toRequestString()} 
                                </g:else>
                            </td>
                        </tr>
                        <g:if test="${req.requestType==com.hp.it.cdc.robin.srm.constant.RequestTypeEnum.APPLY}">
                            <tr>
                                <td colspan="2">${req.requestDetail?.quantityNeed} <g:message code="request.requested.label" default="Quantity" />&nbsp;/&nbsp;<g:ownedResource request="${req}"/> <g:message code="request.owned.label" default="Owned" /></td>
                            </tr>
                        </g:if>
                    </table>
                </div>
                <div class="span7">
                     <div class="pull-right"><g:message code="request.status.label" default="Status" />:
                            ${message(code:req.status.labelCode+".render")} </div>                            

                    <!--Activities-->
                    <g:each in="${req.activities}" var="activity">
                        <ul class="thumbnails">
                        </ul>
                        <ul class="thumbnails">
                            <li class="span2">
                                <avatar:gravatar email='${activity.activityUser?.userBusinessInfo2}'
                                            size="60" cssClass="img-rounded"></avatar:gravatar>
                            </li>
                            <li class="bubble span10">
                                <header>
                                    <span class="label label-info">
                                        <g:set var="locationAlias" value="${com.hp.it.cdc.robin.srm.domain.Location.findByLocationCode(com.hp.it.cdc.robin.srm.domain.User.findByUserBusinessInfo3(activity.activityUser?.userBusinessInfo3).userBusinessInfo5)?.alias}"/>
                                        ${activity.activityUser?.userBusinessInfo3}
                                        <g:if test="${locationAlias!=null}">
                                            (${locationAlias})
                                        </g:if>
                                        
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
                    <g:if test="${req.status==com.hp.it.cdc.robin.srm.constant.RequestStatusEnum.NEW || req.status==com.hp.it.cdc.robin.srm.constant.RequestStatusEnum.WAITING_APPROVED}">
                         <ul class="thumbnails">
                            <li class="span2">
                                <avatar:gravatar email='${com.hp.it.cdc.robin.srm.domain.User.findByUserBusinessInfo1(req.nextActionUserBusinessInfo1)?.userBusinessInfo2}'
                                            size="60" cssClass="img-rounded"></avatar:gravatar>
                            </li>
                            <li class="bubble span10" style="border:dotted;border-color:#808080">
                                <header>
                                    <span class="label label-info">
                                        ${com.hp.it.cdc.robin.srm.domain.User.findByUserBusinessInfo1(req.nextActionUserBusinessInfo1)?.userBusinessInfo3}
                                    </span>
                                </header>
                                        <p class="muted">waiting for approval</p>
                            </li>
                        </ul>
                    </g:if>
                </div>
            </div>
        </div>
    </div>
</div>

<!--Comments box-->
<g:if test="${approval}">
    <div class="box">
        <div class="box-header">
            <h3 class="box-title"><g:message code="request.approval.label" default="Waiting for your approval...." /></h3>
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
                            update="SRM-BODY-CONTENT"  onSuccess="refreshNumber()"/>
                        <div class='pull-right'>&nbsp;</div>
                    </g:if>
                    <g:else>
                        <g:submitToRemote
                            url="[controller:'common', action:'approveRequest']"
                            class="btn btn-primary pull-right"
                            value="${message(code: 'button.label.approve', default: 'Approve')}"
                            update="SRM-BODY-CONTENT" onSuccess="refreshNumber()"/>
                        <div class='pull-right'>&nbsp;</div>
                    </g:else>
                        <g:submitToRemote 
                            url="[controller:'common', action:'declineRequest']"
                            class="btn pull-right"
                            value="${message(code: 'button.label.decline', default: 'Decline')}"
                            update="SRM-BODY-CONTENT" onSuccess="refreshNumber()"/>

                </fieldset>
            </g:form>
        </div>
    </div>
</g:if>