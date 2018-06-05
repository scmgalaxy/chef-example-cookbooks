module MyApplication
  module Helper

    if RUBY_PLATFORM =~ /mswin|mingw32|windows/
      require 'win32/registry'
    end

    def is_app_installed?(name)
      return false
    end
  end
end
