# -*- encoding: utf-8 -*-
# stub: mysql2 0.5.6 ruby lib
# stub: ext/mysql2/extconf.rb

Gem::Specification.new do |s|
  s.name = "mysql2".freeze
  s.version = "0.5.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/brianmario/mysql2/issues", "changelog_uri" => "https://github.com/brianmario/mysql2/releases/tag/0.5.6", "documentation_uri" => "https://www.rubydoc.info/gems/mysql2/0.5.6", "homepage_uri" => "https://github.com/brianmario/mysql2", "msys2_mingw_dependencies" => "libmariadbclient", "source_code_uri" => "https://github.com/brianmario/mysql2/tree/0.5.6" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Brian Lopez".freeze, "Aaron Stone".freeze]
  s.date = "2024-02-08"
  s.email = ["seniorlopez@gmail.com".freeze, "aaron@serendipity.cx".freeze]
  s.extensions = ["ext/mysql2/extconf.rb".freeze]
  s.files = ["CHANGELOG.md".freeze, "LICENSE".freeze, "README.md".freeze, "ext/mysql2/client.c".freeze, "ext/mysql2/client.h".freeze, "ext/mysql2/extconf.rb".freeze, "ext/mysql2/infile.c".freeze, "ext/mysql2/infile.h".freeze, "ext/mysql2/mysql2_ext.c".freeze, "ext/mysql2/mysql2_ext.h".freeze, "ext/mysql2/mysql_enc_name_to_ruby.h".freeze, "ext/mysql2/mysql_enc_to_ruby.h".freeze, "ext/mysql2/result.c".freeze, "ext/mysql2/result.h".freeze, "ext/mysql2/statement.c".freeze, "ext/mysql2/statement.h".freeze, "ext/mysql2/wait_for_single_fd.h".freeze, "lib/mysql2.rb".freeze, "lib/mysql2/client.rb".freeze, "lib/mysql2/console.rb".freeze, "lib/mysql2/em.rb".freeze, "lib/mysql2/error.rb".freeze, "lib/mysql2/field.rb".freeze, "lib/mysql2/result.rb".freeze, "lib/mysql2/statement.rb".freeze, "lib/mysql2/version.rb".freeze, "support/3A79BD29.asc".freeze, "support/5072E1F5.asc".freeze, "support/C74CD1D8.asc".freeze, "support/libmysql.def".freeze, "support/mysql_enc_to_ruby.rb".freeze, "support/ruby_enc_to_mysql.rb".freeze]
  s.homepage = "https://github.com/brianmario/mysql2".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--charset=UTF-8".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0".freeze)
  s.rubygems_version = "3.4.19".freeze
  s.summary = "A simple, fast Mysql library for Ruby, binding to libmysql".freeze
end

