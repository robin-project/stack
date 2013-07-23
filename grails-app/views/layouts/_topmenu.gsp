<div class="navbar navbar-fixed-top">
	<div class="navbar-inner">
		<div class="container">
			<a class="btn btn-navbar" data-toggle="collapse"
				data-target=".navbar-responsive-collapse"> <span
				class="icon-bar"></span> <span class="icon-bar"></span> <span
				class="icon-bar"></span>
			</a> <a class="brand" href="#"><g:message code="srm.application.name.label" /></a>
			<div class="nav-collapse collapse navbar-responsive-collapse">
				<ul class="nav pull-right">

					<li class="divider-vertical"></li>
					<li><a href="#" class="dropdown-toggle"
						data-toggle="dropdown"> <g:if test="${session["user"]}">

								<div class="message text-left" role="status">
								
									${session["user"].userBusinessInfo3}

								</div>
							</g:if> <g:else>
								<g:link controller="signin" action="index">
									<g:message code="signin.label" default="Sign in" />
								</g:link>
							</g:else></a></li>
					<li><g:link controller="signout">
						<img src="${resource(dir: 'images', file: 'logout.png')}" data-toggle="tooltip" data-placement="bottom" title=""
		data-original-title="${message(code:'signout.label')}" size="20px"/>
									</g:link></li>
				</ul>
			</div>
			<!-- /.nav-collapse -->
		</div>
	</div>
	<!-- /navbar-inner -->


</div>