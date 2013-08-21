<option value=""></option>
<g:each var="i" in="${resourceType_list}">
<option value="${i.id}" data-filter-one="${i.resourceTypeName}" >${i.model} (${i.supplier})</option>
</g:each>