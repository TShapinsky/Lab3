f = open("test.txt", "r")
o = open("testmem.dat", "w")
lines = f.readlines()
for s in lines:
    for i in range(4):
        o.write(s[i*2:i*2+2])
        o.write("\n")

f.close()
o.close
