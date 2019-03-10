import re

NoneStr = 'NA'

class Parser:
    def ParseDate(line):
        search = re.search(r'([A-z ]{,10} (\d\d|\d) \d\d:\d\d:\d\d)', line)
        if (search != None):
             return search.group()
        else: 
            return NoneStr
    
    def ParseSession(line):
        search = re.search(r'session=<(.+)>', line)
        if (search != None):
             return search.group(1)
        else: 
            return NoneStr

    def ParseLogin(line):
        search = re.search(r"[^<>()=,' ]+@[^<>()=,' ]+", line)
        if (search != None):
             return search.group()
        else: 
            return NoneStr

    def ParseCountry(line):
        search = re.search(r'country=(.+)city', line)
        if (search != None):
             return search.group(1)
        else: 
            return NoneStr
        
    def ParseCity(line):
        search = re.search(r'city=(.+)network', line)
        if (search != None):
             return search.group(1)
        else: 
            return NoneStr
        
    def ParseProcess(line):
        search = re.search(r'mail3 post.+: ([a-zA-Z.\-\d ]+)\[|mail3 .+: ([A-Z][a-z]+)\W{2,}', line)
        if (search != None):
             if (search.group(1)==None):
                 return search.group(2).lower()
             else: return search.group(1).lower()
        else: 
            return NoneStr
    
    def ParseApplication(line):
        search = re.search(r'mail3[ ]{1}([^:[]+)', line)
        if (search != None):
             return search.group(1)
        else: 
            return NoneStr
    
    def ParseProtocol(line):
        search = re.search(r'dovecot: ([a-z\d\-*]+)', line)
        if (search != None):
             return search.group(1)
        else: 
            return NoneStr
    
    def ParseIP(line):
        search = re.search(r'whois.+ip=(.+)from', line)
        if (search != None):
             return search.group(1)
        else: 
            return NoneStr
    
    def ParseIPrip(line):
        search = re.search(r'rip=([\d\.]+)', line)
        if (search != None):
             return search.group(1)
        else: 
            return NoneStr
    
    def ParseIPlip(line):
        search = re.search(r'lip=([\d\.]+)', line)
        if (search != None):
             return search.group(1)
        else: 
            return NoneStr

    def ParsePort(line):
            search = re.search(r'\[(\d+)\]', line)
            if (search != None):
                return search.group(1)
            else: 
                return NoneStr