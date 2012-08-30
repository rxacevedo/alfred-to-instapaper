tell application "System Events"
	set front_app to name of first application process whose frontmost is true
end tell

tell application "System Events"	
	if front_app = "Safari" then
		tell application "Safari"
			get URL of front document
		end tell
	else
		tell application "Growl"
			notify with name �
				"Other Error" title �
				"Instapaper " description �
				"I'm not sure what you want me to do�" application name "Instapaper"
		end tell
	end if
end tell

set input to result
set statuscode to do shell script "curl -s --user USERNAME:PASSWORD --data-urlencode url=" & input & " https://www.instapaper.com/api/add"

tell application id "com.Growl.GrowlHelperApp"
	set the allNotificationsList to �
		{"Success", "Authentication Error", "Other Error"}
	
	set the enabledNotificationsList to �
		{"Success", "Authentication Error", "Other Error"}
	
	register as application �
		"Instapaper" all notifications allNotificationsList �
		default notifications enabledNotificationsList �
		icon of application "Alfred"
	
	if statuscode = "201" then
		notify with name �
			"Success" title �
			"Instapaper" description �
			"The article was sent to Instapaper successfully." application name "Instapaper"
		
	else if statuscode = "400" then
		notify with name �
			"Other Error" title �
			"Instapaper " description �
			"Error: bad request." application name "Instapaper"
		
	else if statuscode = "403" then
		notify with name �
			"Authentication Error" title �
			"Instapaper " description �
			"Error: authenticaion failed." application name "Instapaper"
		
	else
		notify with name �
			"Other Error" title �
			"Instapaper " description �
			"The article could not be saved." application name "Instapaper"
	end if
end tell