class Commands
        def help_me
            puts "      -- HELP --      "
            puts "--config --host={HOST} --user={USER} --pass={PASS} --port={PORT} --email={EMAIL} --> Ceci et pour configurer votre sender."
            puts "--info   --> Drop les informations inscrit par l'utilisateur."
            puts "--help   --> Drop toute les commandes avec leurs utilisations."
            exit
        end
    end