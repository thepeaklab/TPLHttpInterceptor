Pod::Spec.new do |s|
  s.name             = "TPLHttpInterceptor"
  s.version          = "0.1.0"
  s.summary          = "Intercept (and modify) NSURLRequests"

  s.description      = <<-DESC
Intercept (and modify) NSURLRequests

TPLHttpInterceptor enables you to intercept and modify all NSURLRequests,
also requests which are not triggered from your own code (UIWebView, other libraries, ...)
                       DESC

  s.homepage         = "https://github.com/thepeaklab/TPLHttpInterceptor"
  s.license          = 'MIT'
  s.author           = { "Christoph Pageler" => "cp@thepeaklab.com" }
  s.source           = { :git => "https://github.com/thepeaklab/TPLHttpInterceptor.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/thepeaklab'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'TPLHttpInterceptor' => ['Pod/Assets/*.png']
  }
end
