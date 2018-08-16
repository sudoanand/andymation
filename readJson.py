import sys, json; 

with open(sys.argv[1]) as f:
    data = json.load(f)


error = False

for x in range(2,len(sys.argv)):
	if sys.argv[x] in data:
		data = data[sys.argv[x]]
	else:
		error = True


if not error:
	print data