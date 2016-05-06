require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.formatter = 'documentation'
  config.order = 'random'
  config.color = true
  config.fail_fast = true
end

# silence!!
#
# all logging
Chef::Log.init('/dev/null')
#
# 'warning: already initialized constant'
$VERBOSE = nil
#
# deprecation warnings
module Kernel
  def deprecated(*)
    # noop
  end
end

ChefSpec::Coverage.start!
