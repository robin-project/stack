<script>
	$(document).ready(function(){		
		$("#confirmSerialBatchBtn").on("click",function(){
			var serialBatchContent=$('#serialBatchInput').val().split('\n')

			var j=1
			console.log(serialBatchContent.length)
			for(var i=0;i<serialBatchContent.length;i++){
				if(j>$("#quantity").val()){
					break;
				}
				if(""==serialBatchContent[i].trim()){

				}
				else{
					$("#serial_"+j++).val(serialBatchContent[i].trim())
				}
			}
			$('#serialBatchInput').val("")
		})
	})
</script>

<div id="batchSerials" class="modal hide">
  <div class="modal-header">
		<button type="button" class="close pull-right" data-dismiss="modal" aria-hidden="true"><i class='icon-off'></i></button>
		<h3><g:message code="modal.batchSerials.label"/></h3>
  </div>
  <div class="modal-body">
  	<div class="row-fluid">
    	<g:textArea id="serialBatchInput" name="serialBatch" class="span12" rows="10" 
    		placeholder="${message(code: 'hint.serialBatch.input')}"/>
    </div>
  </div>
 		<div class="modal-footer"> 
 			<button id="confirmSerialBatchBtn" class="btn btn-primary pull-right span3"  data-dismiss="modal" aria-hidden="true">
 				<g:message code='admin.ok.btn.label'/>
 			</button>
			<div class='pull-right'>&nbsp;&nbsp;</div> 
 			<button class="btn span3 pull-right" data-dismiss="modal" aria-hidden="true">
				<g:message code='admin.cancel.btn.label' />
			</button> 
		</div> 
</div>