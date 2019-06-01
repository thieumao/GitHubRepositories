# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def shared_pods
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'Alamofire', '~> 4.8'
  pod 'AlamofireObjectMapper', '~> 5.2'
  pod 'KeychainSwift', '~> 15.0'
end

target 'GitHubRepositories' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for GitHubRepositories
  shared_pods

  target 'GitHubRepositoriesTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'GitHubRepositoriesUITests' do
    inherit! :search_paths
    # Pods for testing
    shared_pods
  end

end
