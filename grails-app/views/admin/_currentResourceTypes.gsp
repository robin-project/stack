<style>
	.iconClass{ max-width:20px; myimg:expression(onload=function(){ this.style.width=(this.offsetWidth > 20)?"20px":"auto"}); }
</style>
<div>
<g:set var="resourceTypeList" value="${com.hp.it.cdc.robin.srm.domain.ResourceType.findAll()}" />
				<g:if test="${resourceTypeList.size==0}">
					no result found.
				</g:if>
				<g:if test="${flash.messageAddResourceType}">
					<div class="alert alert-success messageAddResourceType" role="status">
						${flash.messageAddResourceType}
					</div>
				</g:if>
				<g:if test="${flash.errorAddResourceType}">
					<div class="alert alert-error messageAddResourceType" role="status">
						${flash.errorAddResourceType}
					</div>
				</g:if>
</div>
<div>
<table id="currentResourceType" class="table table-hover table-striped">
	<tbody>	
		<g:each in="${resourceTypeList.sort(new java.util.Comparator<com.hp.it.cdc.robin.srm.domain.ResourceType>() {
 										public int compare(com.hp.it.cdc.robin.srm.domain.ResourceType lhs, com.hp.it.cdc.robin.srm.domain.ResourceType rhs) {
 											
    									    def level1 = lhs.resourceTypeName.toLowerCase().compareTo(rhs.resourceTypeName.toLowerCase())
  											if (level1 != 0){
  												return level1
  											}else{
  												def level2 = (lhs.model.toLowerCase()).compareTo(rhs.model.toLowerCase())
  												if (level2 != 0){
  													return level2
  												}else{
  													
  													return (lhs.supplier.toLowerCase()).compareTo(rhs.supplier.toLowerCase())
  													
  												}
  											}
  										}
								})}" status="i" var="rtInstance">
			<tr><td>
				<g:if test="${rtInstance.isBlock}">
					<a href="#" onclick="toggleResourceType('${rtInstance.id}')">
                       <g:img class="iconClass" dir="images" file="ban.jpg" width="20" height="20"/></a>
				</g:if><g:else>
					<a href="#" onclick="toggleResourceType('${rtInstance.id}')">
						<g:img class="iconClass" dir="images" file="check.jpg" width="20" height="20"/></a>
				</g:else></td>
			<td>${rtInstance}</td>
%{-- 			<td>${rtInstance.supplier}</td>
			<td>${rtInstance.model}</td>
			<td>${rtInstance.productNr}</td> --}%
			%{-- <td>&nbsp;</td> --}%</tr>
		</g:each>
	</tbody>
</table>
</div>
<script>
	
	function toggleResourceType(id){
		$.ajax({
			url:'toggleResourceTypeStatus',
			data: "typeId=" + id, 
			cache: false,
			success: function(html) {
					$('#currentResourceType').html(html);
				}
		    });
	}

	function fadeOutMsg(){
		if ("${flash.messageAddResourceType}"!=""){
			$('.alert.alert-success').fadeOut(5000);
		}
		if ("${flash.errorAddResourceType}"!=""){
			$('.alert.alert-error').fadeOut(5000);
		}
	}
	
	$(document).ready(function(){		
		//automatic close the alert message after 5 seconds
		fadeOutMsg();
	})
</script>


		