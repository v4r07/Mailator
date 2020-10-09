require 'colorize'

class Design

    def ascii_interface
        File.open("banners/banner1.txt", "r") do |f|
            puts self.mixte_color(f.read)
        end
    end

    def random_color(string)
        colors = ["#{string}".red, "#{string}".yellow, "#{string}".green, "#{string}".cyan, "#{string}".blue, "#{string}".magenta, "#{string}".white]
		color = colors[rand(0..6)]
    end

    def mixte_color(string)
        str_splited = string.split("\n")
        final_res = Array.new

        str_splited.each do |word|
            final_res << random_color(word)
        end

        return final_res.join("\n")
    end


end