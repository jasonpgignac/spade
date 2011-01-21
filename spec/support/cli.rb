module SpecHelpers
  attr_reader :stdin, :stdout, :stderr

  def env
    @env ||= {}
  end

  def spade(*argv)
    opts = Hash === argv.last ? argv.pop : {}

    kill!
    create_pipes

    @pid = Process.fork do
      Dir.chdir opts[:chdir] if opts[:chdir]

      @stdout.close
      STDOUT.reopen @stdout_child

      @stdin.close
      STDIN.reopen @stdin_child

      if opts[:track_stderr]
        @stderr.close
        STDERR.reopen @stderr_child
      end

      env.each do |key, val|
        ENV[key] = val
      end

      Spade::CLI::Base.start(argv)
    end

    @stdout_child.close
    @stdin_child.close
    @stderr_child.close
    @pid
  end

  def out_until_block(io = stdout)
    # read 1 first so we wait until the process is done processing the last write
    chars  = io.read(1)

    loop do
      chars << io.read_nonblock(1000)
      sleep 0.05
    end
  rescue Errno::EAGAIN, EOFError
    chars
  end

  def input(line, opts = {})
    if on = opts[:on]
      should_block_on on
    end
    stdin << "#{line}\n"
  end

  def wait
    return unless @pid

    pid, status = Process.wait2(@pid, 0)

    @exit_status = status
    @pid = nil
  end

  def exit_status
    wait
    @exit_status
  end

  def kill!
    Process.kill(9, @pid) if @pid
  end

  def create_pipes
    @stdout, @stdout_child = IO.pipe
    @stdin_child, @stdin   = IO.pipe
    @stderr, @stderr_child = IO.pipe
  end

  def write_api_key(api_key)
    FileUtils.mkdir_p(spade_dir)
    File.open(spade_dir("credentials"), "w") do |file|
      file.write YAML.dump(:spade_api_key => api_key)
    end
  end
end
