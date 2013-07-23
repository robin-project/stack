 <g:each var="req" in="${openApprovals}">
    <div class="tab-pane" id="${req.id}">
        <div id="loading-indicator" class="context-loader">
            <img src="${resource(dir:'images',file:'spinner.gif')}" alt="Loading" />
            <p>Loading…</p>
        </div>
        <g:render template="/common/requestDetail" model="[req:req,approval:'true']" />
    </div>
</g:each>