require "rake"
require "rake/clean"
require "rdoc/task"

CLEAN.include ["*.gem", "rdoc"]
RDOC_OPTS = ['--inline-source', '--line-numbers', '--title', 'deprecate_public: Warn when calling private methods via public interface', '--main', 'README.rdoc', '-f', 'hanna']

RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.options += RDOC_OPTS
  rdoc.rdoc_files.add %w"lib/deprecate_public.rb MIT-LICENSE CHANGELOG README.rdoc"
end

desc "Run specs"
task :test do
  sh "#{FileUtils::RUBY} -v test/deprecate_public_test.rb"
end
task :default=>[:test]

desc "Package deprecate_public"
task :package=>[:clean] do
  sh "#{FileUtils::RUBY} -S gem build deprecate_public.gemspec"
end
