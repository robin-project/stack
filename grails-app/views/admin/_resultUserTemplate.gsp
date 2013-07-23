<g:each in="${userList}" status="i" var="user">
<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
	<td><a href="#showUserDetails-${user.id}" data-toggle="modal" class="btn btn-mini" >
			<i class="icon-pencil"></i>
		</a>
		${user.userBusinessInfo3}
	</td>
    <td>${user.userBusinessInfo2}</td>
    <td>${user.userBusinessInfo1}</td>
    <td>${user.status}</td>
    <td>${user.role}</td>
</tr>
</g:each>
