<%@ page import="com.hp.it.cdc.robin.srm.domain.ResourceType" %>
<script src='<g:resource dir="js" file="jquery.customComboBox.js" />' ></script>
%{-- 	<g:javascript library="customComboBox" /> could NOT write this way, otherwise allocate resource would fail...no idea--}%

<div id="inlineEdit">
		<g:form name="inlineAddResourceType" update="currentResourceType" before="setFormValues()">
			<div>
				<p><strong><g:message code="resourceType.new.label"/></strong></p>
			</div>
			<div class="row-fluid"><div class="span3"><g:message code="hint.resourcetype.typeName"/></div>
				<div><span class=" ${hasErrors(bean: resourceTypeInstance, field: 'resourceTypeName', 'error')} ">
					<g:select class="validate[required]" name='resourceTypeName' from='${com.hp.it.cdc.robin.srm.domain.ResourceType.list().resourceTypeName.unique().sort()}'/>
				</span></div></div>
			<div class="row-fluid"><div class="span3"><g:message code="hint.resourcetype.supplier"/></div>
				<div><span class=" ${hasErrors(bean: resourceTypeInstance, field: 'supplier', 'error')} ">
					<g:select class="validate[required]" name='supplier' from='${com.hp.it.cdc.robin.srm.domain.ResourceType.list().supplier.unique().sort()}'/>
				</span></div></div>
			<div class="row-fluid"><div class="span3"><g:message code="hint.resourcetype.model"/></div>
				<div><span class=" ${hasErrors(bean: resourceTypeInstance, field: 'model', 'error')} ">
					<g:select class="validate[required]" name='model' from='${com.hp.it.cdc.robin.srm.domain.ResourceType.list().model.unique().sort()}'/>
				</span></div>
			</tr>
			<div class="row-fluid"><div class="span3"><g:message code="hint.resourcetype.productNr"/></div>
			<div class=" ${hasErrors(bean: resourceTypeInstance, field: 'productNr', 'error')} ">
					<g:textField id="newProductNrId" name="productNr" placeholder="${message(code: 'hint.resourcetype.productNr')}"/>
				</div>
			</div>
			<div class="row-fluid">
				<div>
					<fieldset class="form-actions">
						<g:submitButton class="btn btn-primary pull-right" name="add"  value="${message(code: 'hint.resourcetype.add', default: 'Add')}"/>
					</fieldset>
				</div>
			</div>
		</g:form>
</div>
<style type="text/css">
	.edit-combo-box { 
		color: red; 
		font-style: italic 
	}
</style>
<script>
    function setFormValues(){
    	/*$("input[name='resourceTypeName']").val($("select[name='resourceTypeNameSelect']").val())
    	$("input[name='supplier']").val($("select[name='supplierSelect']").val())
    	$("input[name='model']").val($("select[name='modelSelect']").val())*/
    }

	function cleanInlineForm(){
		$("#inlineEdit select").val("")
	}

	$(document).ready(function(){	
		/*$("select[name='resourceTypeNameSelect']").eComboBox();
		$("select[name='supplierSelect']").eComboBox();
		$("select[name='modelSelect']").eComboBox();*/

		//add new option to edit
		addNewOption("select[name='resourceTypeName'] , select[name='supplier'] , select[name='model'] ");
	})
</script>





