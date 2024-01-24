Pod::Spec.new do |s|
        s.name                  = "TQCommonTools"
        s.version               = "1.0.0"
        s.summary               = "小视图组件"
        s.homepage              = "http://www.tql.com"
        s.license               = "MIT"
        s.author                = {"litianqi" => "litianqi@hqwx.com"}
        s.source                = {:git => "https://github.com/TianQiLi/TQCommonTools.git"}
        s.platform              = :ios, "9.0"
        s.requires_arc  = true
        s.source_files  = "**/**/*.{h,m,mm,swift,xib}"
        
        
        #s.resources = ""
        #s.resources = "TQCommonTools/**/*.xcassets"
        
        s.dependency 'Masonry'
      
       
end
