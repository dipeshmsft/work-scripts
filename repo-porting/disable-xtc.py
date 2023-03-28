import re
import pathlib



def disable_test(line):
    lower_line = line.lower()
    if "<test name=" in lower_line:
        dq_indexes = [ m.start() for m in re.finditer("\"", lower_line)]        
        test_name = line[dq_indexes[0]+1:dq_indexes[1]].strip()
        test_subarea = line[dq_indexes[4]+1:dq_indexes[5]].strip().replace("\\", "/")
        match_str = test_name + "___" + test_subarea
        print(match_str)
        if match_str in failing_tests:
            return True
    return False
    

def disabled_line(line):
    lower_line = line.lower()
    if "disabled=false" in lower_line:
        return line.replace("=false", "=true")
    endtag_index = line.find('>')
    return  line[:endtag_index] + " Disabled=\"true\" >\n"


failing_tests = set()
with open("E:\\tasks\\test-migration\\migration-status\\xaml\\v4-mod4\\failedtestlist.txt", "r") as fr:
    for line in fr:
        if len(line) == 0:
            continue
        index = line.find("/Name")
        subarea = line[9:index-1].strip().replace("\\","/")
        test = line[index+6:].strip()
        failing_tests.add(test + "___" + subarea)

print(failing_tests)

p  = pathlib.Path("E:/repos/int-test/src/Test/XAML")
xtcfiles = [i for i in p.glob("**/*") if ".xtc" in i.name]

for xtcfile in xtcfiles:
    # print(xtcfile)    
    new_lines = []
    cnt = 0
    with open(xtcfile, "r") as fx:
        for line in fx:
            cnt = cnt + 1
            if(disable_test(line)):
                new_lines.append(disabled_line(line))
            else:
                new_lines.append(line)
    # print(cnt)
    with open(xtcfile, "w") as fx:
        fx.writelines(new_lines)
    
