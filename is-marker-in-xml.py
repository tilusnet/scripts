#!/usr/bin/python


import  sys
import  os
import  argparse
import  xml.etree.ElementTree as ET


def handleCommandLine():
    parser = argparse.ArgumentParser(description='Tells whether a marker (basically a string sequence) is part of an xml value. If affirmative, prints "yes" on screen.')
    parser.add_argument("xml_file", 
                        help="XML file.")
    parser.add_argument("marker", 
                        help="The marker, e.g. \"[cyc-input]\".")

    return parser.parse_args()  

def main():
    opt = handleCommandLine()

    xmltree = ET.parse(opt.xml_file)
    allelems = xmltree.findall(".//")

    for elem in allelems:
        if str(elem.text).find(opt.marker) != -1:
            # Marker found
            print "yes"
            exit(0)

    print "no"
    exit(0)

if __name__ == "__main__":
    main()
