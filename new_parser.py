import csv
import time
from Parser import Parser

def main():
    base = {}

    file_name = 'maillog.txt'
    with open(file_name, 'r', encoding='utf-8',errors='ignore') as file:
        file_lines = file.readlines()
        for line in file_lines:
            base.update({'Date' : Parser.ParseDate(line)}) 
            base.update({'Application' : ''}) 
            base.update({'Protocol' : ''})
            base.update({'Port' : ''})
            base.update({'Login' : Parser.ParseLogin(line)}) 
            base.update({'IP' : ''})
            base.update({'rip' : ''})
            base.update({'lip' : ''})
            base.update({'Country' : Parser.ParseCountry(line)})
            base.update({'City' : Parser.ParseCity(line)})
            base.update({'Session' : Parser.ParseSession(line)})
            print(base)  
                    

if __name__ == "__main__":
    main()