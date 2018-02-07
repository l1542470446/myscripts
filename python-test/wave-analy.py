#!/usr/bin/env python

import os
import sys
import wave
import numpy as np

if __name__ == '__main__':
    print 'wave file analysis :'
    argc = len(sys.argv)
    if argc < 2:
        print 'usage : %s [dir]' % sys.argv[0]
        exit(1)
    wav_pwd = os.getcwd()
    wav_dir = os.path.join(wav_pwd, sys.argv[1])
    wav_files = []
    ana_list = []
    out_list = []
    out_file = open("out-log.txt", 'w')
    if os.path.exists(wav_dir):
        f_dir = os.listdir(wav_dir)
        for node in f_dir:
            nodepath = os.path.join(wav_dir, node)
            wav_files.append(nodepath)
    for node in wav_files:
        if os.path.isfile(node):
            print node
            try:
                tmp = wave.open(node, "rb")
            except:
                print '%s is not wav file' % node
                continue
            params = tmp.getparams()
            channel, sampwidth, rate, frames = params[:4]
            print 'channel = %d' % channel
            print 'width   = %d' % sampwidth
            print 'rate    = %d' % rate
            print 'frames  = %d' % frames
            str_data = tmp.readframes(frames)
            tmp.close()
            length = len(str_data)
            print length
            #wave_data = np.fromstring(str_data, dtype = np.int8)
            #wave_data.shape = frames, channel*sampwidth
            #wave_data = wave_data.T
            line = frames
            row = channel*sampwidth
            a_line = np.arange(line)
            a_row = np.arange(row)
            same = 0
            print 'line = %d, row = %d' % (line, row)
            for i in a_line:
                ir = i*row
                if str_data[ir+0] == str_data[ir+2]:
                    if str_data[ir+1] == str_data[ir+3]:
                        if str_data[ir+4] == str_data[ir+6]:
                            if str_data[ir+5] == str_data[ir+7]:
                                if str_data[ir+8] == str_data[ir+10]:
                                    if str_data[ir+9] == str_data[ir+11]:
                                        if str_data[ir+12] == str_data[ir+14]:
                                            if str_data[ir+13] == str_data[ir+15]:
                                                same = same + 1
            f_frame = float(line)
            f_same = float(same)
            percent = f_same/f_frame
            print "same percent : %f" % percent
            al = (node.split('/')[-1], percent)
            ana_list.append(al)
    ana_list = sorted(ana_list, key=lambda x : x[1], reverse=True)
    for l in ana_list:
        al_str = "%f, %s\n" % (l[1], l[0])
        print "%s" % al_str
        out_list.append(al_str)
    out_file.writelines(out_list)
    out_file.close()
