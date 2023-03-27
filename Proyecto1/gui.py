import os
from tkinter import *
import PIL.Image as Image
from PIL import ImageTk
import subprocess

popen = subprocess.Popen(("./proy1"), stdout=subprocess.PIPE)
popen.wait()

out = popen.stdout.read()
print(out)

with open('img.txt', 'r') as f:
    encList = [int(float(x)) for x in f.read().split()]

with open('output.txt', 'r') as f:
    outputList = [int(float(x)) for x in f.read().split()]

print(len(encList))

pic1 = Image.new('L', (640,320))
pic1.putdata(encList)
pic1.save("input.png")

pic2 = Image.new('L', (320,320))
pic2.putdata(outputList)
pic2.save("output.png")

win = Tk()
win.geometry("1000x500")

frame1 = Frame(win, width=640, height=320)
frame1.pack(side=LEFT)

img1 =  ImageTk.PhotoImage(Image.open("input.png"))

imgLabel1 = Label(frame1, image = img1)
imgLabel1.pack()

frame2 = Frame(win, width=320, height=320)
frame2.pack(side=RIGHT)

img2 =  ImageTk.PhotoImage(Image.open("output.png"))

imgLabel2 = Label(frame2, image = img2)
imgLabel2.pack()

win.mainloop()
