
# class InfoExtractor:
#
#     def _download_webpage(self, url_or_request, video_id, note=None, errnote=None, fatal=True, tries=1, timeout=5, encoding=None, data=None, headers={}, query={}):
#         """ Returns the data of the page as a string """
#         success = False
#         try_count = 0
#         while success is False:
#             try:
#                 res = self._download_webpage_handle(url_or_request, video_id, note, errnote, fatal, encoding=encoding, data=data, headers=headers, query=query)
#                 success = True
#             except compat_http_client.IncompleteRead as e:
#                 try_count += 1
#                 if try_count >= tries:
#                     raise e
#                 self._sleep(timeout, video_id)
#         if res is False:
#             return res
#         else:
#             content, _ = res
#             return content
#
# end
