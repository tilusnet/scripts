#!/usr/bin/python
#
# by tilusnet
# mapper.tilusnet.com 
# Feb 2013
#


import sys
import argparse
import textwrap
import shutil
import logging
import itertools
import xml.etree.ElementTree as ET


llevel = logging.INFO



class SVGUtil:

     # Returns True if all values are within eps range from ref
    def areWithinRange(self, values, ref, eps):
        for v in values:
            if abs(v - ref) > eps:
                return False
        return True



class SVGParser:

    def __init__(self, filename, explicit_svgns=False):

        # Reuse logger
        self.logger = logging.getLogger(__name__)

        # Set default SVG namespace key
        self.defns = 'svg' if explicit_svgns else ''

        # Define list of vector shapes in SVG
        # Ref.: http://www.w3.org/TR/SVG/intro.html#TermShape
        self.shapes = ( 'path', 'rect', 'circle', 'ellipse', 'line', 'polyline', 'polygon' )

        # Define and register common namespaces used in SVG 
        self.nspaces = {
            self.defns: 'http://www.w3.org/2000/svg',
            'dc': 'http://purl.org/dc/elements/1.1/',
            'cc': 'http://creativecommons.org/ns#',
            'rdf': 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
            'sodipodi': 'http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd',
            'inkscape': 'http://www.inkscape.org/namespaces/inkscape'
        }
        self._regNameSpaces()

        # Parse input file
        self.tree = ET.parse(filename)


    def _regNameSpaces(self):
        for ns in self.nspaces.items():
            ET.register_namespace(ns[0], ns[1])

    def _scaleHlpr(self, dimvalue, tag):
        try:
            newD = int(dimvalue)
        except TypeError:
            self.logger.exception("Dimension is not an integer.")
            raise
        oldD = self.tree.find("./[@" + tag + "]").get(tag)     # Suggested 'dot notation' used for broken ET v <=1.3
        self.logger.debug("Old " + tag + " = [" + oldD + "]")

        scaleD = round(newD / float(oldD), 3)
        return scaleD

    def _scaleTxt(self, scale):
        if scale < 1:
            return " will be shrinked to {0:.1f}% of the original.".format(scale * 100)
        elif scale > 1:
            return " will be expanded to {0:.1f}% of the original.".format(scale * 100)
        else:
            return " won't be scaled."



    def getroot(self):
        return self.tree

    # Finds all elements. Elements within SVG context should be prefixed with 'svg:'.
    def findall(self, xpath):
        xpathP27 = xpath.replace('svg:', '{0}')
        return self.tree.findall(xpathP27.format('{' + self.nspaces[self.defns] + '}'))

    # Return the flattened, combined list of vector shape elements
    def findallshapes(self):
        allshapes = [self.findall('.//svg:' + s) for s in self.shapes]
        return list(itertools.chain.from_iterable(allshapes))


    def printElems(self):
        for elem in self.tree.getiterator():
            print elem
            # print elem.tag, elem.attrib 

    def write(self, outfile):
        self.tree.write(outfile, encoding="UTF-8")

    # Returns True if any real processing has been done, False otherwise
    def scale(self, w, h):
        sx = self._scaleHlpr(w, 'width')
        if h:
            sy = self._scaleHlpr(h, 'height')
        else:
            sy = sx

        if not SVGUtil().areWithinRange((sx, sy), 1, .001):

            self.logger.info("Width" + self._scaleTxt(sx))
            self.logger.info("Height" + self._scaleTxt(sy))

            # Collect all vector shapes
            vShapes = self.findallshapes()
            print len(vShapes)
            # for vs in vShapes:
            #     print vs.get('id')

            # TODO-OR-NOT-TODO
            

            return True
        else:
            return False






def handleCommandLine(logger):
    parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter,
                                     description=textwrap.dedent('''\
        Rescale an SVG file by altering the vector coordinates of its shape elements.

        These particular SVG shapes might be affected: path, rect, circle, ellipse, line, polyline and polygon.
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
    logger.debug("Input           = [" + opt.input + "]")
    logger.debug("Output          = [" + opt.output + "]")
    logger.debug("Required width  = [" + str(opt.width) + "]")
    if not opt.height:
        sH = "N/A"
    else:
        sH = str(opt.height)
    logger.debug("Required height = [" + sH + "]")

    return opt








def main():

    if sys.hexversion <= 0x020700F0:
        raise NotImplementedError("This program requires Python 2.7+.")
        sys.exit(1)

    # Logging
    logging.basicConfig(format='%(levelname)s: %(message)s')
    logger = logging.getLogger(__name__)
    logger.setLevel(llevel)

    # Parse command line
    opt = handleCommandLine(logger)

    # Process SVG
    svg = SVGParser(opt.input)

    if logger.isEnabledFor(logging.DEBUG):
        svg.printElems()

    reprocessed = svg.scale(opt.width, opt.height)

    if reprocessed:
        svg.write(opt.output)
    else:
        # Copying input to ouput
        shutil.copy2(opt.input, opt.output)
        logger.info('Scale is below minimum threshold. Output is identical to input.')





if __name__ == "__main__":
    main()

