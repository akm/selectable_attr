source 'http://rubygems.org'

group :development do
  gem "autotest"
end

group :test do
  gem "rspec", ">= 2.0.1"
  if RUBY_PLATFORM =~ /mswin(?!ce)|mingw|cygwin|bccwin/i
    gem "rcov", "= 0.8.1.2.0"
  else
    gem "rcov", "= 0.9.9"
  end
end
