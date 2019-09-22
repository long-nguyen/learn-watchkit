# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

def shared_pods
  pod 'AFNetworking'
  pod 'FMDB'
  pod 'RNCryptor-objc'
end

target 'TestWatchApp' do
end

target 'TestWatchApp Extension' do
  platform :watchos, '2.0'
end

target 'TestWatchOSApp' do
  platform :ios, '9.3'
end

target 'WatchDataKit' do
  platform :watchos, '2.0'
  shared_pods
end

target 'AppDataKit' do
 platform :ios, '9.3'
 shared_pods
end
