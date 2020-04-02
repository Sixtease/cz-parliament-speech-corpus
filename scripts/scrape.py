#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import scrapy

class QuotesSpider(scrapy.Spider):
  name = 'parlament'
  start_urls = ['https://www.psp.cz/eknih/']
  def parse(self, response):

    # crawl home page
    for link in response.css('#main-content a[href*="/eknih/"]'):
      url = link.css('::attr(href)').get()
      yield response.follow(url, self.parse)

    # follow link to audio recordings
    for link in response.xpath('//a[contains(text(), \'zvukové záznamy\')]'):
      url = link.css('::attr(href)').get()
      yield response.follow(url, self.parse_calendar)

  def parse_calendar(self, response):
    for link in response.css('td.session.event a[href]'):
      url = link.css('::attr(href)').get()
      yield response.follow(url, self.parse_reclist)
    for link in response.css('.page-menu.simple a[href]'):
      url = link.css('::attr(href)').get()
      yield response.follow(url, self.parse_calendar)

  def parse_reclist(self, response):
    for tr in response.css('table tr'):
      mp3url = tr.css('a[href$=".mp3"]::attr(href)').get()
      trnurls = tr.css('a[href$=".htm"]::attr(href)').getall()
      if mp3url and len(trnurls) > 0:
        trnurl = trnurls[0]
        yield response.follow(
          trnurl,
          self.parse_transcript,
          cb_kwargs = {
            'mp3url': response.urljoin(mp3url),
            'transhead': [],
            'transtail': [response.urljoin(x) for x in trnurls[1:]],
          },
        )

  def parse_transcript(self, response, mp3url, transhead, transtail):
    steno = response.xpath(''.join([
      '//*[@id="main-content"]',        # #main-content
      '//*[@align="justify"]',          # [align=justify]
      '/descendant-or-self',            # whole subtree
      '::*[not(ancestor-or-self::b)]',  # except <b> and subtree
      '/text()',                        # text content
    ])).getall()
    trans = transhead + steno
    if len(transtail) == 0:
      yield {
        'steno': trans,
        'mp3url': mp3url,
      }
    else:
      nexturl = transtail[0]
      newtail = transtail[1:]
      yield response.follow(
        nexturl,
        self.parse_transcript,
        cb_kwargs = {
          'mp3url': mp3url,
          'transhead': trans,
          'transtail': newtail,
        },
      )
