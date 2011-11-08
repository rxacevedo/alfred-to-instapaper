tell application "System Events"
	set safariCount to count (every process whose name is "Safari")
	set chromeCount to count (every process whose name is "Google Chrome")
end tell
	
if safariCount > 0 then
	tell application "Safari"
		get URL of front document
	end tell

else if chromeCount > 0 then
		tell application "Google Chrome"
			get URL of active tab of window 1
		end tell
end if

set input to result
set statuscode to do shell script "curl -s --user username:password --data-urlencode url=" & input & " https://www.instapaper.com/api/add"

tell application "Growl"
	set the allNotificationsList to ¬	
		{"Success", "Authentication Error", "Other Error"}
	
	set the enabledNotificationsList to ¬
		{"Success", "Authentication Error", "Other Error"}
	
	register as application ¬
		"Instapaper" all notifications allNotificationsList ¬
		default notifications enabledNotificationsList ¬
		icon of application "Alfred"
	
	if statuscode = "201" then
		notify with name ¬
			"Success" title ¬
			"Instapaper" description ¬
			"The article was sent to Instapaper successfully." application name "Instapaper"
		
	else if statuscode = "400" then
		notify with name ¬
			"Other Error" title ¬
			"Instapaper " description ¬
			"Error: bad request." application name "Instapaper"
		
	else if statuscode = "403" then
		notify with name ¬
			"Authentication Error" title ¬
			"Instapaper " description ¬
			"Error: authenticaion failed." application name "Instapaper"
		
	else
		notify with name ¬
			"Other Error" title ¬
			"Instapaper " description ¬
			"The article could not be saved." application name "Instapaper"
	end if
end tell