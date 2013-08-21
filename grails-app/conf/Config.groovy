import com.hp.it.cdc.robin.srm.service.CaptchaImageService
// locations to search for config files that get merged into the main config;
// config files can be ConfigSlurper scripts, Java properties files, or classes
// in the classpath in ConfigSlurper format

// grails.config.locations = [ "classpath:${appName}-config.properties",
//                             "classpath:${appName}-config.groovy",
//                             "file:${userHome}/.grails/${appName}-config.properties",
//                             "file:${userHome}/.grails/${appName}-config.groovy"]

// if (System.properties["${appName}.config.location"]) {
//    grails.config.locations << "file:" + System.properties["${appName}.config.location"]
// }
grails.gorm.failOnError=true
grails.project.groupId = appName // change this to alter the default package name and Maven publishing destination
grails.mime.file.extensions = true // enables the parsing of file extensions from URLs into the request format
grails.mime.use.accept.header = false
grails.mime.types = [
    all:           '*/*',
    atom:          'application/atom+xml',
    css:           'text/css',
    csv:           'text/csv',
    form:          'application/x-www-form-urlencoded',
    html:          ['text/html','application/xhtml+xml'],
    js:            'text/javascript',
    json:          ['application/json', 'text/json'],
    multipartForm: 'multipart/form-data',
    rss:           'application/rss+xml',
    text:          'text/plain',
    xml:           ['text/xml', 'application/xml']
]

// URL Mapping Cache Max Size, defaults to 5000
//grails.urlmapping.cache.maxsize = 1000

// What URL patterns should be processed by the resources plugin
grails.resources.adhoc.patterns = ['/images/*', '/css/*', '/js/*', '/plugins/*']

// The default codec used to encode data with ${}
grails.views.default.codec = "none" // none, html, base64
grails.views.gsp.encoding = "UTF-8"
grails.converters.encoding = "UTF-8"
// enable Sitemesh preprocessing of GSP pages
grails.views.gsp.sitemesh.preprocess = true
// scaffolding templates configuration
grails.scaffolding.templates.domainSuffix = 'Instance'

// Set to false to use the new Grails 1.2 JSONBuilder in the render method
grails.json.legacy.builder = false
// packages to include in Spring bean scanning
grails.spring.bean.packages = []
// whether to disable processing of multi part requests
grails.web.disable.multipart=false

// request parameters to mask when logging exceptions
grails.exceptionresolver.params.exclude = ['password']

// configure auto-caching of queries by default (if false you can cache individual queries with 'cache: true')
grails.hibernate.cache.queries = false

//LESS CSS
grails.resources.mappers.lesscss.compress = true

plugin.platformCore.site.name="Stack application"
plugin.platformCore.organization.name="HP-IT DS/CDC Operation Team"

//AVATAR
avatarPlugin {
	defaultGravatarUrl="""https://raw.github.com/robin-hp/stack/master/web-app/images/defaultAvatar.jpg"""
	gravatarRating="G"
}

environments {

	development {
		grails.logging.jul.usebridge = true
		grails.serverURL = "http://localhost:8080/stack"
		grails.serverSecureURL = "https://localhost:8443/stack"
		cacertpath="/hpca.crt"
		
		mongo {
			host = "localhost"
			port = 27017
			username = "srm_dev"
			password = "srm_pwd"
			databaseName = "srm_dev"
			bucket= "picture"
		}

	}
	test {
		grails.logging.jul.usebridge = true
		grails.serverURL = "http://localhost:8080/stack"
		grails.serverSecureURL = "https://localhost:8443/stack"
		cacertpath="/hpca.crt"

		mongo {
			host = "localhost"
			port = 27017
			username = "srm_test"
			password = "srm_pwd"
			databaseName = "srm_test"
			bucket= "picture"
		}
	}
	production {
		grails.logging.jul.usebridge = false
		grails.serverURL = "http://cdc-operation-aries.asiapacific.hpqcorp.net/stack"
		grails.serverSecureURL = "https://cdc-operation-aries.asiapacific.hpqcorp.net:8443/stack"
		cacertpath="/opt/apache-tomcat-6.0.36/ssl/hpca.crt"
		mongo {
			host = "localhost"
			port = 27017
			username = "srm_dev"
			password = "srm_pwd"
			databaseName = "srm_dev"
			bucket= "picture"
		}
	}
}

// log4j configuration
log4j = {
    // Example of changing the log pattern for the default console appender:
    //
    //appenders {
    //    console name:'stdout', layout:pattern(conversionPattern: '%c{2} %m%n')
    //}

    appenders {
		rollingFile name:'stack', maxFileSize:5242880, file:'/opt/apache-tomcat-6.0.36/logs/stack.log'
	}

	debug  'com.hp.it.robin.srm'
    error  'org.codehaus.groovy.grails.web.servlet',        // controllers
           'org.codehaus.groovy.grails.web.pages',          // GSP
           'org.codehaus.groovy.grails.web.sitemesh',       // layouts
           'org.codehaus.groovy.grails.web.mapping.filter', // URL mapping
           'org.codehaus.groovy.grails.web.mapping',        // URL mapping
           'org.codehaus.groovy.grails.commons',            // core / classloading
           'org.codehaus.groovy.grails.plugins',            // plugins
           'org.codehaus.groovy.grails.orm.hibernate',      // hibernate integration
           'org.springframework',
           'org.hibernate',
           'net.sf.ehcache.hibernate'
		   
	root {
		info 'stack'
	}
}

//verification configuration
jcaptchas {
	CaptchaImageService capImg = new CaptchaImageService()
	imageCaptcha = capImg.getCaptchaImage()
}

grails {
	mail {
	 host = "smtp3.hp.com"
	 port = 25
//	 username = "tester@hp.com"
//	 password = ""
	 //for SSL set up
	 /*
	 props = ["mail.smtp.auth":"true",
		"mail.smtp.socketFactory.port":"25",
		"mail.smtp.socketFactory.class":"javax.net.ssl.SSLSocketFactory",
		"mail.smtp.socketFactory.fallback":"false"]
		
	 */
	}
}
