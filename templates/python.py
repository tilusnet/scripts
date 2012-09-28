#!/usr/bin/python

import argparse

class CommandLineError(Exception):

	def __init__(self,errno,errmsg):
		self.args = (errno,errmsg)
		self.errno = errno
		self.errmsg = errmsg


def main():
	parser = argparse.ArgumentParser(description='I do nothin.')
	parser.parse_args()

if __name__ == "__main__":
	main()