<style>
.load-modal {
    display:    none;
    position:   fixed;
    z-index:    1000000;
    top:        0;
    left:       0;
    height:     100%;
    width:      100%;
    background: rgba( 255, 255, 255, .8 ) 
                url("${resource(dir:'images',file:'ajax-loader.gif')}") 
                50% 50% 
                no-repeat;
}

</style>
<div id="loading" class="load-modal">

</div>