require File.dirname(__FILE__) + '/lib/hn2json/version'

def command?(command)
  system("type #{command} > /dev/null 2>&1")
end

#
# Gems
#

desc "Build gem."
task :gem do
  sh "gem build hn2json.gemspec"
end

task :push => [:gem] do
  file = Dir["*-#{HN2JSON::VERSION}.gem"].first
  sh "gem push #{file}"
end

desc "Install gem."
task :install => [:gem] do
  sh "gem install hn2json-#{HN2JSON::VERSION}.gem"
end

desc "Build the gem, install it and open irb."
task :irb => [:install] do
  sh "irb -r hn2json"
end

desc "tag version"
task :tag do
  sh "git tag v#{HN2JSON::VERSION}"
  sh "git push origin master --tags"
  sh "git clean -fd"
end

desc "tag version and push gem to server"
task :release => [:push, :tag] do 
  puts "And away it goes!"
end