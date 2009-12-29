require 'rake/gempackagetask'
require File.dirname(__FILE__) + '/lib/github-control'
Bundler.require_env(:test)

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
  %w{ bin lib }.map do |dir|
    s.files += Dir["#{dir}/**/*.rb"]
  end

  s.executables =['github-control']
  s.default_executable = 'github-control'

  manifest = Bundler::Dsl.load_gemfile(File.dirname(__FILE__) + '/Gemfile')
  manifest.dependencies.each do |d|
    next unless d.only && d.only.include?('release')
    s.add_dependency(d.name, d.version)
  end
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end
