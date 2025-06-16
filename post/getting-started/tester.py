import csv, os, platform
import subprocess

def generate_file(template, id, user):
    filename = f'hello_{id}.tex'
    with open(filename, 'w') as latex_file:
        latex = template.replace(r'\VAR{USER}', user)
        latex_file.write(latex)
        print(os.path.abspath(filename))
        print(os.getcwd())
        print(os.system("pdflatex hello_01.tex"))
        os.system("mv hello_01.pdf /home/pyodide/")
        print(os.listdir('/home/pyodide/'))
        print(platform.system().lower())
        #subprocess.Popen(['pdflatex', '-interaction=nonstopmode', latex])

    #subprocess.check_call(['pdflatex', filename])

def create_tex_template():

    with open("template.tex") as template_file:
        latex_code = template_file.read()
    
    return latex_code

def create_tex_file(latex_code, id):

    with open("input.csv") as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        line_count = 0
        for row in csv_reader:
            if line_count == 0:
                print(f'Column names are {", ".join(row)}')
                line_count += 1
            else:
                if row[0] == "0"+str(id):
                    generate_file(latex_code, row[0], row[1])
                    line_count += 1
                else:
                    line_count += 1