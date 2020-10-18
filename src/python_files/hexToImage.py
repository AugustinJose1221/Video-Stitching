import numpy
import cv2
File =  open("../../res/hex/Hex.txt", 'r+')
content = File.read()
val = 0
l = []
for i in content.split("\n"):
    '''
    if i=='':
        continue
    k = i.split("x")[1]
    if len(k)==1:
        k = "0" + k
    '''
    val = int(i, 16)
    l.append(val)
#print(len(content.split("\n")))
bgrImage = numpy.array(l).reshape(64, 64)
cv2.imwrite('../../res/img/Foo.jpg', bgrImage)
