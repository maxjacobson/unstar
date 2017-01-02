require 'github_api'
require 'readline'

oauth_token = File.read("./personal_access_token").chomp
$github = Github.new(oauth_token: oauth_token)

starred = $github.activity.starring.starred

def unstar(star)
  username = star.owner.login or raise 'no username'
  repo = star.name or raise 'no repo name'
  $github.activity.starring.unstar user: username, repo: repo
end

starred.each_page do |star_page|
  star_page.each do |star|
    if File.read("./cache").each_line.to_a.map(&:chomp).include?(star.full_name)
      puts "Skipping #{star.full_name}"
      next
    end

    if (Readline.readline("Unstar #{star.full_name}? ").chomp.downcase) == "y"
      unstar star
    else
      File.open("./cache", "a") { |f| f.puts star.full_name }
    end
  end
end
