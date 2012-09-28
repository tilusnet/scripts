#!/usr/bin/python

import argparse

class CommandLineError(Exception):

	def __init__(self,errno,errmsg):
		self.args = (errno,errmsg)
		self.errno = errno
		self.errmsg = errmsg

def main():
	parser = argparse.ArgumentParser(description='Converts a v4 IP address into a 32-bit  integer.')
	parser.add_argument('IPv4', help='the input IPv4 address, i.e. 90.120.2.240')
	
	# Read args in
	args = parser.parse_args()
	ipnums = args.IPv4.split('.')
	if len(ipnums) is not 4:
		raise CommandLineError(2, 'Invalid IP (v4) address. Use x.y.z.w')

	retval = 0
	for i in range(0,4):
		ipnum = int(ipnums[3-i])
		if ipnum < 0 or ipnum > 255:
			raise CommandLineError(3, 'IP component ' + ipnums[3-i] + ' out of range (0..255)')
		retval += (2**(8*i)) * ipnum

	print retval

if __name__ == "__main__":
	main()