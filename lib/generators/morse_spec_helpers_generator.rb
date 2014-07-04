class MorseSpecHelpersGenerator < Rails::Generators::Base
  source_root(File.expand_path(File.dirname(__FILE__)))
  def setup_support
    support_dir="#{Rails.root}/spec/support"
    image_dir="#{support_dir}/images"
    Dir.mkdir(support_dir) unless Dir.exist?(support_dir)
    Dir.mkdir(image_dir) unless Dir.exist?(image_dir)
    copy_file '../support/project_helpers.rb',"#{support_dir}/project_helpers.rb"
    copy_file '../support/images/placeholder.png',"#{image_dir}/placeholder.png"
    copy_file '../initializers/morse.rb',"#{Rails.root}/config/initializers/morse.rb"
  end
end
