modules = {
    application {
        resource url:'js/application.js'
    }
	
	bootstrap {
		resource url:'less/custom-bootstrap.less',attrs:[rel: "stylesheet/less", type:'css']
		dependsOn 'jquery'
		dependsOn 'bootstrapJs'
	}
 
	bootstrapJs {
		resource url:'js/bootstrap/bootstrap-affix.js'
		resource url:'js/bootstrap/bootstrap-alert.js'
		resource url:'js/bootstrap/bootstrap-button.js'
		resource url:'js/bootstrap/bootstrap-carousel.js'
		resource url:'js/bootstrap/bootstrap-collapse.js'
		resource url:'js/bootstrap/bootstrap-dropdown.js'
		resource url:'js/bootstrap/bootstrap-modal.js'
		resource url:'js/bootstrap/bootstrap-scrollspy.js'
		resource url:'js/bootstrap/bootstrap-tab.js'
		resource url:'js/bootstrap/bootstrap-tooltip.js'
		resource url:'js/bootstrap/bootstrap-popover.js'
		resource url:'js/bootstrap/bootstrap-transition.js'
		resource url:'js/bootstrap/bootstrap-typeahead.js'
	}
	
	
	datetimepicker {
		resource url:'js/bootstrap-datetimepicker/bootstrap-datetimepicker.min.js'
	}
	
	iFrame {
		resource url:'js/jquery.iframe-post-form.js'
	}
	
	placeholder {
		resource url:'js/jquery.placeholder.min.js'
	}
	
	validate {
		resource url:'js/jquery.validate.min.js'
	}
	
	validateEngine {
		resource url:'js/jquery.validationEngine.js'
	}
	
	validateEngineEn {
		resource url:'js/jquery.validationEngine-en.js'
	}

	select2{
		resource url:'js/select2.js'
	}

	scrollto{
		resource url:'js/scrollto.js'
	}
}