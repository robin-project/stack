<link rel="stylesheet" href="${resource(dir: 'css', file: 'resource.css')}" type="text/css">
<div class="row-fluid">
    <div class="span12" style="margin-bottom:20px">
        <input type="text" class="input-xxlarge span12" id="filter">
    </div>

    <ul class="tile-group span10" style="display:none;overflow: hidden;padding-top: 5px;padding-left: 2px;">
      %{-- apply new resource --}%
      <li class="span3" data-toggle="tooltip" data-placement="bottom" title="" data-original-title="Apply new resources">
          <a class="tile image res_apply_btn"
            href="#applyResources" data-toggle="modal"> 
            <div class="tile-content">
              <img
                src="${resource(dir: 'images', file: 'tile_add.png')}" >
            </div>
          </a>
      </li>
      %{-- allocated resources --}%
    	<g:each in="${res_list}">
        <%
          boolean is_transferred=false
          transfer_list.each{ transfer_req ->
            if(transfer_req.requestDetail.resource.equals(it)){
              is_transferred=true
            }
          }
        %>
    		<li class="span3 allocated_res" data-filter-id="${it.id}" data-filter-keyword="Resource Category: ${it.purchase.resourceType.resourceTypeName}|Resource Model: ${it.purchase.resourceType.model}|Serial: ${it.serial}<%
            if(is_transferred){
        %>|Resource Status:Transferring<%  }else{
        %>|Resource Status: ${message(code:it.status.labelCode)}<%
            }
        %>">
          <a href="#" class="tile image <% if(is_transferred)out << 'transfer_res' %>">
                
            <div class="tile-content">
                <img src="<g:createLink controller='picture' action='get'/>?fileName=${it.purchase.resourceType.pictureNames[0]}">
            </div>
            <div class="brand bg-color-blueDark" style="height:20px">
                <p class="text">${it.serial} <label class='badge badge-info pull-right ' style="margin-right:15px">${message(code:it.status.labelCode)}</label></p>
                <p class="text">${it.purchase.resourceType.resourceTypeName} ${it.purchase.resourceType.model}</p>
                <p class="text">${it.purpose}</p>
            </div>
          </a>
    		</li>
    	</g:each>
      %{-- applied res --}%
    	<g:each in="${apply_list}">
    		<g:each var="num" in="${0..<(it.requestDetail.quantityNeed - it.requestDetail.quantityAllocate)}">
    			<li class="span3"  data-filter-keyword="Resource Category: ${it.requestDetail.resourceType.resourceTypeName}|Resource Model: ${it.requestDetail.resourceType.model}|Resource Status: Unallocated">
    				<a class="tile image">
    					<div class="tile-content">
    						<img class="virtual_res"
    							src="<g:createLink controller='picture' action='get'/>?fileName=${it.requestDetail.resourceType.pictureNames[0]}">
    					</div>
    					<div class="brand"  style="height:20px">
                    <p class="text">
                       <div class="progress" style="box-shadow: 0px 0px 1pt 2pt white;margin-left:9px ;width:85%; height:10px; margin-bottom: auto"
                          data-toggle="tooltip" data-placement="bottom" title data-original-title="  ${it.currentStep} / ${it.maxStep}  ">
                          <div class="bar" style="width: ${(it.currentStep/it.maxStep)*100}%;"></div>
                        </div>
                    </p>
                    <p style="height:12px;margin-left:8px">${it.getPrintableId()} </p>
                    <p style="margin-left:8px;margin-bottom:0px"><label class='badge badge-warning'>${message(code:it.status.labelCode)}</label></p>
                    <p class="text" style="text-overflow:ellipsis;overflow:hidden;white-space: nowrap;">${it.requestDetail.resourceType.toString()}</p>
                    <p class="text"><g:formatDate date='${it.dateCreated}' format='yyyy-MM-dd'/></p>
              </div>
    				</a>
    			</li>
    		</g:each>
    	</g:each>
    	
    </ul>
   	<ul class="nav nav-pills nav-stacked span1" id="resource-side-bar">
    </ul>
</div>
<script>
	$(document).ready(function() {
		$(".virtual_res").fadeTo("fast", 0.4);

    /* WTF: Specific the IE8 render */
    var isIE8 = navigator.userAgent.indexOf("MSIE 8.0")>0
    if(isIE8)  
    {  
      //mark the tile class to fixed size
      $('.tile').css('width','140px');
    }

		function refresh() {
      /* layout adjust */
      $(".tile-group li").css("margin-left","0px")

      /*motion animation*/
      $('.tile-group li .tile').css('display','none')
      $('.tile-group li .tile').css('position','absolute')
      $('.tile-group li .tile').animate({
          left: '+=1000',
          opacity: 0
        }, 0, function() {})
      $('.tile-group li .tile').css('display','block')
      $('.tile-group').css('display','block')

      var seq = 0
      $('.tile-group li .tile').each(function(index){
          $(this).animate({
            left: '-=1000',
            opacity: 1
          }, seq, function(){})
          seq+=200
          if(seq>=3200)
            seq=1000
      })
    
      $('.tile-group li .tile').css('display','')
      $('.tile-group li .tile').css('left','')
      $('.tile-group li .tile').css('position','')
      
		}
		refresh()

    /* the tile toggle effect */
    $('.tile-group li a').hover(function()
        {
            var target = $(this)
            $(this).data('timeout', window.setTimeout(function()
            {
                jQuery('.brand',target).animate({height:'130px'},500)
            }, 300));
        },
        function()
        {
            var target = $(this)
            clearTimeout($(this).data('timeout'));
            jQuery('.brand',target).animate({height:'20px'},500)
        });

    function uniqueArray(a) {    
        var r=[];    
        for (var i=0,l=a.length; i<l; ++i)jQuery.inArray(a[i],r)<0&&r.push(a[i]);    
        return r;    
    }    

    var auto_hint = uniqueArray($(".tile-group li[data-filter-keyword]").map(
        function(){
          return $(this).attr("data-filter-keyword").split("|")
        })).sort()

    $(".allocated_res").click(function(){
        $.ajax({
          url:'resourceDetail',
          data: "res_id=" + $(this).attr("data-filter-id"), 
          cache: false,
          success: function(html) {
                $('#modal_res_detail').html(html);
                $('#viewResource').modal('show')
              }
          });
    })

    $("#filter").select2({
      tags:auto_hint,
      placeholder: "${message(code: 'hint.search.filter')}",
      width: '95%'
      })
     $("#filter").on("change", function(e){
            $('.tile-group li').css('display','none')
            
            /* if there is not filter, mark all visible */
            if(e.val.length == 0){
              $('.tile-group li').css('display','block')
              return
            }

            $(".tile-group li[data-filter-keyword]").map(
                function(){
                  var filter_list = $(this).attr("data-filter-keyword").split("|")
                  
                  for(ruleIndex in e.val){
                    var match_flag = false
                    for(itemIndex in filter_list){
                      //filter_list[itemIndex]==e.val[ruleIndex]  excact match
                      if(filter_list[itemIndex].toLowerCase().indexOf(e.val[ruleIndex].toLowerCase())>=0){
                        match_flag = true
                      }
                    }
                    if(match_flag==false)
                      break
                    if(ruleIndex == e.val.length -1 )
                      $(this).css("display","block")
                  }
                }
            )
            /*$("#filter").select2({
              tags:$(".tile-group li[data-filter-keyword]").map(
                function(){
                  if($(this).css("display")=="none")
                    return
                  return $(this).attr("data-filter-keyword").split("=")
                }),
              dropdownCssClass: "bigdrop"
            })*/
            refresh()
      })
	})
</script>

<g:render template="formApplyResources" />
<div id="modal_res_detail"></div>