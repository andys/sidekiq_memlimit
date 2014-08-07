# -*- encoding: utf-8 -*-
# stub: sidekiq_memlimit 0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "sidekiq_memlimit"
  s.version = "0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Andrew Snow"]
  s.date = "2014-08-07"
  s.description = "Restart Sidekiq gracefully when exceeding preset memory limit"
  s.email = "andrew@modulus.org"
  s.extra_rdoc_files = ["CHANGELOG", "README.md", "lib/sidekiq_memlimit.rb"]
  s.files = ["CHANGELOG", "Manifest", "README.md", "Rakefile", "lib/sidekiq_memlimit.rb", "sidekiq_memlimit.gemspec", "test/sidekiq_memlimit.rb"]
  s.homepage = "https://github.com/andys/sidekiq_memlimit"
  s.rdoc_options = ["--line-numbers", "--title", "Sidekiq_memlimit", "--main", "README.md"]
  s.rubyforge_project = "sidekiq_memlimit"
  s.rubygems_version = "2.2.2"
  s.summary = "Restart Sidekiq gracefully when exceeding preset memory limit"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sidekiq>, [">= 3.0"])
    else
      s.add_dependency(%q<sidekiq>, [">= 3.0"])
    end
  else
    s.add_dependency(%q<sidekiq>, [">= 3.0"])
  end
end
