# Builds the html. Can be called independently
# For each page in ../doc/content, build the corresponding page
# using template from ../doc/templates

if ARGV.size == 0
  puts "Usage: makehtml.rb <version> [path-to-docs]"
  exit
end
Version = ARGV[0]

dir = (ARGV[1] or ".")
Targetdir = dir.chomp("/")

# paranoid validation
if not FileTest.directory? Targetdir
  puts "First argument must be path to doc directory"
  exit
end
if not FileTest.directory? File.join(Targetdir, "templates")
  puts "Can't find doc/templates!"
  exit
end
if not FileTest.directory? File.join(Targetdir, "content")
  puts "Can't find doc/content!"
  exit
end

Templates = Hash.new

def load(fname)
  str = ""
  IO.foreach(fname) {|line|
    str += line
  }
  Templates[fname] = str
end

def parse(fname)
  title, template, id, cont = nil, nil, nil, ""
  IO.foreach(fname) {|line|
    if title.nil? and line =~ /^Title:(.*)/
      title = "<title>" + ($1).chomp.strip + "</title>"
    elsif template.nil? and line =~ /^Template:\s*(\S+\.html)/
      template = $1 
    elsif id.nil? and line=~ /^Id:(.*)/
      id = $1
    else
      cont += line
    end
  }
  temp = Templates[template].clone
  temp.sub!("<!-- TITLE -->", title)
  temp.sub!("<!-- CVSID -->", id)
  # join the content with the template
  temp.sub!("<!-- CONTENT -->", cont)
  # replaces #{version} everywhere with Version
  temp.gsub!('#{version}', Version)
  out = File.new("../" + fname, "w+")
  out.print temp
  out.flush
  out.close
end

Dir.chdir(File.join(Targetdir, "templates"))
Dir.foreach(".") {|fname|
  load(fname) if fname =~ /html$/
}
Dir.chdir("../content")
Dir.foreach(".") {|fname|
  parse(fname) if fname =~ /html$/
}
