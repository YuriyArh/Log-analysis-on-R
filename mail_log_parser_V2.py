import csv
import re
from tqdm import tqdm


NoneStr = "NA"

def main():
    # Зададим имена столбцов
    fieldnames = ["Date", "Application", "Protocol", "Process", "Process condition", "Port", "Login", "IP", "rip", "lip", "Country", "City", "Session"]
    try:
        file_name = input('Введите имя файла для парсинга: ')
        file = open(file_name, 'r', encoding="latin-1")
    except FileNotFoundError:
        print('Файл '+'\"'+file_name+'\"'+ ' не найден!')
        main()
    else:
        # Прочитаем первую строку из log-файла
        line = file.readline()
        # Запишем имена столбцов в файл csv
        file_output = input('Введите название файла для сохранения (без расширения): ') + '.csv'
        with open(file_output, "a", ) as out_file:
            writer = csv.writer(out_file, delimiter=';', quotechar='"', quoting=csv.QUOTE_MINIMAL)
            writer.writerow(fieldnames)
            out_file.close()
        print("Идёт подсчёт количества строк...")
        strings = sum(1 for l in open(file_name,'r', encoding="latin-1"))
        #Пока файл не закончится будем читать из него строки
        for i in tqdm(range(strings)):
            # Зададим шаблон регулярного выражения для даты и найдём её
            pattern_date = "([A-z ]{,10} (\d\d|\d) \d\d:\d\d:\d\d)"
            if ("Dec" in re.search(pattern_date, line)[0]):
                Year = "2018 "
                date = Year+re.search(pattern_date, line)[0]
            else:
                Year = "2019 "
                date = Year+re.search(pattern_date, line)[0]
            # Зададим шаблон регулярного выражения для сессии в обычной строке и найдём её
            pattern_session = "session=<[A-z0-9+-/]{,20}"
            if re.search(pattern_session, line):
                session = (re.search(pattern_session, line)[0])[9:]
            else:
                session = NoneStr

            # Зададим шаблон регулярного выражения для имени почтового ящика в обычной строке и найдём его
            pattern_login = "[a-z0-9._-]+@mil.ru|[a-z0-9._-]+@[a-z].[a-z]{,5}"
            if re.search(pattern_login, line):
                login = re.search(pattern_login, line)[0]
            else:
                login = NoneStr
            # Зададим шаблон регулярного выражения для определения государственной принадлежности и найдём её
            pattern_country = "country=[A-z]{,20}\s[A-z]{,20}"
            if re.search(pattern_country, line):
                country = (re.search(pattern_country, line)[0])[8:]
            else:
                country = NoneStr
            # Зададим шаблон регулярного выражения для определения города и найдём его
            pattern_city = "city=[A-z]{,20}(\/|\s|.-.)[A-z]{,20}"
            if re.search(pattern_city, line):
                city = (re.search(pattern_city, line)[0])[5:]
            else:
                city = NoneStr
            # Зададим шаблон регулярного выражения для определения процесса подключения/отключения к/от сервера
            pattern_process = "\w{,6}nne\w{,5}"
            if re.search(pattern_process, line):
                process = re.search(pattern_process, line)[0]
            else:
                process = NoneStr

            # ============by 3ayazaya====================
            # Определим состояние этого процесса
            search = re.search(r'mail3 post.+: ([a-zA-Z.\-\d ]+)\[|mail3 .+: ([A-Z][a-z]+)\W{2,}', line)
            if (search != None):
                if (search.group(1) == None):
                    process_condition = search.group(2).lower()
                else:
                    process_condition = search.group(1).lower()
            else:
                process_condition = NoneStr
            #============by 3ayazaya====================

            # Зададим шаблон регулярного выражения для определения протокола, если в строке есть ключевое слово "dovecot"
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
                    IP_rip = NoneStr
                pattern_IP_lip = "lip=[0-9{,3}.]{4,13}"
                if re.search(pattern_IP_lip, line):
                    IP_lip = (re.search(pattern_IP_lip, line)[0])[4:-1]
                else:
                    IP_lip = NoneStr
            else:
                IP = NoneStr
                IP_lip = NoneStr
                IP_rip = NoneStr
                protocol = NoneStr


            if ("postfix/postscreen" in line):
                pattern_port = "reen\[[0-9]{,5}"
                port = (re.search(pattern_port, line)[0])[5:]
                application = "postfix/postscreen"
            else:
                port = NoneStr
                IP = NoneStr


            if ("postfix/smtpd" in line):
                application = "postfix/smtpd"
                pattern_port = "smtpd\[[0-9]{,5}"
                port = (re.search(pattern_port, line)[0])[6:]
            else:
                port = NoneStr
                IP = NoneStr

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
                    session = NoneStr
                if ("sql" in line):
                    pattern_login = "sql\(([A-z0-9\._-]+@mil.ru){,19}"
                    login = (re.search(pattern_login, line)[0])[4:]
                else:
                    if ("@" in line):
                        pattern_login = "[a-z0-9._-]+@mil.ru|[a-z0-9._-]+@[a-z]{,8}.[a-z]{,5}"
                        login = (re.search(pattern_login,line)[0])
                    else:
                        login = NoneStr


            if ((session != NoneStr) and (login != NoneStr) and (process == NoneStr)): process = "connect"


            data = [date, application, protocol, process, process_condition, port, login, IP, IP_rip, IP_lip, country, city, session]

            line = file.readline()
            with open(file_output, "a") as out_file:
                writer = csv.writer(out_file, delimiter=';', lineterminator='\n')
                writer.writerow(data)

        out_file.close()
        file.close()




if __name__ == '__main__':
    main()

