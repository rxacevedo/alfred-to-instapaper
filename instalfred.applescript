tell application "System Events"
	set front_app to name of first application process whose frontmost is true
end tell

tell application "System Events"
	if front_app = "Safari" then
		tell application "Safari"
			get URL of front document
		end tell
		
	else if front_app = "Google Chrome" then
		tell application "Google Chrome"
			get URL of active tab of first window
		end tell
	else
		tell application "Growl"
			notify with name Â
				"Other Error" title Â
				"Instapaper " description Â
				"I'm not sure what you want me to doÉ" application name "Instapaper"
		end tell
	end if
end tell

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