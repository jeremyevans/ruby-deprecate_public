Gem::Specification.new do |s|
  s.name = 'deprecate_public'
  s.version = '1.0.0'
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc", "CHANGELOG", "MIT-LICENSE"]
  s.rdoc_options += ["--quiet", '--inline-source', '--line-numbers', '--title', 'deprecate_public: Warn when calling private methods via public interface', '--main', 'README.rdoc']
  s.summary = "Warn when calling private methods via public interface"
  s.description = s.summary
  s.license = 'MIT'
  s.author = "Jeremy Evans"
  s.email = "code@jeremyevans.net"
  s.homepage = "https://github.com/jeremyevans/ruby-deprecate_public"
  s.files = %w(MIT-LICENSE CHANGELOG README.rdoc Rakefile) + Dir["{lib,test}/deprecate_public*.rb"]
end
