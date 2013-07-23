<link rel="stylesheet" href="${resource(dir: 'css/select2', file: 'select2.css')}" type="text/css">
<script type="text/javascript" src="${resource(dir: 'js', file: 'select2.js')}
"></script>

<div class="row-fluid">
    <div class="span12" style="margin-bottom:20px">
        <input type="text" class="input-xxlarge span12" id="filter">
    </div>

    <ul class="tile-group span10" style="display:none;overflow: hidden;padding-top: 5px;padding-left: 2px;">

      <li class="span3" data-toggle="tooltip" data-placement="bottom" title="" data-original-title="Apply new resources">
          <a class="tile icon res_apply_btn"
            href="#applyResources" data-toggle="modal"> 
            <div class="tile-content">
              <img
                src="${resource(dir: 'images', file: 'tile_add.png')}" >
            </div>
          </a>
      </li>

    	<g:each in="${res_list}">
        <%
          boolean is_transferred=false
          transfer_list.each{ transfer_req ->
            if(transfer_req.requestDetail.resource.equals(it)){
              is_transferred=true
            }
          }
        %>
    		<li class="span3 allocated_res" data-filter-keyword="ResourceType: ${it.purchase.resourceType.resourceTypeName}|ResourceModel: ${it.purchase.resourceType.model}|Serial: ${it.serial}<%
            if(is_transferred){
        %>|ResourceStatus:Transferring<%  }else{
        %>|ResourceStatus: ${message(code:it.status.labelCode)}<%
            }
        %>">
          <a href="#" class="tile image <% if(is_transferred)out << 'transfer_res' %>"  data-placement="bottom" data-html="true" trigger="focus" data-content="
                <div class='container span12'>
                  <p class='row-fluid'>${it.purchase.resourceType.toString()}</p>
                  <p class='row-fluid'>${message(code:'resource.status.label')} : <label class='badge badge-success'>${message(code:it.status.labelCode)}</label></p>
                  <p class='row-fluid'>${message(code:'resource.serial.label')} : ${it.serial}</p>
                  <p class='row-fluid'>${message(code:'resource.purpose.label')} : ${it.purpose}</p>
                  <p class='row-fluid'><g:formatDate date='${it.dateCreated}' format='yyyy-MM-dd'/></p>
                  <%
                    if(is_transferred){
                  %>
                    <div class='row-fluid'><p><a class='btn btn-primary offset7 disabled'>Transferring</a></p></div>
                  <%
                    }else{
                  %>
                  <div class='row-fluid'><p><a class='btn btn-primary offset7' data-toggle='modal' data-target='#transferResources' onClick=renderTransferDialog('${it.id}',this) ><i class='icon-share icon-white'></i>${message(code:'modal.button.transfer.label')}</a></p></div>
                  <%
                    }
                  %>
                </div>
                " 
                data-original-title="${it.getPrintableId()}">
                
            <div class="tile-content">
                <img src="<g:createLink controller='picture' action='get'/>?fileName=${it.purchase.resourceType.pictureNames[0]}">
            </div>
            <div class="brand bg-color-blueDark" style="height:20px">
                <p class="text">${it.serial} <label class='badge badge-info pull-right ' style="margin-right:15px">${message(code:it.status.labelCode)}</label></p>
                <p class="text">${it.purchase.resourceType.resourceTypeName} ${it.purchase.resourceType.model}</p>
                <p class="text">${it.purpose}</p>
                <!--<i class="icon-eye-open icon-white pull-right"></i> -->
            </div>
          </a>
    		</li>
    	</g:each>

    	<g:each in="${apply_list}">
    		<g:each var="num" in="${0..<(it.requestDetail.quantityNeed - it.requestDetail.quantityAllocate)}">
    			<li class="span3"  data-filter-keyword="ResourceType: ${it.requestDetail.resourceType.resourceTypeName}|ResourceModel: ${it.requestDetail.resourceType.model}|ResourceStatus: Unallocated">
    				<a class="tile image">
    					<div class="tile-content">
    						<img class="virtual_res"
    							src="<g:createLink controller='picture' action='get'/>?fileName=${it.requestDetail.resourceType.pictureNames[0]}">
    					</div>
    					<div class="brand"  style="height:20px">
                    <p class="text">
                       <div class="progress" style="margin-left:9px ;width:85%; height:10px; margin-bottom: auto"
                          data-toggle="tooltip" data-placement="bottom" title data-original-title="  ${it.currentStep} / ${it.maxStep}  ">
                          <div class="bar" style="width: ${(it.currentStep/it.maxStep)*100}%;"></div>
                        </div>
                    </p>
                    <p style="height:12px;margin-left:8px">${it.getPrintableId()}  </p>
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
  function renderTransferDialog(var1,var2)
  {
      $("#transferResourceId").val(var1)
      var content = '';
      for(var i = 0 ; i < jQuery('p:lt(5)' ,$(var2).parent().parent().parent()).size() ; i++)
      {
        content += jQuery('p:lt(6)' ,$(var2).parent().parent().parent())[i].outerHTML
      }
      $("#rep_transfer_res").html(content)
  }

	$(document).ready(function() {
		$(".virtual_res").fadeTo("fast", 0.4);

		function refresh() {
      /* layout adjust */
      /*var column = 4
			var wapper = '<div class="row-fluid" style="margin-top: 15px;">'
			var row = $(".tile-group").children().size()/column + 1
			for(var i =1 ; i<=row;i++)
			{
				$(".tile-group > li:lt("+column+")").wrapAll(wapper)
			}*/
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
      $('.tile-group li .tile').attr('style','')
		}
		refresh()

    $('.tile-group li a').mouseenter(function(){
                          jQuery('.brand',$(this)).animate({height:'130px'},500)})
                       .mouseleave(function(){
                          jQuery('.brand',$(this)).animate({height:'20px'},500)})

    $('.allocated_res a').popover()

    function uniqueArray(a) {    
        var r=[];    
        for (var i=0,l=a.length; i<l; ++i)jQuery.inArray(a[i],r)<0&&r.push(a[i]);    
        return r;    
    }    

    var auto_hint = uniqueArray($(".tile-group li[data-filter-keyword]").map(
        function(){
          return $(this).attr("data-filter-keyword").split("|")
        }))

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
                      if(filter_list[itemIndex]==e.val[ruleIndex]){
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
<g:render template="formTransferResources" /></div>
<a style="display:none" id="dummy" href="#transferResources" data-toggle="modal">dummy</a>
<style>
.transfer_res{
  outline: 2px #3a3a3a dashed;
}
.res_apply_btn{
  width: 94%
}
.res_apply_btn img{
  width: inherit;
}
.popover{
  max-width: 350px;
}
.tab-content {
  overflow: hidden;
}
.tile-group {
  margin: 0;
  /*margin-right: 80px;*/
  /*float: left;*/
  /*width: auto;
  height: auto;*/
  /*min-height: 1px;*/
  /*width: 802px;*/
}
.tile {
  display: block;
  float: left;
  background-color: #525252;
  /*width: 150px;*/
  height: 130px;
  cursor: pointer;
  box-shadow: inset 0px 0px 1px #FFFFCC;
  text-decoration: none;
  color: #ffffff;
  overflow: hidden;
  position: relative;
  /*font-family: 'Segoe UI Semilight', 'Open Sans', Verdana, Arial, Helvetica, sans-serif;*/
  /*font-weight: 300;*/
  /*font-size: 11pt;*/
  /*letter-spacing: 0.02em;*/
  line-height: 20px;
  /*font-smooth: always;*/
  margin: 0 10px 10px 0;
  border-radius:4px;
}
.selected {
  border: 4px #2d89ef solid;
}
.selected:after {
  width: 0;
  height: 0;
  border-top: 40px solid #2d89ef;
  border-left: 40px solid transparent;
  position: absolute;
  display: block;
  right: 0;
  content: ".";
  top: 0;
  z-index: 1001;
}
.selected:before {
  position: absolute;
  content: "\e08a";
  color: #fff;
  right: 4px;
  font-family: iconFont;
  z-index: 1002;
}
.tile * {
  color: #ffffff;
}
.tile .tile-content {
  width: 100%;
  height: 100%;
  padding: 0;
  padding-bottom: 30px;
  vertical-align: top;
  padding: 10px 15px;
  overflow: hidden;
  text-overflow: ellipsis;
  position: relative;
  /*font-family: 'Segoe UI', 'Open Sans', Verdana, Arial, Helvetica, sans-serif;*/
  font-weight: 400;
  font-size: 9pt;
  /*font-smooth: always;*/
  color: #000000;
  color: #ffffff;
  line-height: 16px;
}
.tile .tile-content:hover {
  color: rgba(0, 0, 0, 0.8);
}
.tile .tile-content:active {
  color: rgba(0, 0, 0, 0.4);
}
.tile .tile-content:hover {
  color: #ffffff;
}
.tile .tile-content h1,
.tile .tile-content h2,
.tile .tile-content h3,
.tile .tile-content h4,
.tile .tile-content h5,
.tile .tile-content h6,
.tile .tile-content p {
  padding: 0;
  margin: 0;
  line-height: 24px;
}
.tile .tile-content h1:hover,
.tile .tile-content h2:hover,
.tile .tile-content h3:hover,
.tile .tile-content h4:hover,
.tile .tile-content h5:hover,
.tile .tile-content h6:hover,
.tile .tile-content p:hover {
  color: #ffffff;
}
.tile .tile-content p {
  font-family: 'Segoe UI', 'Open Sans', Verdana, Arial, Helvetica, sans-serif;
  font-weight: 400;
  font-size: 9pt;
  font-smooth: always;
  color: #000000;
  color: #ffffff;
  line-height: 16px;
  overflow: hidden;
  text-overflow: ellipsis;
}
.tile .tile-content p:hover {
  color: rgba(0, 0, 0, 0.8);
}
.tile .tile-content p:active {
  color: rgba(0, 0, 0, 0.4);
}
.tile .tile-content p:hover {
  color: #ffffff;
}
.tile.icon  > .tile-content {
  padding: 0;
}
.tile.icon  > .tile-content  > img {
  position: absolute;
  width: 100%;
  height: 100%;
  /*width: 64px;
  height: 64px;
  top: 50%;
  left: 50%;
  margin-left: -32px;
  margin-top: -32px;*/
}
.tile.icon  > .tile-content  > i {
  font-size: 128px;
  margin: 9px;
}
.tile.image  > .tile-content,
.tile.image-slider  > .tile-content {
  padding: 0;
}
.tile.image  > .tile-content  > img,
.tile.image-slider  > .tile-content  > img {
  width: 100%;
  height: auto;
  min-height: 100%;
  max-width: 100%;
}
.tile.image-set  > .tile-content {
  margin: 0;
  padding: 0;
  width: 25% !important;
  height: 50%;
  float: left;
  border: 1px #1e1e1e solid;
}
.tile.image-set  > .tile-content  > img {
  min-width: 100%;
  width: 100%;
  height: auto;
  min-height: 100%;
}
.tile.image-set .tile-content:first-child {
  width: 50% !important;
  float: left;
  height: 100%;
}
.tile.double {
  width: 310px;
}
.tile.triple {
  width: 470px;
}
.tile.quadro {
  width: 630px;
}
.tile.double-vertical {
  height: 310px;
}
.tile.triple-vertical {
  height: 470px;
}
.tile.quadro-vertical {
  height: 630px;
}
.tile .brand,
.tile .tile-status {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  min-height: 30px;
  background-color: transparent;
  *zoom: 1;
}
.tile .brand:before,
.tile .tile-status:before,
.tile .brand:after,
.tile .tile-status:after {
  display: table;
  content: "";
}
.tile .brand:after,
.tile .tile-status:after {
  clear: both;
}
.tile .brand  > .badge,
.tile .tile-status  > .badge {
  position: absolute;
  bottom: 0;
  right: 0;
  right: 5px;
  margin-bottom: 0;
  color: #ffffff;
  width: 34px;
  height: 28px;
  text-align: center;
  /*font-family: 'Segoe UI Semibold', 'Open Sans', Verdana, Arial, Helvetica, sans-serif;*/
  font-weight: 600;
  font-size: 11pt;
  letter-spacing: 0.01em;
  line-height: 14pt;
  /*font-smooth: always;*/
  padding-top: 3px;
}
.tile .brand  > .name,
.tile .tile-status  > .name {
  position: absolute;
  bottom: 0;
  left: 0;
  margin-bottom: 5px;
  margin-left: 15px;
  font-family: 'Segoe UI', 'Open Sans', Verdana, Arial, Helvetica, sans-serif;
  font-weight: 400;
  font-size: 9pt;
  /*font-smooth: always;*/
  color: #ffffff;
}
.tile .brand  > .name:hover,
.tile .tile-status  > .name:hover {
  color: #ffffff;
}
.tile .brand  > .name  > [class*=icon-],
.tile .tile-status  > .name  > [class*=icon-] {
  font-size: 24px;
}
.tile .brand  > .icon,
.tile .tile-status  > .icon {
  margin: 5px 15px;
  width: 32px;
  height: 32px;
}
.tile .brand  > .icon  > [class*=icon-],
.tile .tile-status  > .icon  > [class*=icon-] {
  font-size: 32px;
}
.tile .brand  > .icon  > img,
.tile .tile-status  > .icon  > img {
  width: 100%;
  height: 100%;
}
.tile .brand  > img ~ .text,
.tile .tile-status  > img ~ .text {
  position: absolute;
  left: 60px;
  width: auto;
}
.tile .brand  > .text,
.tile .tile-status  > .text {
  position: relative;
  left: 8px;
  top: 5px;
  right: 50px;
  font-family: 'Segoe UI', 'Open Sans', Verdana, Arial, Helvetica, sans-serif;
  font-weight: 400;
  font-size: 9pt;
  font-smooth: always;
  color: #000000;
  color: #ffffff;
  line-height: 14px;
  /*width: 60%;*/
}
.tile .brand  > .text:hover,
.tile .tile-status  > .text:hover {
  color: rgba(0, 0, 0, 0.8);
}
.tile .brand  > .text:active,
.tile .tile-status  > .text:active {
  color: rgba(0, 0, 0, 0.4);
}
.tile .brand  > .text:hover,
.tile .tile-status  > .text:hover {
  color: #ffffff;
}
.tile:hover {
  outline: 2px #3a3a3a solid;
  -moz-outline-radius: 4px;
  -webkit-border-radius: 4px;
}

/**/
.bg-color-blueLight {
  background-color: #eff4ff !important;
}
.bg-color-blueDark {
  background-color: #2b5797 !important;
}
</style>
<!-- <script type="text/javascript" src="http://www.bootcss.com/p/metro-ui-css/js/modern/tile-slider.js"></script>
<script type="text/javascript" src="http://www.bootcss.com/p/metro-ui-css/js/modern/tile-drag.js"></script> -->