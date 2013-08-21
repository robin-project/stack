<!-- return resource Modal  -->
	<div id="returnedItioResourceId" class="modal hide" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-header">
			<button type="button" class="close pull-right" data-dismiss="modal" aria-hidden="true">
				<i class='icon-off'></i>
			</button>
			<h3><g:message code="admin.modal.action.title" args="['Return To ITIO']"/></h3>
		</div>
		<div class="modal-body">
		<div id="returnedItio-resource" class="content span12" role="main">
			<p class="text-error"><strong><g:message code="admin.modal.noselect.resource"/></strong></p>
		</div>
	</div>
	<div class="modal-footer">
		<button onclick="saveActionResource('returnedItioResourceId')" class="btn btn-primary pull-right span3">${message(code: 'admin.ok.btn.label', default: 'Ok')}</button>
		<div class='pull-right'>&nbsp;&nbsp;</div>
			<button class="btn span3 pull-right" data-dismiss="modal" aria-hidden="true">
				<g:message code='admin.cancel.btn.label' />
			</button>
		</div>
	</div>
