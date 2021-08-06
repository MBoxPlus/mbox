require "logger"

class MyLogger
  def initialize
    @logger = Logger.new(STDOUT)
    @logger.formatter = proc do |severity, datetime, progname, msg|
      "#{msg}\n"
    end
    @error_logger = Logger.new(STDERR)
    @error_logger.formatter = proc do |severity, datetime, progname, msg|
      "#{msg}\n"
    end
  end

  def debug(message = nil, &block)
    @logger.debug(message, &block)
  end

  def info(message = nil, &block)
    @logger.info(message, &block)
  end

  def warn(message = nil, &block)
    @logger.warn(message, &block)
  end

  def error(message = nil, &block)
    @error_logger.error(message, &block)
  end

  def fatal(message = nil, &block)
    @error_logger.error(message, &block)
  end
end

$mlog = MyLogger.new()

class LOG
  @@prefix = ""

  def self.debug(message = nil, &block)
    if block
      $mlog.debug(message)
      @@prefix += "  "
      block.call
      @@prefix.slice!(0, @@prefix.length-2)
    else
      $mlog.debug(message)
    end
  end

  def self.info(message = nil, &block)
     if block
       $mlog.info(@@prefix + message)
       @@prefix += "  "
       block.call
       @@prefix = @@prefix.slice(0, @@prefix.length - 2)
     else
       $mlog.info(@@prefix + message)
     end
  end

  def self.warn(message = nil, &block)
    if block
      $mlog.warn(@@prefix + message)
      @@prefix += "  "
      block.call
      @@prefix = @@prefix.slice(0, @@prefix.length - 2)
    else
      $mlog.warn(@@prefix + message)
    end
  end

  def self.error(message = nil, &block)
    if block
      $mlog.error(@@prefix + message)
      @@prefix += "  "
      block.call
      @@prefix = @@prefix.slice(0, @@prefix.length - 2)
    else
      $mlog.error(@@prefix + message)
    end
  end

  def self.fatal(message = nil, &block)
    if block
      $mlog.fatal(@@prefix + message)
      @@prefix += "  "
      block.call
      @@prefix = @@prefix.slice(0, @@prefix.length - 2)
    else
      $mlog.fatal(@@prefix + message)
    end
  end
end

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end

  def light_blue
    colorize(36)
  end
end


