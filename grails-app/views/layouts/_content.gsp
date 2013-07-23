<div class="row-fluid">
	<div class="span12">
		<div class="row-fluid" id="SRM-BODY-CONTENT">
			<g:layoutBody />

		</div>
	</div>
</div>
			<g:render contextPath="/layouts" template="loading" />
	<g:javascript>
		
		$(document).ready(function(){		
			$('#SRM-BODY-CONTENT')
				.ajaxStart(function() {
            		$('#loading').show();
        		})
        		.ajaxStop(function() {
            		$('#loading').hide();
        		});
		});
		
	</g:javascript>