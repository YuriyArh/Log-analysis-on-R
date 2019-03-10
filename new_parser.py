
from Parser import Parser

def main():
    fieldNames = ['Date','Application','Protocol', 'Process', 'Port','Login', 'IP', 'rip', 'lip', 'Country', 'City', 'Session']
   
    fileName = 'maillog.txt'
    with open(fileName, 'r', encoding='utf-8',errors='ignore') as file:
        fileLines = file.readlines()
    
        with open("result.csv", "a", ) as outFile:
            writer = csv.writer(outFile, delimiter=';', quotechar='"', quoting=csv.QUOTE_MINIMAL)
            writer.writerow(fieldNames)
            outFile.close()
        
        for line in fileLines:
            raw = [Parser.ParseDate(line), 
            Parser.ParseApplication(line), 
            Parser.ParseProtocol(line), 
            Parser.ParseProcess(line), 
            Parser.ParsePort(line), 
            Parser.ParseLogin(line),
            Parser.ParseIP(line),
            Parser.ParseIPrip(line),
            Parser.ParseIPlip(line),
            Parser.ParseCountry(line),
            Parser.ParseCity(line), 
            Parser.ParseSession(line)]
            
            with open("result.csv", "a") as outFile:
                writer = csv.writer(outFile, delimiter=';', lineterminator='\n')
                writer.writerow(raw)
                
        outFile.close()
    file.close()        

if __name__ == "__main__":
    main()