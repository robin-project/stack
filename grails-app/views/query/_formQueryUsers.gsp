<%@ page import="com.hp.it.cdc.robin.srm.constant.*"%>
<%@ page import="com.hp.it.cdc.robin.srm.domain.*"%>

	<input	type="text" name="queryContent" id="${formId}" class="basicTypeahead"
			placeholder="${message(code: 'hint.users.finduser')}"
			value="${params.queryContent}"
			autocomplete="off"
			data-provide="typeahead"/>
	
	<input type="hidden" name="userBusinessInfo1" id="${formId}-userBusinessInfo1"/>
	<input type="hidden" name="userBusinessInfo2" id="${formId}-userBusinessInfo2"/>
	<input type="hidden" name="userBusinessInfo3" id="${formId}-userBusinessInfo3"/>
	
<script>
var array = new Array()
var user_lookup_callback_function = function(item){}
$(document).ready(function() {
	jQuery("#${formId}").typeahead({
		source:  function(query, process) {
					var req = $.ajax({
				    	url: "${request.contextPath}/query/lookupUser?queryContent="+query+"&status=${status}",
				        type: 'get',
				        async: false,
				        global: false,
				        success: function(responseText) {
				        	array = new Array()
				        	for(var i=0;i<responseText.users.length;i++){
			            	 	array[i]=responseText.users[i].name +"  "+ responseText.users[i].eid +"  "+ responseText.users[i].email
			            	 	array[i].user=responseText.users[i]
							}
				        }
				    })
				    return array
				}
		,minLength:1
		,items:15
		,updater:function(item){
			$('#${formId}-userBusinessInfo1').val(item.split("  ")[1]).trigger("change");
			$('#${formId}-userBusinessInfo2').val(item.split("  ")[2]);
			$('#${formId}-userBusinessInfo3').val(item.split("  ")[0]);
			user_lookup_callback_function(item)
			return item.split("  ")[0]
		}
		,highlighter: function(item){
			var user = new Object()
			user.eid = item.split("  ")[1]
			user.email = item.split("  ")[2]
			user.name = item.split("  ")[0]
			var content = "<b>"+user.name+"</b>  <small>"+user.email+"</small><br/>" +user.eid

			var query = this.query.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, '\\$&')
			content = content.replace(new RegExp('(' + query + ')', 'ig'), function ($1, match) {
		        return '<font style="text-decoration:underline">' + match + '</font>'
		    })
		    return "<div>"+content+"</div>" 
	    }
	}).blur(function(){
		if($('#${formId}-userBusinessInfo3').val()!=$(this).val()){
			$('#${formId}-userBusinessInfo1').val("");
			$('#${formId}-userBusinessInfo2').val("");
			$('#${formId}-userBusinessInfo3').val("");
		}
	})
});
</script>
