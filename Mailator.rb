require 'colorize'
require 'json'
require 'net/http'
require 'net/smtp'
require 'tty-spinner'
require 'pastel'
require 'openssl'
require_relative 'src/Design.class'
require_relative 'src/Mailator.class'
require_relative 'src/Commands.class'

design = Design.new
design.ascii_interface

command = Commands.new
if ARGV.length >= 1
    if ARGV[0] == "--config" && ARGV[1].include?("--host=") && ARGV[2].include?("--user=") && ARGV[3].include?("--pass=") && ARGV[4].include?("--port=") && ARGV[5].include?("--email=")
        smtp_instance = Mailator::Smtp.new
        if ARGV[1] == "--host="
            puts Error.danger(ARGV[1])
        elsif ARGV[2] == "--user="
            puts Error.danger(ARGV[2])
        elsif ARGV[3] == "--pass="
            puts Error.danger(ARGV[3])
        elsif ARGV[4] == "--port="
            puts Error.danger(ARGV[4])
        elsif ARGV[5] == "--email="
            puts Error.danger(ARGV[5])
        end
        host = ARGV[1].split("=")[1]
        user = ARGV[2].split("=")[1]
        pass = ARGV[3].split("=")[1]
        port = ARGV[4].split("=")[1].to_i
        email = ARGV[5].split("=")[1]
        smtp_instance.config(host, user, pass, port, email) #def config(host, user, pass, port)
    elsif ARGV[0] == "--convert" && ARGV[1].include?("--htmlentities=")
        if ARGV[1] == "--htmlentities="
            puts Mailator::Error.danger(ARGV[1])
        end
        string = ARGV[1].split("=")
        puts "-- CONVERTER --"
        puts("[+] Résulat --> %s".green % [Mailator::Converter.htmlEntities(string[1])])
    elsif ARGV[0] == "--infos"
        smtp_instance = Mailator::Smtp.new
        puts "    -- INFORMATIONS --      ".yellow
        puts "[HOST]: {#{smtp_instance.getSmtpInfo()["smtp_host"]}}".magenta
        puts "[USER]: {#{smtp_instance.getSmtpInfo()["smtp_user"]}}".magenta
        puts "[PASS]: {#{smtp_instance.getSmtpInfo()["smtp_pass"]}}".magenta
        puts "[PORT]: {#{smtp_instance.getSmtpInfo()["smtp_port"]}}".magenta
        puts "[EMAIL]: {#{smtp_instance.getSmtpInfo()["smtp_email"]}}".magenta
    elsif ARGV[0] == "--sender" && ARGV[1].include?("--mailist=") && ARGV[2].include?("--html=") && ARGV[3].include?("--subject=") && ARGV[4].include?("--senderfrom=") && ARGV[5] == "--start"
        if ARGV[1] == "--mailist="
            puts Mailator::Error.danger(ARGV[1])
        elsif ARGV[2] == "--html="
            puts Mailator::Error.danger(ARGV[2])
        elsif ARGV[3] == "--subject="
            puts Mailator::Error.danger(ARGV[3])
        elsif ARGV[4] == "--senderfrom="
            puts Mailator::Error.danger(ARGV[4])
        end
        mailist_path = ARGV[1].split("=")[1]
        html_path = ARGV[2].split("=")[1]
        subject = ARGV[3].split("=")[1]
        senderfrom = ARGV[4].split("=")[1]
        
        smtp_instance = Mailator::Sender.new(mailist_path, html_path, subject, senderfrom)
        begin
            smtp_instance.send
        rescue Net::SMTPAuthenticationError
            Mailator::Error.smtp_error("Error autentication smtp !")
        end
    end
else
    puts command.help_me()
end