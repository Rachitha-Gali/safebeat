import os
import csv
import matplotlib.pyplot as plt
import time

def save_record(value):
    if 'records.csv' not in [f for f in os.listdir('.') if os.path.isfile(f)]:
        w = csv.writer(open('records.csv', 'w'))
        w.writerow(['time', 'value'])
    else:
        w = csv.writer(open('records.csv', 'a'))
    w.writerow([time.time(), value])

def save_record_from_file(file):
    save_record(int(file.read()))

def plot_data():
    x = []
    y = []
    with open('records.csv', 'r') as csvfile:
        for row in csv.reader(csvfile):
            x += [row[0]]
            y += [row[1]]
    for i in range(1,len(x)):
        x[i] = float(x[i])
        y[i] = float(y[i])
    print(x)
    print(y)
    plt.plot(x[1:], y[1:])
    plt.show()

plot_data()
