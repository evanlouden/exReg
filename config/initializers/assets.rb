# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( slider.js )
Rails.application.config.assets.precompile += %w( slider_edit.js )
Rails.application.config.assets.precompile += %w( slider_edit_teacher.js )
Rails.application.config.assets.precompile += %w( slider_time_teacher.js )
Rails.application.config.assets.precompile += %w( slider_time.js )
Rails.application.config.assets.precompile += %w( absentToggle.js )
Rails.application.config.assets.precompile += %w( dayFromDate.js )
Rails.application.config.assets.precompile += %w( teacherShow.js )
Rails.application.config.assets.precompile += %w( availTransparency.js )
Rails.application.config.assets.precompile += %w( teacherDashCal.js )
Rails.application.config.assets.precompile += %w( adminCalendar.js )
Rails.application.config.assets.precompile += %w( teacherCalendar.js )

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
