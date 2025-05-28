filename = ['out3',
            'out4',
            'out5',
            'out6',
            'out7',
            'out8',
            'out9']

temp = 0.0
i = 0

for filelist in filename:

    i = i + 1
    with open(filelist) as file:

        boxx = 0.0
        boxz = 0.0
        time = 0.0
        ta   = 0.0

        for line in file:
            if (line != '\n'):
                line_sub = line.split()
                if (len(line_sub) > 1):
                    if (line_sub[0] == 'INFO:' and line_sub[1] != 'STEP'):
                        ta = float(line_sub[2])
                        time = ta + temp
                        if (i <= 4):
                            boxx = float(line_sub[18])
                            boxz = float(line_sub[20])
                        else:
                            boxx = float(line_sub[17])
                            boxz = float(line_sub[19])
                        print('%.3f  %.3f  %.3f' % (time, boxx, boxz))
        temp = temp + ta
