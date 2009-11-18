require 'rake/gempackagetask'
require "spec/rake/spectask"
require File.dirname(__FILE__) + '/lib/github-control/version'

desc "Default: run specs"
task :default => :spec

desc "Run specs"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.libs << "lib" << "spec"
  t.spec_opts << "-c -D"
  t.pattern = "spec/**/*_spec.rb"
end

spec = Gem::Specification.new do |s|
  s.name = "github-control"
  s.version = GithubControl::VERSION

  s.author = "Tim Carey-Smith"
  s.email = "tim@spork.in"
  s.date = Date.today.to_s
  s.description = "github-control allows you to interact with Github through a nice ruby interface"
  s.summary = s.description
  s.homepage = "http://github.com/halorgium/github-control"

  s.has_rdoc = true
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]

  s.files = ["config/example.yml"]
  %w{ bin lib spec }.map do |dir|
    s.files += Dir["#{dir}/**/*.rb"]
  end

  s.executables =['github-control']
  s.default_executable = 'github-control'

  s.add_dependency("rest-client", [">= 0.9.2"])
  s.add_dependency("json", [">= 1.1.3"])
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end
