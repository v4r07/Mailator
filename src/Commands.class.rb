class Commands
        def help_me
            puts "      -- HELP --      "
            puts "--config --host={HOST} --user={USER} --pass={PASS} --port={PORT} --email={EMAIL} --> Ceci et pour configurer votre sender."
	        puts "--sender --mailist={PATH_MAILIST} --html={PATH_LETTER} --subject={SUBJECT}(ne pas oublier les doubles quotes) --senderfrom={SENDERFROM} --ssl={SSL_ENABLE} --start Ceci pour envoyer des mails"
            puts "--convert --htmlentities={STRING}"
            puts "--info   --> Drop les informations inscrit par l'utilisateur."
            puts "--help   --> Drop toute les commandes avec leurs utilisations."
            exit
        end
    end
