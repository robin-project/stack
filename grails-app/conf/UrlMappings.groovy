class UrlMappings {

	static mappings = {		
		"/confirm/$id?" {
			controller = 'reactivate'
			action = "active"
		}
		
		"/$controller/$action?/$id?"{
			constraints {
				// apply constraints here
			}
		}

		"/"(view:'index')
		"500"(view:'/error')		
	}
}
