grails.servlet.version = "2.5" // Change depending on target container compliance (2.5 or 3.0)
grails.project.class.dir = "target/classes"
grails.project.test.class.dir = "target/test-classes"
grails.project.test.reports.dir = "target/test-reports"
grails.project.target.level = 1.6
grails.project.source.level = 1.6
grails.project.war.file = "target/${appName}.war"
grails.enable.native2ascii = false

//grails.project.war.file = "target/${appName}-${appVersion}.war"

// uncomment (and adjust settings) to fork the JVM to isolate classpaths
//grails.project.fork = [
//   run: [maxMemory:1024, minMemory:64, debug:false, maxPerm:256]
//]

grails.project.dependency.resolution = {
    // inherit Grails' default dependencies
    inherits("global") {
        // specify dependency exclusions here; for example, uncomment this to disable ehcache:
        // excludes 'ehcache'
    }
    log "error" // log level of Ivy resolver, either 'error', 'warn', 'info', 'debug' or 'verbose'
    checksums true // Whether to verify checksums on resolve
    legacyResolve false // whether to do a secondary resolve on plugin installation, not advised and here for backwards compatibility

    repositories {
        inherits true // Whether to inherit repository definitions from plugins

        grailsPlugins()
        grailsHome()
        grailsCentral()

        mavenLocal()
        mavenCentral()

        // uncomment these (or add new ones) to enable remote dependency resolution from public Maven repositories
        //mavenRepo "http://snapshots.repository.codehaus.org"
        //mavenRepo "http://repository.codehaus.org"
        //mavenRepo "http://download.java.net/maven/2/"
        //mavenRepo "http://repository.jboss.com/maven2/"
    }

    dependencies {
        // specify dependencies here under either 'build', 'compile', 'runtime', 'test' or 'provided' scopes e.g.

        // runtime 'mysql:mysql-connector-java:5.1.22'
        compile "com.hp.it.cdc.robin.1302:hp-data-ldap:0.0.1-SNAPSHOT"
		compile "org.apache.camel:camel-mail:2.9.4"
		compile "org.apache.camel:camel-velocity:2.9.4"
    }

    plugins {
        //runtime ":hibernate:$grailsVersion"
        runtime ":jquery:1.8.3"
		compile ":jquery-ui:1.8.24"
//		compile ":calendar:1.2.1"
        runtime ":resources:1.2.RC2"
        compile ":lesscss-resources:1.3.3"
		compile ":avatar:0.6.3"
		compile ":browser-detection:0.4.3"
        //compile ":mysql-connectorj:5.1.22.1"

        // Uncomment these (or add new ones) to enable additional resources capabilities
        //runtime ":zipped-resources:1.0"
        //runtime ":cached-resources:1.0"
        //runtime ":yui-minify-resources:0.1.5"

        build ":tomcat:$grailsVersion"

        //runtime ":database-migration:1.3.2"
        //compile ":cache:1.0.1"
        compile ":quartz:1.0-RC7"
        compile ":mongodb:1.2.0"
//		compile ":mongodb-compound-index-attributes:1.1"
        runtime ":email-confirmation:2.0.7"
        compile ":platform-core:1.0.RC5"
		compile ":spring-security-core:1.2.7.3"
		compile ":webxml:1.4.1" //required by spring security filter mapping
		compile ":jcaptcha:1.2.1"
		compile ":email-validator:0.1"
		compile ":excel-export:0.1.6"
		
		compile ":routing:1.2.3"
    }
}
