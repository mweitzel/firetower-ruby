def write_tmpfile
  # firetower sends two signals,
  # p
  #   SIGHUP to the parent
  #   and multiple to the child, SIGTERM and SIGINT, and in some versions SIGKILL
  # so we mark this process as the parent, and handle SIGHUP
  # while making a dummy process and denote it as the child
  `echo #{Process.pid} $(sleep 1000000000000000 > /dev/null & echo $!) > .firetower`
end


class TrapCatchException < Exception ; end

def set_traps
  Signal.trap 'HUP' do
    raise TrapCatchException, 'trap in retry'
  end
  Signal.trap 'QUIT' do
    raise TrapCatchException, 'trap in retry'
  end
  Signal.trap 'INT' do
    `rm .firetower`
    exit
  end
  Signal.trap 'TERM' do
    `rm .firetower`
    exit
  end
end

def safely_load
  while true do
    STDERR.print `clear`
    STDERR.puts ARGV.join(' ')
    STDERR.puts `date`
    STDERR.puts
    t0 = Time.now
    begin
      load ARGV.first
      STDERR.puts
      STDERR.puts (Time.utc(2000,1,1) + (Time.now - t0)).utc.strftime("real %Mm%S.%3Ns")
      return
    rescue TrapCatchException => e
      next
    rescue Exception => e
      STDERR.puts "#{e.backtrace.first}: #{e.message} (#{e.class})", e.backtrace.drop(1).map{|s| "\t#{s}"}
      STDERR.puts
      STDERR.puts (Time.utc(2000,1,1) + (Time.now - t0)).utc.strftime("real %Mm%S.%3N")
      return
    end
  end
end

def frame &block
  STDERR.print `clear`
  STDERR.puts `date`
  STDERR.puts
  t0 = Time.now
  block.call
  STDERR.puts
  STDERR.puts (Time.utc(2000,1,1) + (Time.now - t0)).utc.strftime("real %Mm%S.%3N")
  STDERR.puts
  STDERR.puts
end

def set_ctrl_r
  `stty quit ^r`
end
set_ctrl_r

write_tmpfile
set_traps
safely_load
set_traps

while true do
  begin
    sleep 1000000000000000000
  rescue TrapCatchException => e
    safely_load
    write_tmpfile
    set_traps
    next
  end
end
