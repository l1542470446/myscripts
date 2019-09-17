#! /usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import threading
import usb.util
import usb.core
from Tkinter import *

class usbHelper(object):
    def __init__(self, vid=0x10d6, pid=0xdd00):
        self.alive = False
        self.handle = None
        self.size = 64
        self.vid = vid
        self.pid = pid

    def start(self):
        '''
        开始，打开usb设备
        '''
        self.dev = usb.core.find(idVendor=self.vid, idProduct=self.pid)
        print("vid:%x pid:%x\n" % (self.vid, self.pid))
        if self.dev != None:
            self.ep_in = self.dev[0][(0,0)][0].bEndpointAddress
            self.ep_out = self.dev[0][(0,0)][1].bEndpointAddress
            self.size = self.dev[0][(0,0)][1].wMaxPacketSize
        self.open()
        self.alive = True

    def stop(self):
        '''
        停止，关闭usb设备，释放接口
        '''
        self.alive = False
        if self.handle:
            self.handle.releaseInterface()

    def open(self):
        '''
        打开usb设备
        '''
        busses = usb.busses()
        for bus in busses:
            devices = bus.devices
            for device in devices:
                print("--%x,%x\n" % (device.idVendor,device.idProduct))
                if device.idVendor == self.vid and device.idProduct == self.pid:
                    self.handle = device.open()
                    # Attempt to remove other drivers using this device.
                    if self.dev.is_kernel_driver_active(0):
                        try:
                            self.handle.detachKernelDriver(0)
                        except Exception as e:
                            self.alive = False
                    try:
                        self.handle.claimInterface(0)
                    except Exception as e:
                        self.alive = False

    def read(self, size=64, timeout=0):
        '''
        读取usb设备发过来的数据
        '''
        if size >= self.size:
            self.size = size

        if self.handle:
            data = self.handle.interruptRead(self.ep_in, self.size, timeout)

        try:
            data_list = data.tolist()
            return data_list
        except:
            return list()

    def write(self, send_list, timeout=1000):
        '''
        发送数据给usb设备
        '''
        if self.handle:
            bytes_num = self.handle.interruptWrite(self.ep_out, send_list, timeout)
            return bytes_num

def win_send_command(entry, text, dev):
    send_data = []
    str_command = entry.get()
    text.tag_configure('in', foreground='blue', font=('微软雅黑', 10))
    text.tag_configure('ou', foreground='black', font=('微软雅黑', 10))
    text.config(state=NORMAL)
    text.insert(END, '\n' + '>>>:' + str_command + '\n', 'in')
    text.config(state=DISABLED)
    str_len = len(str_command)
    i = 0
    while i < 64:
        if i < str_len :
            d = ord(str_command[i])
            #print("---%d\n" % d)
            send_data.append(d)
        else:
            send_data.append(0)
        i = i + 1
    dev.write(send_data)
    while True:
        try:
            mylist = dev.read()
            print(mylist)
            str1 = ''.join([chr(x) for x in mylist])
            text.config(state=NORMAL)
            text.insert(END, '<<<:' + str1 + '\n', 'ou')
            text.config(state=DISABLED)
            print("%s\n" % str1)
            break
        except:
            break

def win_connect_command(but, in_but, dev):
    if but['text'] == '打开':
        try:
            dev.start()
        except Exception as e:
            print("connect error")
        else:
            in_but['state'] = NORMAL
            but['text'] = '关闭'
    else:
        try:
            dev.stop()
        except Exception as e:
            print("connect error")
        else:
            in_but['state'] = DISABLED
            but['text'] = '打开'

if __name__ == '__main__':
    reload(sys)
    sys.setdefaultencoding('utf8')
    # init usb devices
    send_data = []
    dev = usbHelper()

    # create main form
    root = Tk()
    root.geometry('700x700')
    root.resizable(0, 0)
    message_text = Text(state=NORMAL)
    in_entry = Entry(width=70)
    in_button = Button(root, text='发送', width=5, command=lambda:win_send_command(in_entry, message_text, dev))
    connect_button = Button(root, text='打开', width=5, command=lambda:win_connect_command(connect_button, in_button, dev))
    message_text.pack(expand=YES, fill=BOTH)
    in_entry.pack(side='left', fill=Y)
    in_button.pack(side='left', fill=Y)
    in_button['state'] = DISABLED
    connect_button.pack(side='left')

    # main loop
    root.mainloop()
    dev.stop()
