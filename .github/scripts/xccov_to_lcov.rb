# frozen_string_literal: true

require "open3"
require "pathname"

result_bundle = File.expand_path(ARGV.fetch(0))
source_root = File.expand_path(ARGV.fetch(1))
output_path = ARGV.fetch(2)

abort "Missing result bundle: #{result_bundle}" unless File.directory?(result_bundle)

def capture!(*command)
  stdout, stderr, status = Open3.capture3(*command)
  return stdout if status.success?

  warn stderr
  abort "Command failed: #{command.join(' ')}"
end

source_prefix = File.join(source_root, "Sources") + File::SEPARATOR
source_files = capture!(
  "xcrun",
  "xccov",
  "view",
  "--archive",
  "--file-list",
  result_bundle
).lines.map do |line|
  path = File.expand_path(line.strip)
  path if path.start_with?(source_prefix) && File.extname(path) == ".swift"
end.compact.uniq.sort

abort "No Swift source files found in coverage archive" if source_files.empty?

records = source_files.map do |source_file|
  line_counts_by_number = Hash.new(0)
  capture!(
    "xcrun",
    "xccov",
    "view",
    "--archive",
    "--file",
    source_file,
    result_bundle
  ).each_line do |line|
    match = line.match(/^\s*(\d+):\s+(\*|\d+)(?:\s|$)/)
    next unless match && match[2] != "*"

    line_counts_by_number[match[1].to_i] += match[2].to_i
  end
  line_counts = line_counts_by_number.sort

  next if line_counts.empty?

  relative_path = Pathname.new(source_file).relative_path_from(
    Pathname.new(source_root)
  )
  covered_lines = line_counts.count { |(_, count)| count.positive? }

  [
    "SF:#{relative_path}",
    *line_counts.map { |(line_number, count)| "DA:#{line_number},#{count}" },
    "LF:#{line_counts.count}",
    "LH:#{covered_lines}",
    "end_of_record"
  ].join("\n")
end.compact

abort "No executable Swift source lines found in coverage archive" if records.empty?

File.write(output_path, records.join("\n") + "\n")
