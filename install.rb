# Install hook code here
# Install the will_paginate plugin unless it is already present
  unless File.exist?(File.dirname(__FILE__) + "/../will_paginate")
      Commands::Plugin.parse!(['install','git://github.com/mislav/will_paginate.git'])
  end


