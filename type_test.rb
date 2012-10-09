require 'hn2json'
=begin

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

=end



dis1 = HN2JSON.find 4601640 	# new, no comments
dis2 = HN2JSON.find	4618637		# new, comments
dis3 = HN2JSON.find	142923		# old, no comments
dis4 = HN2JSON.find	139791		# old, comments
raise RuntimeError, "Something wrong with the disscussions" unless dis1.type == :discussion && dis2.type == :discussion && dis3.type == :discussion && dis4.type == :discussion
sleep(120)

#poll1 = HN2JSON.find			# new, no comments
#poll2 = HN2JSON.find			# new, comments
poll3 = HN2JSON.find 1036120	# old, no comments
poll4 = HN2JSON.find 163618		# old, comments
raise RuntimeError, "Something wrong with the polls" unless poll3.type == :poll && poll4.type == :poll
sleep(120)

post1 = HN2JSON.find 4626533	# new, no comments
post2 = HN2JSON.find 4624761 	# new, comments
post3 = HN2JSON.find 2310005	# old, no comments
post4 = HN2JSON.find 41051 		# old, comments
raise RuntimeError, "Something wrong with the posts" unless post1.type == :post && post2.type == :post && post3.type == :post && post4.type == :post
sleep(120)

com1 = HN2JSON.find 4626015 	# new, no comments
com2 = HN2JSON.find	4627318		# new, comments
com3 = HN2JSON.find	139798		# old, no comments
com4 = HN2JSON.find	3746863 	# old, comments
raise RuntimeError, "Something wrong with the comments" unless com1.type == :comment && com2.type == :comment && com3.type == :comment && com4.type == :comment

sleep(20)

special = HN2JSON.find 4626238 	# new, special
raise RuntimeError, "Something wrong with the special" unless special.type == :special


puts "All test passed!"