require 'open3'

class String
  #
  def exec(dir='/', command_options={}, &block)
    options = ({"quiet": false, "display_stdout": true, "display_stderr": true}).merge(command_options)
    $stdout.puts  "⚡️Run command: #{self}" unless options[:quiet]
    exit_code = 0
    out = ""
    err = ""
    Open3.popen3(self, :chdir=> dir) do |_, stdout, stderr, wait_thr|


      until [stdout, stderr].all?(&:eof?)
        readable = IO.select([stdout, stderr])
        next unless readable&.first
        readable.first.each do |stream|
          data = +''
          begin
            stream.read_nonblock(1024, data)
          rescue EOFError
            # ignore, it's expected for read_nonblock to raise EOFError
            # when all is read
          end

          if stream == stdout
            out += data
            $stdout.puts data if !options[:quiet] && options[:display_stderr]
            block.call(line) if block
          else
            err += data
            $stderr.puts data if !options[:quiet] && options[:display_stderr]
            block.call(line) if block
          end
        end
      end
      exit_code = wait_thr.value.to_i
    end
    $stderr.puts "❌Exit code #{exit_code}. Command: #{self}" if exit_code != 0
    [exit_code, out, err]
  end
end