package srm.web

class LoginCheckFilters {

    def filters = {
        all(controller:'*', action:'*') {
            before = {
    			if (!session.user && (controllerName.equals('admin')||controllerName.equals('common'))) {
                    redirect(uri:"/")
                    return false
				}
                log.debug controllerName + "before"
            }
            after = { Map model ->
                /* disable the client caching */
                response.setHeader("Cache-Control","no-cache, no-store, must-revalidate")
                response.setHeader("Pragma", "no-cache")
                response.setDateHeader("Expires", 0)
                log.debug controllerName + "after"
            }
            afterView = { Exception e ->
                log.debug controllerName + "afterView"
            }
        }
    }
}
