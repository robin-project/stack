<!DOCTYPE html>
<html>
<head>
<meta name="layout" content="main">
<g:set var="entityName"
	value="${message(code: 'admin.label', default: 'Common')}" />
</head>
<body>

	<div class="tab-content">
		<div class="tab-pane .fade active" id="tab1">
			<ul class="thumbnails">
				<li class="span6">
					<div class="thumbnail">
						<avatar:gravatar email='{session["user"].userBusinessInfo2' alt="My Avatar"
							size="100" />

						<div class="caption">
							<h3>${session["user"].userBusinessInfo3}</h3>
							<p>...</p>

						</div>
					</div>
				</li>

			</ul>

		</div>

	</div>



</body>
</html>
