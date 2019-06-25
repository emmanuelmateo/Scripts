$server = "localhost";
 
# Get all sessions
$sessions = query user /server:$server;
 
# Loop through each session/line returned
foreach ($line in $sessions) { 
 
    $line = -split $line;
 
    # Check for missing SessionName field/column
    if ($line.length -eq 8) {
 
        # Get current session state (column 4)
        $state = $line[3];
 
        # Get Session ID (column 3) and current idle time (column 5)
        $sessionid = $line[2]; 
        $idletime = $line[4];
 
    } else {
 
        # Get current session state (column 3)
        $state = $line[2];
 
        # Get Session ID (column 2) and current idle time (column 4)
        $sessionid = $line[1]; 
        $idletime = $line[3];
    }
 
 
    # If the session state is Disconnected 
    if ($state -eq "Disc") { 
 
 
        # Check if idle for more than 1 day (has a '+') and log off
        if ($idletime -like "*+*") {
 
            # Get the any Notepad processes being run by current Session ID
            $notepadrunning = get-process notepad -computername $server -erroraction 0 | where {$_.sessionid -eq $sessionid};
 
            # If Notepad isn't running, logoff user
            if (-not $notepadrunning ) {
                
                logoff $sessionid /server:$server /v;
 
            }
 
        # Check if idle for more than 1 hour (has a ':') and log off 
        #} elseif ($idletime -like "*:*" -or $idletime -gt 30) {
		} elseif ($idletime -like "2:*") {
 
            # Get the any notepad processes being run by current Session ID
            $notepadrunning = get-process notepad -computername $server -erroraction 0 | where {$_.sessionid -eq $sessionid};
 
            # If Notepad isn't running, logoff user
            if (-not $notepadrunning ) {
                
                logoff $sessionid /server:$server /v;
 
            }
        } 
    }
}
 