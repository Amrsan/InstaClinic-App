#!/usr/bin/env ruby

require 'xcodeproj'

# Path to your project's .xcworkspace
workspace_path = 'ios/Runner.xcworkspace'
# Path to the main project file (within the workspace)
project_path = 'ios/Runner.xcodeproj'
# Path to Pods project
pods_project_path = 'ios/Pods/Pods.xcodeproj'

# Open the project
project = Xcodeproj::Project.open(project_path)
pods_project = Xcodeproj::Project.open(pods_project_path)

def remove_g_flags(project)
  # For each build configuration
  project.build_configurations.each do |config|
    # Check for and remove -G flags
    build_settings = config.build_settings
    if build_settings['OTHER_CFLAGS']
      build_settings['OTHER_CFLAGS'] = build_settings['OTHER_CFLAGS'].to_s.gsub(/-[gG]\s+\S+|-[gG][a-zA-Z0-9_\-+]*/, '')
    end
    if build_settings['OTHER_CPLUSPLUSFLAGS']
      build_settings['OTHER_CPLUSPLUSFLAGS'] = build_settings['OTHER_CPLUSPLUSFLAGS'].to_s.gsub(/-[gG]\s+\S+|-[gG][a-zA-Z0-9_\-+]*/, '')
    end
    if build_settings['OTHER_LDFLAGS']
      build_settings['OTHER_LDFLAGS'] = build_settings['OTHER_LDFLAGS'].to_s.gsub(/-[gG]\s+\S+|-[gG][a-zA-Z0-9_\-+]*/, '')
    end
  end

  # For each target in the project
  project.targets.each do |target|
    puts "Processing target: #{target.name}"
    
    # For each build configuration in the target
    target.build_configurations.each do |config|
      build_settings = config.build_settings
      if build_settings['OTHER_CFLAGS']
        build_settings['OTHER_CFLAGS'] = build_settings['OTHER_CFLAGS'].to_s.gsub(/-[gG]\s+\S+|-[gG][a-zA-Z0-9_\-+]*/, '')
      end
      if build_settings['OTHER_CPLUSPLUSFLAGS']
        build_settings['OTHER_CPLUSPLUSFLAGS'] = build_settings['OTHER_CPLUSPLUSFLAGS'].to_s.gsub(/-[gG]\s+\S+|-[gG][a-zA-Z0-9_\-+]*/, '')
      end
      if build_settings['OTHER_LDFLAGS']
        build_settings['OTHER_LDFLAGS'] = build_settings['OTHER_LDFLAGS'].to_s.gsub(/-[gG]\s+\S+|-[gG][a-zA-Z0-9_\-+]*/, '')
      end
    end
  end
end

puts "Removing -G flags from main project..."
remove_g_flags(project)
project.save

puts "Removing -G flags from Pods project..."
remove_g_flags(pods_project)
pods_project.save

puts "Done!" 