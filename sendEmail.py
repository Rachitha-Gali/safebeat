import smtplib
server = smtplib.SMTP('smtp.gmail.com', 587)
server.ehlo()
#(250, 'smtp.gmail.com at your service, [88.212.27.114]\nSIZE 35882577\n8BITMIME\nSTARTTLS\nENHANCEDSTATUSCODES\nPIPELINING\nCHUNKING\nSMTPUTF8')
server.starttls()
#(220, '2.0.0 Ready to start TLS')
server.ehlo()
#(250, 'smtp.gmail.com at your service, [88.212.27.114]\nSIZE 35882577\n8BITMIME\nAUTH LOGIN PLAIN XOAUTH2 PLAIN-CLIENTTOKEN OAUTHBEARER XOAUTH\nENHANCEDSTATUSCODES\nPIPELINING\nCHUNKING\nSMTPUTF8')
server.login("safebeat.hackkosice2019@gmail.com","********")
#(235, '2.7.0 Accepted')
msg = "\nHello!" # The /n separates the message from the headers (which we ignore for this example)
server.sendmail("safebeat.hackkosice2019@gmail.com","safebeat.hackkosice2019@gmail.com",msg,"test")
#{}
