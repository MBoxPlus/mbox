require 'fileutils'
require_relative 'extension'

def install_mbox
    mbox_exists = system "command -v mbox"
    return true if mbox_exists
    "brew install mbox".exec
end
