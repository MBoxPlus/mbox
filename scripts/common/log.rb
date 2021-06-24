require "logger"

class MyLogger
  def initialize
    @logger = Logger.new(STDOUT)
    @logger.formatter = proc do |severity, datetime, progname, msg|
      "#{datetime.to_s[0..-7]}: #{msg}\n"
    end
    @error_logger = Logger.new(STDERR)
    @error_logger.formatter = proc do |severity, datetime, progname, msg|
      "#{datetime.to_s[0..-7]}: [#{progname}] #{msg}\n"
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
  def self.debug(message = nil, &block)
    $mlog.debug(message, &block)
  end

  def self.info(message = nil, &block)
    $mlog.info(message, &block)
  end

  def self.warn(message = nil, &block)
    $mlog.warn(message, &block)
  end

  def self.error(message = nil, &block)
    $mlog.error(message, &block)
  end

  def self.fatal(message = nil, &block)
    $mlog.error(message, &block)
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


