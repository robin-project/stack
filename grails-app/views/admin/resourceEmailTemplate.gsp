<%@ page contentType="text/html" %>
<html lang="en" class="no-js">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
</head>
<body>
	<div>
					<table class="table" >
					    <thead>
			                <tr style="background-color:#eeeeee">
			                  <th scope="col"><g:message code="admin.query.result.title1"/></th>
			                  <th scope="col"><g:message code="admin.query.result.title2"/></th>
			                  <th scope="col"><g:message code="admin.query.result.title3"/></th>
			                  <th scope="col"><g:message code="admin.query.result.title4"/></th>
			                  <th scope="col"><g:message code="admin.query.result.title5"/></th>
			                  <th scope="col"><g:message code="admin.query.result.title6"/></th>
			                  <th scope="col"><g:message code="admin.query.result.title7"/></th>
			                </tr>
			              </thead>
			              <tbody>
			              	<g:each in="${resources}" var="res">
								<tr class="odd" style="background-color:'white'">
									<td><a>${res.id}</a></td>
									<td>${res.status}</td>
									<td>${res.purchase.resourceType.resourceTypeName}</td>
									<td>${res.purchase.resourceType.supplier}</td>
									<td>${res.purchase.resourceType.model}</td>
									<td>${res.serial}</td>
									<td>${res.currentUser.userBusinessInfo2}</td>
								</tr>
			              	</g:each>
						  </tbody>
					</table>
				</div>
</body>
</html>