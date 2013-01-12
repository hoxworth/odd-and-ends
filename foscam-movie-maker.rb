#!/usr/bin/env ruby

# Given a directory of images uploaded by Foscam's motion detection, create a movie of the images! (PROBABLY could be bash. Whatevs.)

require 'fileutils'
require 'time'

site = "hosted_site"

`mv ~/#{site}/cam/*.jpg ~/work`

Dir.chdir("work")
Dir["*.jpg"].each_with_index do |filename,i|
  filename =~ /_(\d\d\d\d)(\d\d)(\d\d)(\d\d)(\d\d)(\d\d)_/
  `mogrify -fill yellow -gravity NorthWest -draw 'text 5,5 "#{$1}-#{$2}-#{$3} #{$4}:#{$5}:#{$6}"' "#{filename}"`
  new_filename = sprintf("image_%04d.jpg", i + 1)
  FileUtils.mv(filename, new_filename)
end

out_movie = Time.now().strftime("%Y%m%d%H%M%S")

`ffmpeg -r 3 -i image_%04d.jpg -vcodec libx264 -vpre medium #{out_movie}.mp4`
`rm *.jpg`
`mv *.mp4 ~/#{hosted_site}/cam/movies`