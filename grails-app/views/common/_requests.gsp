<g:each in="${requests}" var="req">
    <li class="nav-body" id="${req.requestType}${req.id}" style="padding-left: 20px;">
        <a href="javascript:void(0)" onclick="toggle(${req.id})"><i class="icon-folder-open"/>${req.requestType}${req.id}</a>
    </li>
    <div class="tab-pane" id="${req.id}" style="display:none; padding-left: 40px; padding-top:10px;">
        <g:render template="requestDetail" model="[req:req]" />
    </div>
</g:each>