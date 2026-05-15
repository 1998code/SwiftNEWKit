# frozen_string_literal: true

input_path = ARGV.fetch(0)
output_path = ARGV.fetch(1)

def ignored_lines_for(source_path)
  return [] unless File.file?(source_path)

  ignored = []
  active = false

  File.readlines(source_path).each_with_index do |line, index|
    line_number = index + 1

    if line.include?("coverage:ignore-line") || line.include?("LCOV_EXCL_LINE")
      ignored << line_number
      next
    end

    if line.include?("coverage:ignore-start") || line.include?("LCOV_EXCL_START")
      active = true
      ignored << line_number
      next
    end

    ignored << line_number if active

    active = false if line.include?("coverage:ignore-end") || line.include?("LCOV_EXCL_STOP")
  end

  ignored
end

def flush_record(output, record, ignored_lines)
  covered = 0
  found = 0

  filtered = []

  record.each do |line|
    if line.start_with?("DA:")
      line_number, hit_count = line.delete_prefix("DA:").split(",", 2)
      next if ignored_lines.include?(line_number.to_i)

      found += 1
      covered += 1 if hit_count.to_i.positive?
      filtered << line
    elsif line.start_with?("LF:") || line.start_with?("LH:")
      next
    else
      filtered << line
    end
  end

  filtered.insert(-2, "LF:#{found}\n", "LH:#{covered}\n") if filtered.last == "end_of_record\n"
  output.concat(filtered)
end

source_file = nil
ignored_lines = []
record = []
output = []

File.readlines(input_path).each do |line|
  if line.start_with?("SF:")
    flush_record(output, record, ignored_lines) unless record.empty?
    source_file = line.delete_prefix("SF:").strip
    ignored_lines = ignored_lines_for(source_file)
    record = [line]
  else
    record << line
  end
end

flush_record(output, record, ignored_lines) unless record.empty?

File.write(output_path, output.join)
