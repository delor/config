#!/usr/bin/env python
# -*- coding: utf-8 -*-

import urllib2
import optparse
import sys
from re import findall
from time import time, sleep, gmtime
from random import randint

# Initing urllib
urllib2.install_opener(urllib2.build_opener(urllib2.HTTPCookieProcessor()))
urlopen = urllib2.urlopen

support_author_url = "http://rapidshare.com/files/127043295/thanks.zip"

# Some default variables
output_format = ""
custom_output_format = False
quiet_mode = False
buffer_size = 1024*24
loop = False
loop_interval = 30
tries_count = 0
get_url_only = False
check_url_only = False
check_availability_only = False
support_author_mode = False
speed_list_len = 25
wait_for_download_time = 50
ignore_invalid_url_error = False
stdout_output = False
urls = []

def WriteMsg(msg, important=False):
	if (quiet_mode or stdout_output) and not important:
		return

	sys.stdout.write(msg)
	sys.stdout.flush()

def WriteError(msg):
	sys.stderr.write(msg)
	sys.stderr.flush()

def WriteProgressBar(percent):
	max = 40
	value = percent / 100.0 * max
	bar = (int(value) - 1) * '=' + '>'
	bar = '[' + bar + ((max - len(bar)) * ' ') + ']'
	return bar

def GetServerUrl(url):
	handler = urlopen(url)
	data = handler.read()

	if data.find('The file could not be found.  Please check the download link.') > -1:
		raise "IncorrectUrl"
		return

	return findall('<form id="ff" action="(.+)" method="post">', data)[0]

def GetDirectUrl(url):
	handler = urlopen(url, "dl.start=Free")
	data = handler.read()
	if data.find('is already downloading a file') > -1:
		raise "AlreadyDownloading"
		return

	global wait_for_download_time
	wait_for_download_time = int(findall("var c=(\d+)", data)[0])
	return findall('<form name="dlf" action="(.+)" method="post">', data)[0]

def Download(url, out):
	handler = urlopen(url)
	count = 0.0
	size=float(handler.info()['content-length'])
	time_last = time()
	time_start = time()
	speed_list = [0] * speed_list_len

	while True:
		data = handler.read(buffer_size)

		if data == "":
			break

			if count == 0.0 and data.find('is already downloading a file') > -1:
				raise "AlreadyDownloading"
				return

		count += len(data)
		time_now = time()

		if (time_now - time_last) == 0:
			speed_current = speed_list[-1]
		else:
			speed_current = buffer_size / (time_now - time_last)

		speed_avg = 0

		for x in range(len(speed_list) - 1):
			speed_list[x] = speed_list[x + 1]

		speed_list[len(speed_list) - 1] = speed_current

		for x in speed_list:
			speed_avg += x

		speed_avg /= len(speed_list)

		time_last = time_now
		eta = gmtime(((time_now - time_start) / count) * (size - count))

		WriteMsg("\r    %d%%   %.1f/%.1f MB   %d KB/s   ETA: %d:%.2d      " % (round((count/size)*100), (count/(1024**2)), (size/(1024**2)), round(speed_avg/1024), eta[4], eta[5]))

		out.write(data)

	WriteMsg("\n *  Zakończono pobieranie\n")
	out.close()


if __name__ == "__main__":
	try:
		usage = "%prog <rapidshare urls> [options]"
		version = "%prog 0.2.1"
		parser = optparse.OptionParser(usage=usage, version=version)
		parser.add_option("-o", "--output", dest="output", metavar="FILE", help="Zapisz plik do FILE, jeżeli pobierasz wiecej niż jeden plik '%d' oznacza numer aktualnego pliku,'-' oznacza starnadardowe wyjście", default="")
		parser.add_option("-l", "--loop", dest="loop", action="store_true", help="Tryb pętli, próbuje pobrać plik do czasu sukcesu lub wystąpienia krytycznego błędu", default=False)
		parser.add_option("-t", "--tries", dest="tries", metavar="COUNT", help="Jeżeli tryb pętli jest włączony, jest ilość prób jak azostanie wykonana, 0 oznacza nieskończoność", default=0, type="int")
		parser.add_option("-i", "--interval", dest="interval", metavar="SECONDS", help="Jeżeli tryb pętli jest włączony, jest to odstęp czasu między kolejnymi próbami", default=30, type="int")
		parser.add_option("-c", "--check", dest="check", action="store_true", help="Sprawdź czy plik istnieje, nie pobieraj",default=False)
		parser.add_option("-p", "--pretend", dest="pretend", action="store_true", help="Wyswietl bezpośredni link, nie pobieraj", default=False)
		parser.add_option("-T", "--test", dest="test", action="store_true", help="Sprawdź czy istanieje możliwość pobierania dla twojego IP", default=False)
		parser.add_option("-q", "--quiet", dest="quiet", action="store_true", help="Tryb cichy", default=False)
		parser.add_option("-I", "--ignore", dest="ignore", action="store_true", help="Ignoruj błędne linki", default=False)
		parser.add_option("-s", "--support-author", dest="support_author", action="store_true", help="Wspomóż autora skryptu pobierająć jego plik", default=False)
		(options, args) = parser.parse_args()

		if len(options.output) > 0:
			output_format = options.output
			custom_output_format = True
			if output_format is '-':
				stdout_output = True
			elif output_format.find('%d') == -1:
				output_format += '-%d'

		tries_count = options.tries
		loop_interval = options.interval
		loop = options.loop
		quiet_mode = options.quiet
		check_url_only = options.check
		support_author_mode = options.support_author
		get_url_only = options.pretend
		ignore_invalid_url_error = options.ignore
		check_availability_only = options.test

		if check_availability_only:
			support_author_mode = True

		if (len(args) is 0 or args.count('-') > 0) and not support_author_mode:
			# Stdin mode
			for line in sys.stdin:
				urls.append(line.strip())

		elif support_author_mode:
			urls.append(support_author_url)

		else:
			urls = args

		l = []
		for x in urls:
			l.append(x.split(' '))

		urls = l
		del l

		for n in range(len(urls)):
			url = urls[n][0]
			i = 1
			if loop and tries_count == 0:
				i = -1
			elif loop:
				i = tries_count

			if len(urls) > 1:
				WriteMsg("Pobieranie %s (%d/%d)\n" % (url, n + 1, len(urls)))
			else:
				WriteMsg("Pobieranie %s\n" % url)

			while i is not 0:
				try:
					i -= 1

					if loop and tries_count == 0:
						WriteMsg("  Próba %d\n" % abs(i + 1))

					elif loop:
						WriteMsg("  Próba %d/%d\n" % ((tries_count - i), tries_count))

					url = GetServerUrl(url)

					if check_url_only:
						WriteMsg(" *  Link %s jest poprawny\n" % url, True)
						break

					url = GetDirectUrl(url)

					if check_availability_only:
						WriteMsg(" *  Pobieranie jest możliwe\n")
						break

					if get_url_only:
						if quiet_mode:
							WriteMsg(url)
						else:
							WriteMsg(" *  Link bezpośredni: %s\n" % url, True)
						break

					if stdout_output:
						out = sys.stdout
					elif custom_output_format:
						file_name = output_format % n
						out = open(file_name, 'wb')
					else:
						file_name = url[url.rindex('/') + 1:]
						out = open(file_name, 'wb')

					WriteMsg("    Oczekiwanie na pobieranie (%d sekund)\n" % wait_for_download_time)
					sleep(wait_for_download_time)
					Download(url, out)
					break;

				except "IncorrectUrl", info:
					WriteError("    Błędny link - %s\n" % url)

					if not ignore_invalid_url_error:
						sys.exit("    ERROR: Błędny link\n")

				except "AlreadyDownloading":
					WriteMsg("    Slot dla twojego IP jest aktualnie zajęty\n")

					if i == 0 and n + 1 == len(urls):
						sys.exit()
					else:
						sleep(loop_interval)

		sys.exit(0)

	except KeyboardInterrupt:
		sys.exit("\n")

