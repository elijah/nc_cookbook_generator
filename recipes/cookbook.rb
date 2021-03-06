
context = ChefDK::Generator.context
cookbook_dir = File.join(context.cookbook_root, context.cookbook_name)

# cookbook root dir
directory cookbook_dir

# metadata.rb
template "#{cookbook_dir}/metadata.rb" do
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# README
template "#{cookbook_dir}/README.md" do
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# chefignore
cookbook_file "#{cookbook_dir}/chefignore"

if context.use_berkshelf

  # Berks
  cookbook_file "#{cookbook_dir}/Berksfile" do
    action :create_if_missing
  end
else

  # Policyfile
  template "#{cookbook_dir}/Policyfile.rb" do
    source 'Policyfile.rb.erb'
    helpers(ChefDK::Generator::TemplateHelper)
  end

end

tk_framework = ENV['TK_FRAMEWORK']

if ENV['TK_FRAMEWORK'] == 'inspec'
  use_inspec = true
else
  use_inspec = false
  tk_framework = 'serverspec'
end

# TK & Serverspec
template "#{cookbook_dir}/.kitchen.yml" do
  if context.use_berkshelf
    source 'kitchen.yml.erb'
    variables(
      use_inspec: use_inspec
    )
  else
    source 'kitchen_policyfile.yml.erb'
  end

  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

directory "#{cookbook_dir}/test/integration/default/#{tk_framework}" do
  recursive true
end

directory "#{cookbook_dir}/test/integration/helpers/#{tk_framework}" do
  recursive true
end

template "#{cookbook_dir}/test/integration/helpers/#{tk_framework}/spec_helper.rb" do
  source "#{tk_framework}_spec_helper.rb.erb"
  variables(
    titleized: context.cookbook_name.split(%r{ |\_}).map(&:capitalize).join
  )
  action :create_if_missing
end

template "#{cookbook_dir}/test/integration/default/#{tk_framework}/default_spec.rb" do
  source "#{tk_framework}_default_spec.rb.erb"
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# Chefspec
directory "#{cookbook_dir}/spec/unit/recipes" do
  recursive true
end

cookbook_file "#{cookbook_dir}/spec/spec_helper.rb" do
  if context.use_berkshelf
    source 'spec_helper.rb'
  else
    source 'spec_helper_policyfile.rb'
  end

  action :create_if_missing
end

template "#{cookbook_dir}/spec/unit/recipes/default_spec.rb" do
  source 'recipe_spec.rb.erb'
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# Recipes

directory "#{cookbook_dir}/recipes"

template "#{cookbook_dir}/recipes/default.rb" do
  source 'recipe.rb.erb'
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# git
if context.have_git
  unless context.skip_git_init

    execute('initialize-git') do
      command('git init .')
      cwd cookbook_dir
    end
  end

  cookbook_file "#{cookbook_dir}/.gitignore" do
    source 'gitignore'
  end
end

# Gemfile
template "#{cookbook_dir}/Gemfile" do
  source 'Gemfile.erb'
  variables(
    use_inspec: use_inspec
  )
  action :create
end

# Rubocop
cookbook_file "#{cookbook_dir}/.rubocop.yml" do
  source 'rubocop.yml'
  action :create
end

# Rakefile
cookbook_file "#{cookbook_dir}/Rakefile" do
  action :create
end

# pre-commit-config.yaml
cookbook_file "#{cookbook_dir}/.pre-commit-config.yaml" do
  source 'pre-commit-config.yaml'
  action :create
end

# Depedencies
gem_package 'bundler'

execute 'install pre-commit' do
  command 'pip install pre-commit'
end

execute 'install pre-commit hook' do
  cwd cookbook_dir
  command 'pre-commit install'
end
