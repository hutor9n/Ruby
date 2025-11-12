require 'find'
require 'json'
require 'csv'

def file_signature(path, length = 1024)
  begin
    File.open(path, 'rb') { |f| f.read(length) } || ""
  rescue
    ""  
  end
end

def collect_files(root)
  files = []
  Find.find(root) do |path|
    next unless File.file?(path)
    size = File.size(path) rescue next
    files << { path: path, size: size }
  end
  files
end

def add_signatures(files)
  files.each do |f|
    f[:signature] = file_signature(f[:path])
  end
end

def find_duplicates(files)
  groups = {}
  files.each do |f|
    key = "#{f[:size]}-#{f[:signature]}"
    groups[key] ||= []
    groups[key] << f[:path]
  end
  groups.select { |_, paths| paths.size > 1 }
end

def build_report(files, duplicate_groups)
  groups = duplicate_groups.map do |key, paths|
    size = paths.size > 0 ? File.size(paths[0]) : 0
    {
      size_bytes: size,
      saved_if_dedup_bytes: size * (paths.size - 1),
      files: paths
    }
  end

  {
    scanned_files: files.size,
    groups: groups
  }
end

root = ARGV[0] || '.'

files = collect_files(root)
add_signatures(files)
duplicates = find_duplicates(files)
report = build_report(files, duplicates)

File.write('duplicates.json', JSON.pretty_generate(report))

CSV.open('duplicates.csv', 'w') do |csv|
  csv << ['size_bytes', 'saved_if_dedup_bytes', 'files_joined']
  report[:groups].each do |g|
    csv << [g[:size_bytes], g[:saved_if_dedup_bytes], g[:files].join('|')]
  end
end

puts "Scanned files: #{report[:scanned_files]}"
puts "Found duplicate groups: #{report[:groups].length}"

