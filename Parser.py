import re

class Parser:
    def ParseDate(line):
        search = re.search(r'([A-z ]{,10} (\d\d|\d) \d\d:\d\d:\d\d)', line)
        if (search != None):
             return search.group()
        else: 
            return 'N/A'
    
    def ParseSession(line):
        search = re.search(r'session=<(.+)>', line)
        if (search != None):
             return search.group(1)
        else: 
            return 'N/A'

    def ParseLogin(line):
        #search = re.search(r'sql.(.+@.+),\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}|<(.+@.+)>.', line)
        search = re.search(r"[^<>()=,' ]+@[^<>()=,' ]+", line)
        if (search != None):
             return search.group()
        else: 
            return 'N/A'

    def ParseCountry(line):
        search = re.search(r'country=(.+)city', line)
        if (search != None):
             return search.group(1)
        else: 
            return 'N/A'
        
    def ParseCity(line):
        search = re.search(r'city=(.+)network', line)
        if (search != None):
             return search.group(1)
        else: 
            return 'N/A'
   
    