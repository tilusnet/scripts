#!/usr/bin/python
#
# by tilusnet
# mapper.tilusnet.com 
# Feb 2013
#


import sys
import argparse
import textwrap
import logging
import xml.etree.ElementTree as ET





def handleCommandLine():
    parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter,
                                     description=textwrap.dedent('''\
        Rescale an SVG file by altering the vector coordinates of its shape elements.

        These particular SVG shapes might be affected: path, rect, cicrle, ellipse, line, polyline and polygon.
        [Source: http://www.w3.org/TR/SVG/intro.html#TermShape]


        '''))
    parser = argparse.ArgumentParser(description=" \
                                                  ")
    parser.add_argument("input",
                        help="SVG file to process")
    parser.add_argument("output",
                        help="Destination SVG file")
    parser.add_argument("width", type=int,
                        help="New width")
    parser.add_argument("height", nargs='?', type=int, default=None,
                        help="New height. If omitted scaling is proportional.")

    opt = parser.parse_args()
    logging.debug("Input           = [" + opt.input + "]")
    logging.debug("Output          = [" + opt.output + "]")
    logging.debug("Required width  = [" + str(opt.width) + "]")
    if not opt.height:
        sH = "N/A"
    else:
        sH = str(opt.height)
    logging.debug("Required height = [" + sH + "]")

    return opt

def regnamespaces(nspaces):
    for ns in nspaces.items():
        ET.register_namespace(ns[0], ns[1])


def printXmlTree(tree):
    for elem in tree.getiterator():
        print elem
        # print elem.tag, elem.attrib    


# Returns True if all values are within eps range from ref
def areWithinRange(values, ref, eps):
    for v in values:
        if abs(v - ref) > eps:
            return False
    return True


def calcWidthHeightScale(xtree, opt):
    sx = sy = 1

    xOldW = xtree.find("./[@width]")  # Suggested syntax for broken ET v <=1.3
    xOldH = xtree.find("./[@height]") # Suggested syntax for broken ET v <=1.3
    oldW = xOldW.get('width')
    oldH = xOldH.get('height')
    logging.debug("OldW = [" + oldW + "]")
    logging.debug("OldH = [" + oldH + "]")

    sx = round(float(opt.width) / float(oldW), 3)
    if opt.height:
        sy = round(float(opt.height) / float(oldH), 3)
    else:
        sy = sx
    
    logging.info("ScaleX = [" + str(sx) + "]")
    logging.info("ScaleY = [" + str(sy) + "]")

    return sx, sy




def main():

    if sys.hexversion <= 0x020700F0:
        raise NotImplementedError("This program requires Python 2.7+.")
        sys.exit(1)

    nspaces = {
                  'dc': 'http://purl.org/dc/elements/1.1/',
                  'cc': 'http://creativecommons.org/ns#',
                  'rdf': 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
                  '': 'http://www.w3.org/2000/svg',
                  'sodipodi': 'http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd',
                  'inkscape': 'http://www.inkscape.org/namespaces/inkscape'
              }
    defns = '{' + nspaces[''] + '}'

    # Parse command line
    opt = handleCommandLine()

    # Logging
    logging.basicConfig(format='%(levelname)s: %(message)s')
    logger = logging.getLogger(__name__)
    logger.setLevel(logging.DEBUG)

    # Process SVG
    regnamespaces(nspaces)
    xtree = ET.parse(opt.input)
    print xtree

    if logger.isEnabledFor(logging.DEBUG):
        printXmlTree(xtree)

    # sx, sy = calcWidthHeightScale(xtree, opt)

    # if not areWithinRange((sx, sy), 1, .001):
    #     print "do the work"

    # Collect all vector shapes
    vShapes = xtree.findall('./{0}metadata'.format(defns))
    # vShapes = xtree.findtext("path", "hubba")
    print len(vShapes)
    for vs in vShapes:
        print vs.get('id')


    # xtree.write(opt.output, encoding="UTF-8", xml_declaration=True)
    xtree.write(opt.output, encoding="UTF-8")



    # Determine factor; we'll use width only 
    # Python 2.6.6 doesn't understand XPath with conditions unfortunately 
    # ghurl = xmltree.find("scm[@class='hudson.plugins.git.GitSCM']/userRemoteConfigs/hudson.plugins.git.UserRemoteConfig/url")
    # ghurl = xmltree.find("scm/userRemoteConfigs/hudson.plugins.git.UserRemoteConfig/url")




if __name__ == "__main__":
    main()

