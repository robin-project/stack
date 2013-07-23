<%@ page import="com.hp.it.cdc.robin.srm.domain.ResourceType" %>

<g:if test="${flash.messageAddResourceType}">
	<div class="message" role="status">
		<div class="alert alert-success" role="status">
			<button type="button" class="close" data-dismiss="alert">&times;</button>
			${flash.messageAddResourceType}
		</div>
	</div>
</g:if>
								<g:hasErrors bean="${resourceTypeInstance}">
									<ul class="alert alert-error" role="alert">
										<button type="button" class="close" data-dismiss="alert">×</button>
										<g:eachError bean="${resourceTypeInstance}" var="error">
											<li
												<g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message
													error="${error}" /></li>
										</g:eachError>
									</ul>
								</g:hasErrors> 

<div class="row-fluid fieldcontain ${hasErrors(bean: resourceTypeInstance, field: 'resourceTypeName', 'error')} ">
	<label for="resourceTypeName" class="span3">
		<g:message code="resourceType.resourceTypeName.label" default="Type"/>
		
	</label>
	<g:textField name="resourceTypeName" value="${resourceTypeInstance?.resourceTypeName}" class="span8 validate[required]"  placeholder="${message(code: 'hint.resourcetype.typeName')}" />
</div>

<div class="row-fluid fieldcontain ${hasErrors(bean: resourceTypeInstance, field: 'supplier', 'error')} ">
	<label for="supplier" class="span3">
		<g:message code="resourceType.supplier.label" default="Supplier" />
		
	</label>
	<g:textField name="supplier" value="${resourceTypeInstance?.supplier}" class="span8 validate[required]" placeholder="${message(code: 'hint.resourcetype.supplier')}" />
</div>

<div class="row-fluid fieldcontain ${hasErrors(bean: resourceTypeInstance, field: 'model', 'error')} ">
	<label for="model" class="span3">
		<g:message code="resourceType.model.label" default="Model" />
		
	</label>
	<g:textField name="model" value="${resourceTypeInstance?.model}" class="span8 validate[required]" placeholder="${message(code: 'hint.resourcetype.model')}" />
</div>

<div class="row-fluid fieldcontain ${hasErrors(bean: resourceTypeInstance, field: 'productNr', 'error')} ">
	<label for="productNr" class="span3">
		<g:message code="resourceType.productNr.label" default="Product Nr" />
		
	</label>
	<g:textField name="productNr" value="${resourceTypeInstance?.productNr}" class="span8"/>
</div>

