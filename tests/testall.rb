require 'test_helper'

# because constants are dynamically defined, some tests need to
# be opened in a fresh instance of Ruby, hence the popens

IO.popen("date") { |f| puts f.gets }
