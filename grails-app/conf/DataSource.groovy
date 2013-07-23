// environment specific settings
environments {
    development {
        grails {
            mongo {
                host = "localhost"
                port = 27017
                username = "srm_dev"
                password = "srm_pwd"
                databaseName = "srm_dev"
            }
        }
    }

    test {
       grails {
            mongo {
                host = "localhost"
                port = 27017
                username = "srm_test"
                password = "srm_pwd"
                databaseName = "srm_test"
            }
        }
    }

    production {
       grails {
            mongo {
                host = "localhost"
                port = 27017
                username = "srm_dev"
                password = "srm_pwd"
                databaseName = "srm_dev"
            }
        }
    }
}

