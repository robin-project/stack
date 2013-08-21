

<g:each in="${selectedResourceType.pictureNames}">
<li class="" style="margin:0px"><a href="#" class="thumbnail"
	data-toggle="modal"> <img
			data-src="holder.js/260x180" style="width: 40px; height: 40px;"
			src="<g:createLink controller='picture' action='get'/>?fileName=${it}" />
	</a></li>
</g:each>
<li class="" style="margin:0px"><a href="#addPicture" class="thumbnail"
	data-toggle="modal"> <img data-src="holder.js/260x180"
		style="width: 40px; height: 40px;"
		src='<g:resource dir="images" file="tile_add.png"/>' />
</a></li>

<!-- Modal -->
<form enctype="multipart/form-data" method="post" action="addPicture" id="addPictureForm">
<div id="addPicture" class="modal hide fade" tabindex="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal"
			aria-hidden="true">
			<i class='icon-off'></i>
		</button>
		<h3 id="myModalLabel">
			<g:message code="modual.addPicture.label" />
		</h3>
	</div>
<script type="text/javascript">
$("#addPictureForm").iframePostForm({
	iframeID: 'iframe-post-form',
	post: function(){
		// uploading, can show some message or do nothing
	},
	complete: function(response){
		// console.log(response);
		// upload finished callback
		hideModal('addPicture')
		$("#resourceType").change()
	}
});
</script>

		<div class="modal-body">
			<div id="create-resourceType" class="content span12" role="main">
				<g:hiddenField name="resourceTypeId"
					value="${selectedResourceType.id}" />
				<div class="fieldcontain row-fluid">
					<label for="pictureBinary"> <g:message
							code="picture.pictureBinary.label" default="Picture Binary" />

					</label> <input type="file" id="pictureBinary" name="pictureBinary" />
				</div>

			</div>
		</div>

		<%--						<g:submitButton name="create" class="btn btn-primary save"--%>
		<%--							value="${message(code: 'default.button.create.label', default: 'Create')}" />--%>
		<div class="modal-footer">
		<%-- <g:submitToRemote name="upload" url="[action:'addPicture']"
				class="btn btn-primary pull-right span3"
				value="${message(code: 'default.button.upload.label', default: 'Upload')}"
				update="SRM-BODY-CONTENT" after="hideModal('addPicture')"/>

			<input
				onclick="jQuery.ajax({type:'POST',data:jQuery(this).parents('form:first').serialize(), url:'/srm-web/admin/addPicture',success:function(data,textStatus){jQuery('#SRM-BODY-CONTENT').html(data);},error:function(XMLHttpRequest,textStatus,errorThrown){}});hideModal('addPicture');return false"
				type="button" name="upload" value="Upload"
				class="btn btn-primary pull-right span3"> --%>
			<input type="submit" value="Submit" class="btn btn-primary pull-right span3">
			<div class='pull-right'>&nbsp</div>
			<button class="btn span3 pull-right" data-dismiss="modal"
				aria-hidden="true">
				<g:message code='default.button.cancel.label' />
			</button>
		</div>
	</div>
</form>