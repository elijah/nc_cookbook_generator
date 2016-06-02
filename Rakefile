require 'foodcritic'
require 'rubocop/rake_task'
require 'bundler/audit/cli'

namespace :style do
  desc 'Check Ruby style'
  RuboCop::RakeTask.new :ruby

  desc 'Check Chef style'
  FoodCritic::Rake::LintTask.new :chef do |task|
    task.options = { fail_tags: %w(any) }
  end
end

desc 'Check all styling'
task style: %w(style:ruby style:chef)

desc 'Check Foodcritic rules'
task :foodcritic do
  result = FoodCritic::Linter.new.check cookbook_paths: '.'

  puts result if result.failed? || !result.warnings.empty?
end

namespace :bundler do
  desc 'Updates the ruby-advisory-db and runs audit'
  task :audit do
    %w(update check).each do |command|
      Bundler::Audit::CLI.start [command]
    end
  end
end

task default: %w(style foodcritic bundler)
