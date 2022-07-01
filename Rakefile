require "rake/clean"
require "rdoc/task"

CLEAN.include ["*.gem", "rdoc", "coverage"]

RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.options += ['--inline-source', '--line-numbers', '--title', 'deprecate_public: Warn when calling private methods via public interface', '--main', 'README.rdoc', '-f', 'hanna']
  rdoc.rdoc_files.add %w"lib/deprecate_public.rb MIT-LICENSE CHANGELOG README.rdoc"
end

desc "Run specs"
task :test do
  sh "#{FileUtils::RUBY} -w test/deprecate_public_test.rb"
end
task :default=>[:test]

desc "Run specs with coverage"
task :test_cov do
  ENV['COVERAGE'] = '1'
  sh "#{FileUtils::RUBY} test/deprecate_public_test.rb"
end

desc "Package deprecate_public"
task :package=>[:clean] do
  sh "#{FileUtils::RUBY} -S gem build deprecate_public.gemspec"
end
