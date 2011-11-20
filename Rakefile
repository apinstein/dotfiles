# from http://github.com/ryanb/dotfiles/tree/master
#
# Copyright (c) 2008 Ryan Bates
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'rake'
require 'fileutils'

task :default => :install

desc "Pull git submodules"
task :git_submodules do
    puts "Initializing submodules..."
    sh "git submodule init && git submodule update"
end

desc "install the dot files into user's home directory"
task :install => :git_submodules do
  replace_all = false
  Dir['*'].each do |file|
    next if %w[Rakefile README LICENSE].include? file
    next if FileTest.symlink?(File.join(ENV['HOME'], ".#{file}"))

    # handle .local versions; only copy if DNE
    if file.match('\.local$')
        if !File.exist?(File.join(ENV['HOME'], ".#{file}"))
            FileUtils.copy(file, File.join(ENV['HOME'], ".#{file}"))
        end
        next
    end
    
    # handle normal dotfiles
    if File.exist?(File.join(ENV['HOME'], ".#{file}"))
      if replace_all
        replace_file(file)
      else
        print "overwrite ~/.#{file}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts "skipping ~/.#{file}"
        end
      end
    else
      link_file(file)
    end
  end

  Rake::Task["vimupdate"].execute
end

desc "VIM/Vundle"
task :vimupdate => :git_submodules do
    puts "Updating vundle..."
    sh "git submodule update"

    puts "Installing/Updating vundles..."
    sh "vim -c ':BundleInstall!' -c ':BundleClean' -c ':qa'"

    puts "Done!"
end


def replace_file(file)
  system %Q{rm "$HOME/.#{file}"}
  link_file(file)
end

def link_file(file)
  puts "linking ~/.#{file}"
  system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
end
