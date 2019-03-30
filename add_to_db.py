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

save_record(1)
save_record(12)
save_record(13)


import email, smtplib, ssl

from email import encoders
from email.mime.base import MIMEBase
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

subject = "An email with attachment from Python"
body = "This is an email with attachment sent from Python"
sender_email = "leon.mlodzian@gmail.com"
receiver_email = "safebeat.hackkosice2019@gmail.com"
password = input("Type your password and press enter:")

# Create a multipart message and set headers
message = MIMEMultipart()
message["From"] = sender_email
message["To"] = receiver_email
message["Subject"] = subject
message["Bcc"] = receiver_email  # Recommended for mass emails

# Add body to email
message.attach(MIMEText(body, "plain"))

filename = "records.csv"  # In same directory as script

# Open PDF file in binary mode
with open(filename, "rb") as attachment:
    # Add file as application/octet-stream
    # Email client can usually download this automatically as attachment
    part = MIMEBase("application", "octet-stream")
    part.set_payload(attachment.read())

# Encode file in ASCII characters to send by email
encoders.encode_base64(part)

# Add header as key/value pair to attachment part
part.add_header(
    "Content-Disposition",
    f"attachment; filename= {filename}",
)

# Add attachment to message and convert message to string
message.attach(part)
text = message.as_string()

# Log in to server using secure context and send email
context = ssl.create_default_context()
with smtplib.SMTP_SSL("smtp.gmail.com", 465, context=context) as server:
    server.login(sender_email, password)
    server.sendmail(sender_email, receiver_email, text)

send_mail('leon.mlodzian@gmail.com', 'leon.mlodzian@gmx.de', 'sfgd', 'safgd')
