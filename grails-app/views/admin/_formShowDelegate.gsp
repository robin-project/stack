<%@ page import="com.hp.it.cdc.robin.srm.constant.*" %>
<%@ page import="com.hp.it.cdc.robin.srm.domain.*" %>
<div id="delegate_res">
	<g:message code="resource.delegate.title"/>
	<g:form url="[action:'delegateResources',controller:'admin']">
		<div class="form-horizontal">
			<g:select name="assistUserEmail" noSelection="['':'-Choose assist email-']" from="${User.findAllByRole(RoleEnum.ADMIN_ASSIST).userBusinessInfo2}"/>
			<a class="btn">${message(code:'check.assist.label', default:'Check Account') }</a>
			<g:each in="${deleRes }" var="res">
				<p>${res.id }</p>
			</g:each>			
		</div>
		<div>
			<g:submitButton class="btn btn-primary" name="${message(code:'btn.ok.label', default:'Ok') }"/>
			<g:submitButton class="btn btn-default" name="${message(code:'btn.cancel.label', default:'Cancel') }"/>
		</div>
	</g:form>
</div>