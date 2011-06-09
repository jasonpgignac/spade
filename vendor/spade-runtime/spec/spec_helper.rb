Bundler.require :default, :development

require 'support/cli'
require 'support/core_test'
require 'support/path'
require 'support/matchers'

RSpec.configure do |config|
  working_dir = Dir.pwd

  config.include SpecHelpers

  config.around do |blk|
    reset!

    blk.call

    kill!
    Dir.chdir working_dir if Dir.pwd != working_dir
  end
end


