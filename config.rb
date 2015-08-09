# This is a temporary PoC
require 'monkey-patch-markdown'

###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

set :layout, :sidebar_layout

# Per-page layout changes:
#
# With no layout
# page '/path/to/file.html', layout: false
#
# With alternative layout
# page '/path/to/file.html', :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
  # page '/admin/*'
# end

# Proxy pages (https://middlemanapp.com/advanced/dynamic_pages/)
# proxy '/this-page-has-no-template.html', '/template-file.html', locals: {
#   which_fake_page: 'Rendering a fake page with a local variable' }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     'Helping'
#   end
# end

helpers do
  def groups
    data.toc.groups
  end

  def group_pages(group)
    sitemap.where(group: group).order_by(:sort).all
  end

  def sidebar_pages
    pages = {}
    groups.each do |group|
      pages[group] = group_pages(group)
    end
    return pages
  end

  def nav_active(path)
    current_page.path == path ? 'active' : ''
  end
end

set :css_dir, 'assets/stylesheets'
set :js_dir, 'assets/javascripts'
set :images_dir, 'assets/images'
set :layouts_dir, 'assets/layouts'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, '/Content/images/'
end

activate :google_analytics do |ga|
  ga.tracking_id = ENV['GOOGLE_ANALYTICS_TRACKING_ID']
  ga.development = false
  ga.minify = true
  ga.domain_name = ENV['GOOGLE_ANALYTICS_DOMAIN_NAME']
end

activate :syntax, line_numbers: false
set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true,
  autolink: true,
  tables: true,
  no_intra_emphasis: true,
  with_toc_data: true,
  strikethrough: true,
  superscript: true
