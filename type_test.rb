require 'hn2json'

a = HN2JSON.find 4592427 # post
b = HN2JSON.find 4586128 # post

c = HN2JSON.find 3002492 # poll
d = HN2JSON.find 2186138 # poll
e = HN2JSON.find 3746692 # poll

f = HN2JSON.find 3747766 # comment
g = HN2JSON.find 3748189 # comment
h = HN2JSON.find 3747404 # comment

i = HN2JSON.find 4591602 # discussion
j = HN2JSON.find 4590869 # discussion
k = HN2JSON.find 4540136 # discussion

if a.type != :post && b.type != :post
	raise RuntimeError, "Something wrong with the posts"
end

if c.type != :poll && d.type != :poll && e.type != :poll
	raise RuntimeError, "Something wrong with the polls"
end

if f.type != :comment && g.type != :comment && h.type != :comment
	raise RuntimeError, "Something wrong with the comments"
end

if i.type != :discussion && j.type != :discussion && k.type != :discussion
	raise RuntimeError, "Something wrong with the disscussions"
end

puts "All test passed!"