# This is the developer's config file. Modify for your system.

# when testing, the CVS release tag is not used, allowing tuning of package
$test = true   # set to false when final build is to be done
# cvs root (-d flag) to use -- don't forget to log in first!
$cvsroot = "-d:ext:fando@rubyforge.org:/var/cvs/log4r"
# prepdir is where the build process puts working files
$prepdir = '/home/cepheus/projects/prep'
# releasedir is where the final tarballs are put
$releasedir = '/home/cepheus/projects/releases'
# quiet = true sends most output to /dev/null
$quiet = false

# These are for removing unneeded developer files from the cvs co 

# delete these directories from toplevel (except bin!)
$deletedirs = %w{ 
  doc/content doc/templates doc/dev
}
# delete these files (needs path from toplevel)
$deletefiles = %w{ 
}
