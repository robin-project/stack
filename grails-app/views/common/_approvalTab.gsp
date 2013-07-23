<g:each var="request" in="${openApprovals}">
    <li id="${request.requestType}${request.id}">
        <a data-toggle="tab" href="#${request.id}"> 
            <i class="icon-folder-open"/>${request.getPrintableId()}
        </a>
    </li>
</g:each>