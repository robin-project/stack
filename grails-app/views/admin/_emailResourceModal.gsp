<script>

	$(document).ready(function() {
		var cursor = 1
		var email_text_html = $("#email_text").html()
		$("#plusId").click(function() {
			cursor++;
			$("#email_text").append(
				email_text_html.replace(/emailAddress_\d+/g, "emailAddress_" + cursor));
		});
		$("#email_text").on("click", ".btn", function() {
			$(this).parent().remove()
		});
	});

</script>
<!-- email resource Modal  -->
<g:form name="emailResourceForm">
	<div id="emailResourceId" class="modal hide" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-header">
			<button type="button" class="close pull-right" data-dismiss="modal" aria-hidden="true">
				<i class='icon-off'></i>
			</button>
			<h3><g:message code="admin.modal.action.title" args="['Email']"/></h3>
		</div>
		<div class="modal-body">
			<div id="email-resource" class="content span12" role="main" style="margin-top:10px">
				<p><g:message code="email.modal.address.label"/></p>
				<div id="email_text">
					<div class="control-group form-horizontal">
				      	<span class="add-on"><i class="icon-envelope"></i></span>
					  	<g:textField class="validate[required, custom[email]]" name="emailAddress_1"/>
						<button type="button" class="btn btn-small"><i class="icon-minus"></i></button>
				    </div>
				</div>
				<button id="plusId" type="button" class="btn btn-small"><i class="icon-plus"></i></button>
			</div>
		</div>
		<div class="modal-footer">
			<g:submitButton class="btn btn-primary pull-right span3" name="ok" value="${message(code: 'admin.ok.btn.label', default: 'Ok')}"/>
			<div class='pull-right'>&nbsp;&nbsp;</div>
				<button class="btn span3 pull-right" data-dismiss="modal" aria-hidden="true">
					<g:message code='admin.cancel.btn.label' />
				</button>
		</div>
	</div>
</g:form>
