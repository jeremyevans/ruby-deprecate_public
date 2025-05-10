require "rake/clean"

CLEAN.include ["*.gem", "rdoc", "coverage"]

desc "Generate rdoc"
task :rdoc do
  rdoc_dir = "rdoc"
  rdoc_opts = ["--line-numbers", "--inline-source", '--title', 'deprecate_public: Warn when calling private methods via public interface']

  begin
    gem 'hanna'
    rdoc_opts.concat(['-f', 'hanna'])
  rescue Gem::LoadError
  end

  rdoc_opts.concat(['--main', 'README.rdoc', "-o", rdoc_dir] +
    %w"README.rdoc CHANGELOG MIT-LICENSE" +
    Dir["lib/**/*.rb"]
  )

  FileUtils.rm_rf(rdoc_dir)

  require "rdoc"
  RDoc::RDoc.new.document(rdoc_opts)
end

desc "Run specs"
task :test do
  sh "#{FileUtils::RUBY} -w #{'-W:strict_unused_block' if RUBY_VERSION >= '3.4'} test/deprecate_public_test.rb"
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
