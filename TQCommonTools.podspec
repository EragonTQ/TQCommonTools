Pod::Spec.new do |s|
        s.name                  = "TQCommonTools"
        s.version               = "2.0.0"
        s.summary               = "小视图组件"
        s.homepage              = "http://www.tql.com"
        s.license               = "MIT"
        s.author                = {"litianqi" => "litianqi@yy.com"}
        s.source                = {:git => "https://github.com/EragonTQ/TQCommonTools.git"}
        s.platform              = :ios, 11.0"
        s.requires_arc  = true
        s.source_files  = "**/**/*.{h,m,mm,swift,xib}"
        
        
        #s.resources = ""
        #s.resources = "TQCommonTools/**/*.xcassets"
        
        s.dependency 'Masonry'
      
       
end
