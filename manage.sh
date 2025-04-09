#!/bin/bash
VARS=./.vars
PLIST_PATH="$HOME/Library/LaunchAgents/com.jacoblehrman.autofiller.plist"
new_filler(){
    launchctl unload "$PLIST_PATH"
    echo "This program will run whenever you boot up your computer for the first time each day, or to an hour set, whichever comes first. Please set the preferred time from 0-23(ex: 17 would be 5:00pm): "
    read TIME
    TIME_INT=$((TIME))
    while [[ $TIME_INT -gt 23 ]] || [[ $TIME_INT -lt 0 ]]; do
        echo "Please pick a number between 0-23:"
        read TIME_INT
    done

    DATE=""
    echo "Would you like to run this program today? (Y/n)"
    read CHOICE
    while [[ $CHOICE != "Y" ]] && [[ $CHOICE != "n" ]]; do
        echo "Please input Y or n"
        read CHOICE
    done
    if [[ $CHOICE == "n" ]]; then 
        DATE=$(date +%m/%d/%Y)
    fi

    echo "Input your full name:"
    read NAME
    echo "Input your school email:"
    read EMAIL
    echo "Which location do you use the most?"
    echo "1. Hawthorn"
    echo "2. East Side Market"
    echo "3. MU Market & Cafe"
    echo "4. West Side Market"
    read CHOICE
    if [[ $CHOICE == "1" ]]; then 
        LOC="Hawthorn"
    fi
    if [[ $CHOICE == "2" ]]; then 
        LOC="East Side Market"
    fi
    if [[ $CHOICE == "3" ]]; then 
        LOC="MU Market & Cafe"
    fi
    if [[ $CHOICE == "4" ]]; then 
        LOC="West Side Market"
    fi
    echo "Would you like to recieve confirmation emails (Y/n)"
    read CONF
    while [[ $CONF != "Y" ]] && [[ $CONF != "n" ]]; do
        echo "Please input Y or n"
        read CONF
    done
    echo -e "DATE:$DATE\nNAME:$NAME\nEMAIL:$EMAIL\nLOC:$LOC\nCONF:$CONF" > "$VARS"
    FILEPATH="$(dirname "$(realpath "$0")")/autoWin.sh"
    cat <<EOF > "$PLIST_PATH"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.jacoblehrman.autofiller</string>

    <key>ProgramArguments</key>
    <array>
        <string>$FILEPATH</string>
    </array>

    <key>RunAtLoad</key>
    <true/>

    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>$TIME</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>

</dict>
</plist>
EOF
    sudo launchctl bootstrap gui/$(id -u) "$PLIST_PATH"
    echo The auto filler has been configured! Please note that if you move the autowin folder, you will need to reconfigure.
}

if [ ! -f "$VARS" ]; then
    new_filler
else 
    echo "You already have an automatic survey filler running. Please type the number corresponding with what you would like to do:"
    echo "1: Configure Filler"
    echo "2: Delete Filler"    
    read CHOICE
    while [[ $CHOICE != "1" ]] && [[ $CHOICE != "2" ]]; do
        echo "Unknown Operation. Please type the number corresponding with what you would like to do:"
        echo "1: Configure Filler"
        echo "2: Delete Filler"
        read CHOICE
    done
    if [[ $CHOICE == "1" ]]; then 
        new_filler
    fi
    if [[ $CHOICE == "2" ]]; then 
        rm ./.vars
        launchctl unload "$PLIST_PATH"
        rm $PLIST_PATH
        echo "Filler deleted"
    fi
fi
