#!/usr/bin/env ruby

require 'find'

# Path & executables vars
source_dir = '/path/where/your/files/are'
tmp_dir = '/tmp/'
expand_path = '/usr/bin/expand'
cat_path = '/bin/cat'
rm_path = '/bin/rm'

# How many spaces & what to (and not to) convert
how_many_spaces = 2
valid_extensions = ['.rake', '.css', '.rhtml', '.rb', '.erb', '.php', '.js', '.haml', '.yml', '.sql', '.conf', '.builder']
valid_extensionless_files = ['.htaccess']
invalid_dirs = ['.svn', '.git', 'changes', 'cache', 'create', 'data', 'php', 'vendor', 'test', 'tmp', 'log', 'doc', 'gems']
invalid_files = ['prototype.js', 'controls.js', 'dragdrop.js', 'effects.js', 'dispatch.fcgi', 'dispatch.rb', 'merb.fcgi', 'dispatch.cgi']
total_files = 0

Find.find(source_dir) do |path|
  if FileTest.directory?(path)
    # This is a directory
    if invalid_dirs.include?(File.basename(path.downcase))
      Find.prune
    else
      # This is an OK directory
      next
    end
  else
    # here are files
    extension = File.extname(path.downcase)
    if valid_extensionless_files.include?(File.basename(path.downcase)) || (valid_extensions.include?(extension) && !invalid_files.include?(File.basename(path.downcase)))
      puts " -> Converting file: #{path}\n"
      tmp_file = "#{tmp_dir}~#{File.basename(path.downcase)}"
      full_cmd = "#{expand_path} -t#{how_many_spaces} #{path} > #{tmp_file}; #{cat_path} #{tmp_file} > #{path}; #{rm_path} #{tmp_file}"
      system(full_cmd)
      total_files += 1
    end
  end
end
puts "Total files modified: #{total_files}"