##Alfred to Instapaper

Just a simple Alfred extension that allows you to pass URLs to Instapaper. Uses HTTP Basic Auth and cURL.

---
###Usage

Pretty simple really, just install the extension, then in the options for the extension, replace "username:password" with your Instapaper credentials.

---
###Command

It's basically just a glorified shell-script, I will save you time by pasting it here:

`curl -s --user username:password --data-urlencode "url={query}" https://www.instapaper.com/api/add`