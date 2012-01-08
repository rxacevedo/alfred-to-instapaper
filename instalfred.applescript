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
		get URL of active tab of first window
	end tell
end if

set input to result
set statuscode to do shell script "curl -s --user USERNAME:PASSWORD --data-urlencode url=" & input & " https://www.instapaper.com/api/add"

tell application id "com.Growl.GrowlHelperApp"
	set the allNotificationsList to Â
		{"Success", "Authentication Error", "Other Error"}
	
	set the enabledNotificationsList to Â
		{"Success", "Authentication Error", "Other Error"}
	
	register as application Â
		"Instapaper" all notifications allNotificationsList Â
		default notifications enabledNotificationsList Â
		icon of application "Alfred"
	
	if statuscode = "201" then
		notify with name Â
			"Success" title Â
			"Instapaper" description Â
			"The article was sent to Instapaper successfully." application name "Instapaper"
		
	else if statuscode = "400" then
		notify with name Â
			"Other Error" title Â
			"Instapaper " description Â
			"Error: bad request." application name "Instapaper"
		
	else if statuscode = "403" then
		notify with name Â
			"Authentication Error" title Â
			"Instapaper " description Â
			"Error: authenticaion failed." application name "Instapaper"
		
	else
		notify with name Â
			"Other Error" title Â
			"Instapaper " description Â
			"The article could not be saved." application name "Instapaper"
	end if
end tell