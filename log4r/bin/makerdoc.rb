if ARGV.size == 0
  puts "Usage: makerdoc.rb <version> [path-to-log4r.rb] [path-to-docs]"
  exit
end

Version = ARGV[0]
Src = (ARGV[1] or ".").chomp("/")
Docs = File.join((ARGV[2] or ".").chomp("/"), "rdoc")

file = File.join(Src, "log4r.rb")
if not FileTest.exist? file
  puts "Can't find log4r.rb in #{Src}!"
  exit
end

def run(cmd)
  unless system cmd
    raise RuntimeError, "unable to finish '#{cmd}'", caller
    exit
  end
end

title = "#{Version} Log4r API"
run "cd #{Src}; rdoc --op #{Docs} --template kilmer --main log4r.rb --title '#{title}'"

# sub the version into the log4r_rb.html file
html = IO.readlines(Docs+"/files/log4r_rb.html")
f = File.open(Docs+"/files/log4r_rb.html", "w")
f.write((html.join).gsub!('#{version}', Version))
f.close
