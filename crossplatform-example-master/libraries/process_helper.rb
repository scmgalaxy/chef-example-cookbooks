if Chef::Platform.windows?
  require 'Win32API'
  require 'win32/registry'
  require 'win32ole'
end

module MyProcess
  module Helper

    def is_process_running?(process_name)
      return false
    end

  end
end
