require_relative 'IntervalSearchTree'
require 'csv'

csv_path = ARGV[0]

file = File.read(csv_path)
csv = CSV.parse(file)

txt_file = File.new(ARGV[1], "w")

tree = IntervalSearchTree.new

csv.each do |row|
  action = row[0].strip
  start = row[1].to_i
  endnum = row[2].to_i

  node = ISTNode.new(start, endnum)

  if action == "add"

    tree.merge(node)
  elsif action == "remove"

    tree.delete_range(node)
  end
  txt_file.puts(tree.in_order_traversal.to_s)
end
