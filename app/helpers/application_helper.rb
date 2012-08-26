module ApplicationHelper
  JS_DIR = 'app/assets/javascripts'
  
  def this_cs_file?(path)
    File.file? "#{JS_DIR}/#{path}.js.coffee"
  end
  
  def cs_include_tag(*paths)
    paths.each do |path|
      unless this_cs_file? path
        paths.delete path
      end
    end
    javascript_include_tag *paths
  end
  
  def cs_launch_action
    if this_cs_file? "#{params[:controller]}/#{params[:action]}"
      javascript_tag "$.app.#{params[:controller]}.#{params[:action]}();"
    end
  end
end
