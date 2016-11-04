platform :ios, '8.0'
target 'CustomEmojiKeyboard' do
    pod 'MJExtension',                              '~> 3.0.13'
    pod 'SDWebImage',                               '~> 3.8.2'
end

post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
end
