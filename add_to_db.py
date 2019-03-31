import os
import csv
import matplotlib.pyplot as plt
import time
import matlab.engine
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email import encoders

def notify_doctor():
    # Python code to illustrate Sending mail with attachments
    # from your Gmail account

    # libraries to be imported

    fromaddr = "safebeat.hackkosice2019@gmail.com"
    toaddr = "safebeat.hackkosice2019@gmail.com"

    # instance of MIMEMultipart
    msg = MIMEMultipart()

    # storing the senders email address
    msg['From'] = fromaddr

    # storing the receivers email address
    msg['To'] = toaddr

    # storing the subject
    msg['Subject'] = "Subject of the Mail"

    # string to store the body of the mail
    body = "Body_of_the_mail"

    # attach the body with the msg instance
    msg.attach(MIMEText(body, 'plain'))

    # open the file to be sent
    filename = "chart.png"
    attachment = open("chart.png", "rb")

    # instance of MIMEBase and named as p
    p = MIMEBase('application', 'octet-stream')

    # To change the payload into encoded form
    p.set_payload((attachment).read())

    # encode into base64
    encoders.encode_base64(p)

    p.add_header('Content-Disposition', "attachment; filename= %s" % filename)

    # attach the instance 'p' to instance 'msg'
    msg.attach(p)

    # creates SMTP session
    s = smtplib.SMTP('smtp.gmail.com', 587)

    # start TLS for security
    s.starttls()

    # Authentication
    s.login(fromaddr, "Asdf!234")

    # Converts the Multipart msg into a string
    text = msg.as_string()

    # sending the mail
    s.sendmail(fromaddr, toaddr, text)

    # terminating the session
    s.quit()

def new_record():
    eng = matlab.engine.start_matlab()
    eng.heartRate_monitor(nargout=0)
    eng.quit()
    save_record_from_file('value.txt')

def check_current_heart_rate(value):
    if value > 100 or value < 90:
        plot_data()
        notify_doctor()

def save_record(value):
    if 'records.csv' not in [f for f in os.listdir('.') if os.path.isfile(f)]:
        w = csv.writer(open('records.csv', 'w'))
        w.writerow(['time', 'value'])
    else:
        w = csv.writer(open('records.csv', 'a'))
    w.writerow([time.time(), value])
    check_current_heart_rate(value)

def save_record_from_file(file):
    with open(file, 'r') as f:
        save_record(int(f.read()))

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
    plt.plot(x[1:], y[1:])
    plt.savefig('chart.png')
