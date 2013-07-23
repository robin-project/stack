<g:each in="${requests}" var="req">
    <li class="nav-body" id="${req}" style="padding-left: 20px;">
        <a href="javascript:void(0)" onclick="toggle('${req.id}')">
        	<i class="icon-folder-open"/>${req.getPrintableId()}
        </a>
    </li>
    <div class="tab-pane" id="${req.id}" style="display:none; padding-left: 40px; padding-top:10px;">
        <g:render template="/common/requestDetail" model="[req:req]" />
    </div>
</g:each>