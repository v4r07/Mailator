module Mailator

    class Converter

        def self.htmlEntities(string)
            final_res = []
            string.bytes.each do |byte|
                final_res << "&##{byte};"
            end
            return final_res.join
        end
    end

    class Smtp

        def config(host, user, pass, port, email)
           json_content = <<EOF
{
   "smtp_host": "#{host}",
   "smtp_user": "#{user}",
   "smtp_pass": "#{pass}",
   "smtp_port": #{port},
   "smtp_email": "#{email}"
}
EOF

           unless(File.file?("config/config.json"))
                File.open("config/config.json", "a+") do |f|
                    f.puts json_content
                    f.close
                end
                Error.config_success(host, user, pass, port)
           else
                print("Rewrite [Y/n]: ")
                rew = STDIN.gets.chomp

                if rew == "Y" || rew == "y"
                    File.open("config/config.json", "w+") do |file|
                        file.puts json_content
                        file.close
                    end
                else
                    exit
                end
           end
        end

        def self.getSmtpInfo
            file = File.open("config/config.json").read
            js = JSON.parse(file)
            return js
        end

        def getSmtpInfo
            file = File.open("config/config.json").read
            js = JSON.parse(file)
            return js
        end
      
    end

    class Error
        def self.danger(string)
            puts "[*] ERROR !".colorize(:red)
            puts "[*] Erreur: #{string}".colorize(:red)
            puts "[*] Raison: Aucun Paramètre(s) Spécifier.".colorize(:red)
            puts "[*] Correction: #{string} + paramètre(s).".colorize(:red)
            exit
        end
        #config_succes("Hello", "Wolrd", "ja", "fefe")
        def self.config_success(*string)
            puts "[SUCCESS] La Configuration Est Réussie !!!".colorize(:green)
        end

        def self.oops(string)
            puts "[*] ERROR !".red
            puts "[*] Erreur: #{string}".red
            puts "[*] Raison: Aucun Fichier Trouver :/ . ".red
            puts "[*] Correction: Veuillez inserer un bon path.".red
            exit
        end

        def self.smtp_error(string)
            puts "[*] ERROR !".red
            puts "[*] Erreur: #{string}".red
            puts "[*] Raison: Il semblerait que votre SMTP à un problème !".red
            puts "[*] Correction: Vérifiez votre SMTP, vérifiez qu'il soit toujours fonctionnel.".red
            exit
        end



    end

    #mailator.rb --sender --mailist=/path/mailist.txt --html=/path/file.html --subject="Je suis le plus beau" --start

    class Sender

        @@mailist = nil
        @@scama = nil
        @@subject = nil
        @@senderfrom = nil

        def initialize(mailist, scama, subject, senderfrom)
            @@mailist = mailist
            @@scama = scama
            @@subject = subject
            @@senderfrom = senderfrom
        end

        def readFile(file)
            return File.readlines(file)
        end
    
        def send
            if !check_path_mailist?(@@mailist)
                Error.oops(@@mailist)
            end

            if !check_path_mailist?(@@scama)
                Error.oops(@@scama)
            end
            

            smtp_info = Smtp.getSmtpInfo()
            
            content_file = self.readFile(@@mailist)
            content_file.each do |email|

message = <<MESSAGE_END
From: Service <#{smtp_info["smtp_email"]}>
To: A Test User <#{email.chomp}>
MIME-Version: 1.0
Content-type: text/html
Subject: #{@@subject}

#{File.read(@@scama)}
MESSAGE_END
                pastel = Pastel.new
                spinner = TTY::Spinner.new(pastel.yellow"[:spinner] Envois du mail => #{email.chomp}")
                
                ctx = OpenSSL::SSL::SSLContext.new()
                smtp = Net::SMTP.new("#{smtp_info["smtp_host"]}", smtp_info["smtp_port"])
                smtp.enable_tls
                smtp.start("#{smtp_info["smtp_host"]}", "#{smtp_info["smtp_user"]}", "#{smtp_info["smtp_pass"]}") do |smtp|
                    thr = Thread.new { smtp.send_message message, "#{smtp_info["smtp_email"]}", "#{email.chomp}" }
                    20.times do
                        spinner.spin
                        sleep(0.1)
                    end
                    thr.join
                    spinner.success(pastel.green '(Send)')
                    smtp.finish
                end
                
    
            end
        end

        def check_path_mailist?(file)
            if File.exist?(file) == true
                return true
            else
                return false
            end
        end
    end
end
