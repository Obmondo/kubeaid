#!/usr/bin/env ruby
#
# Make sure that any YAML files (passed as a single file names as ARGV or
# filenames read from stdin if ARGV[0] == '-') doesn't contain keywords.
#
# If not given any files, search for any files ending in '.yaml' from current
# dir.
#
# If env FIRST is set, quit after the first error.
#
# Filenames checked are printed to stdout, while errors are printed to stderr.

require 'yaml'

files = ARGV[0] == '-' ? ARGF.readlines : [ARGV[0]]

class YAMLHasKeywordError < StandardError
end

unless files.first {|x| x.nil?}
  files = Dir['argocd-clusters-managed/*/**.yaml', 'argocd-helm-charts/*/values.yaml']
end

puts files.inspect
def find_keyword(d)
  d.each do |k, v|
    if v.respond_to? :each
      find_keyword v
    end

    raise YAMLHasKeywordError if v.is_a? Symbol
  end
end

def get_file_line(f, l, c)
  file = File.open(f, 'r')
  l.times { file.gets }
  linum = l.to_s
  line = " #{$_} "
  marker = ' ' * (c - 1 + linum.length + 1) + '_^_' + ' ' * (line.length - c + 1)

  return "#{linum}: #{line}#{marker}"
end

def get_file_line_from_ex(f, ex)
  return get_file_line(f, ex.line, ex.column)
end

has_error = false

files.each do |f|
  f = f.strip
  next if f.empty?
  # environments is just a symlink; skip it
  next if f.start_with? 'environments/'

  begin
    data = YAML.load open(f)
    # Ignore strings; they are valid YAML as well
    next if data.is_a? String

    # Ignore nils; this happens when we have a YAML file with a header (`---`)
    # but no content
    next if data.nil?

    # Ignore empty files (or files that are all comments)
    next if data.class == FalseClass

    find_keyword data
  rescue Psych::SyntaxError => ex
    STDERR.puts "#{f}: file contains invalid syntax: #{ex.problem}"
    STDERR.puts get_file_line_from_ex(f, ex)
    has_error = true
  rescue YAMLHasKeywordError => ex
    STDERR.puts "#{f}: file contains a Ruby keyword. Please add quotes to any string values beginning with ':' (colon)."
    has_error = true
  rescue ArgumentError => ex
    STDERR.puts "#{f}: file has invalid YAML: #{ex}"
    has_error = true
  end

  exit 1 if has_error && ENV['FIRST']

end

exit 1 if has_error
