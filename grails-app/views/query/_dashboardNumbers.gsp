<div id="dashboard-numbers" class="row-fluid" style="text-align: center;">
        %{-- <div class="span4">
            <h2 style="margin-top:0;margin-bottom:0"><dash:owned user="${session['user']}"/></h2>
            <small style="font-size: 70%"><g:message code="dash.owned" /></small>
        </div>
        <div class="span4">
            <h2 style="margin-top:0;margin-bottom:0"><dash:requested user="${session['user']}"/></h2>
            <small style="font-size: 70%"><g:message code="dash.requested" /></small>
        </div>
        <div class="span4">
            <h2 style="margin-top:0;margin-bottom:0"><dash:toAccept user="${session['user']}"/></h2>
            <small style="font-size: 70%"><g:message code="dash.toaccept" /></small>
        </div> --}%
        <table style="width:100%;text-align: center; line-height: 15px">
            <tr>
                <td><h2><dash:owned user="${session['user']}"/></h2></td>
                <td><h2><dash:requested user="${session['user']}"/></h2></td>
                <td><h2><dash:toAccept user="${session['user']}"/></h2></td>
            </tr>
            <tr style="color: #999">
                <td><small style="font-size: 70%"><g:message code="dash.owned" /></small></td>
                <td><small style="font-size: 70%"><g:message code="dash.requested" /></small></td>
                <td><small style="font-size: 70%"><g:message code="dash.toaccept" /></small></td>
            </tr>
        </table>
</div>
