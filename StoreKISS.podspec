Pod::Spec.new do |s|
  s.name     = 'StoreKISS'
  s.version  = '0.1'
  s.license  = 'MIT'
  s.summary  = 'Lightweight wrapper for Apple\'s StoreKit framework created with KISS concept and love ❤.'
  s.homepage = 'https://github.com/mishakarpenko/StoreKISS'
  s.authors  = {'Misha Karpenko' => 'karpenko.misha@gmail.com'}
  s.source   = {:git => 'git://github.com/mishakarpenko/StoreKISS.git'}
  s.source_files = 'StoreKISS/StoreKISS/StoreKISS/StoreKISS'
  s.clean_paths = []
  s.framework = 'StoreKit'
  s.requires_arc = true
  s.dependency 'Reachability'
end