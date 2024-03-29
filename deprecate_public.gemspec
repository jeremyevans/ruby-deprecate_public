Gem::Specification.new do |s|
  s.name = 'deprecate_public'
  s.version = '1.1.0'
  s.platform = Gem::Platform::RUBY
  s.extra_rdoc_files = ["README.rdoc", "CHANGELOG", "MIT-LICENSE"]
  s.rdoc_options += ["--quiet", '--inline-source', '--line-numbers', '--title', 'deprecate_public: Warn when calling private methods and accessing private constants via public interface', '--main', 'README.rdoc']
  s.summary = "Warn when calling private methods and accessing private constants via public interface"
  s.description = s.summary
  s.license = 'MIT'
  s.author = "Jeremy Evans"
  s.email = "code@jeremyevans.net"
  s.homepage = "https://github.com/jeremyevans/ruby-deprecate_public"
  s.files = %w(MIT-LICENSE CHANGELOG README.rdoc) + Dir["lib/deprecate_public.rb"]
  s.add_development_dependency "minitest-global_expectations"
end
