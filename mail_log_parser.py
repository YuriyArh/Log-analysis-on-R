import csv
import re
import time



def main():

    fieldnames = ["Date", "Application", "Protocol", "Process", "Port", "Login", "IP", "rip", "lip", "Country", "City", "Session"]
    try:
        file_name = input('Введите имя файла для парсинга: ')
        file = open(file_name, 'r', encoding="latin-1")
    except FileNotFoundError:
        print('Файл '+'\"'+file_name+'\"'+ ' не найден!')
        main()
    else:

        line = file.readline()

        with open("result.csv", "a", ) as out_file:
            writer = csv.writer(out_file, delimiter=';', quotechar='"', quoting=csv.QUOTE_MINIMAL)
            writer.writerow(fieldnames)
            out_file.close()

        while line:

            pattern_date = "([A-z ]{,10} (\d\d|\d) \d\d:\d\d:\d\d)"
            date = "2019 "+re.search(pattern_date, line)[0]

            pattern_session = "session=<[A-z0-9+-/]{,20}"
            if re.search(pattern_session, line):
                session = (re.search(pattern_session, line)[0])[9:]
            else:
                session = "NA"


            pattern_login = "[a-z0-9._-]+@mil.ru|[a-z0-9._-]+@email.[a-z]{,5}"
            if re.search(pattern_login, line):
                login = re.search(pattern_login, line)[0]
            else:
                login = "NA"

            pattern_country = "country=[A-z]{,20}\s[A-z]{,20}"
            if re.search(pattern_country, line):
                country = (re.search(pattern_country, line)[0])[8:]
            else:
                country = "NA"

            pattern_city = "city=[A-z]{,20}(\/|\s|.-.)[A-z]{,20}"
            if re.search(pattern_city, line):
                city = (re.search(pattern_city, line)[0])[5:]
            else:
                city = "NA"

            pattern_process = "\w{,6}nne\w{,5}"
            if re.search(pattern_process, line):
                process = re.search(pattern_process, line)[0]
            else:
                process = "NA"

            if ("dovecot" in line):
                pattern_protocol = "pop3|imap"
                if re.search(pattern_protocol, line):
                    protocol = re.search(pattern_protocol, line)[0]
                else:
                    protocol = "auth-worker"
                application = "dovecot"
                pattern_IP_rip = "rip=[0-9{,3}.]{4,14}"
                if re.search(pattern_IP_rip, line):
                    IP_rip = (re.search(pattern_IP_rip, line)[0])[4:-1]
                else:
                    IP_rip = "NA"
                pattern_IP_lip = "lip=[0-9{,3}.]{4,13}"
                if re.search(pattern_IP_lip, line):
                    IP_lip = (re.search(pattern_IP_lip, line)[0])[4:-1]
                else:
                    IP_lip = "NA"
            else:
                IP = "NA"
                IP_lip = "NA"
                IP_rip = "NA"
                protocol = "NA"


            if ("postfix/postscreen" in line):
                pattern_port = "reen\[[0-9]{,5}"
                port = (re.search(pattern_port, line)[0])[5:]
                application = "postfix/postscreen"
            else:
                port = "NA"
                IP = "NA"


            if ("postfix/smtpd" in line):
                application = "postfix/smtpd"
                pattern_port = "smtpd\[[0-9]{,5}"
                port = (re.search(pattern_port, line)[0])[6:]
            else:
                port = "NA"
                IP = "NA"

            if ("whois" in line):
                application = "whois"
                pattern_IP = "ip=[0-9{,3}.]{4,13}"
                IP = (re.search(pattern_IP, line)[0])[3:]

            if ("auth-worker" in line):
                process = "connect"
                pattern_IP_rip = ",[0-9{,3}.]{4,14}"
                IP_rip = (re.search(pattern_IP_rip, line)[0])[1:]
                if ("<" in line):
                    pattern_session = "<[A-z0-9+-/]{,20}"
                    session = (re.search(pattern_session, line)[0])[1:]
                else:
                    session = "NA"
                if ("@" in line):
                    pattern_login = "[a-z0-9._-]+@mil.ru|[a-z0-9._-]+@email.[a-z]{,5}"
                    login = (re.search(pattern_login,line)[0])
                else:
                    login = "NA"

            if ((session != "NA") and (login != "NA") and (process == "NA")): process = "connect"


            data = [date, application, protocol, process, port, login, IP, IP_rip, IP_lip, country, city, session]

            line = file.readline()
            with open("result.csv", "a") as out_file:
                writer = csv.writer(out_file, delimiter=';', lineterminator='\n')
                writer.writerow(data)

        out_file.close()
        file.close()




if __name__ == '__main__':
    start = time.process_time()
    main()
    print("Время работы программы: "+str(time.process_time()-start)+" секунд(ы)")
