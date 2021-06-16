#!/usr/bin/env python3

import sys
import json

if len(sys.argv) != 4 and len(sys.argv) != 3:
    print("Usage:", sys.argv[0], "SOURCE1 SOURCE2 DESTINATION")
    print("Usage:", sys.argv[0], "SOURCE1 SOURCE2 (writes to ./compile_commands.json)")
    exit(1)

destfile = ""
if len(sys.argv) == 3:
    destfile = "./compile_commands.json"
else:
    destfile = sys.argv[3]

data = list()
with open(sys.argv[1]) as source1:
    data = json.load(source1)

with open(sys.argv[2]) as source2:
    data.extend(json.load(source2))

with open(destfile, 'w') as outfile:
    json.dump(data, outfile, indent=0)
