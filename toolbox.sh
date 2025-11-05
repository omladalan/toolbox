

#!/bin/bash


#LEIA COM ATENCAO O ARQUIVO LICENSE
#NAO TEM GARANTIA, USOU POR QUE QUIS

#PROGRAMADO ORIENTADO A GAMBIARRA

# Function to display the main menu
show_main_menu() {
    MAINMENU=$(whiptail --title "0ml4d's t00lb0x - MAIN MENU" --menu --fb "Choose an option:" 15 60 4 \
    "1" "Services" \
    "2" "Firewall" \
    "3" "FreshOS" \
    "4" "Exit" 3>&1 1>&2 2>&3)

    # Handle menu selections
    case $MAINMENU in
        1) show_servicemanager;;
        2) echo "You chose Option 2";;
        3) show_submenu;;  # Call submenu function
        4) exit;;
        *) echo "Invalid option";;
    esac
}

show_servicemanager() {

	ARRAY_SERVICES=("DOCKER" "VBOX")

	# Socket name
	DOCKER_SERVICE="docker.service"

	DOCKER_STATUS=$(sudo systemctl is-active "$DOCKER_SERVICE")

	# Check the socket status and set a variable accordingly
	if [ "$DOCKER_STATUS" == "active" ]; then
	    DOCKER_CHECK="ON"
	else
	    DOCKER_CHECK="OFF"
	fi

	VBOX_SERVICE="vboxautostart-service.service"

	VBOX_STATUS=$(sudo systemctl is-active "$VBOX_SERVICE")

	# Check the socket status and set a variable accordingly
	if [ "$VBOX_STATUS" == "active" ]; then
	    VBOX_CHECK="ON"
	else
	    VBOX_CHECK="OFF"
	fi

	# Get the status of the socket

	services=$(whiptail --title "Service Manager" --checklist --fb \
	"Check to activate" 15 50 5 \
	"Docker" "Docker Socket Service Containerd" $DOCKER_CHECK \
	"Vbox" "Virtual Box Drivers" $VBOX_CHECK 3>&1 1>&2 2>&3)
	status=$?
	


	verify_on() {
	  echo "$services" | grep -q "\"$1\""
	  if [ $? -eq 0 ]; then	    
	    enable $1
	  else
	    disable $1
	  fi
	}

	enable(){
		if [ $1 == "Docker" ]; then
			systemctl start docker.socket
			systemctl start docker.service
		elif [ $1 == "Vbox" ]; then
			systemctl start vboxautostart-service.service
			systemctl start vboxballoonctrl-service.service
			systemctl start vboxdrv.service
			systemctl start vboxweb-service.service
			rmmod kvm_intel
		fi
	}

	disable(){

		if [ $1 == "Docker" ]; then
			systemctl stop docker.socket
            systemctl stop docker.service
        	systemctl stop containerd.service
		elif [ $1 == "Vbox" ]; then
			systemctl stop vboxautostart-service.service
			systemctl stop vboxballoonctrl-service.service
			systemctl stop vboxdrv.service
			systemctl stop vboxweb-service.service
		fi
	}

	verify_on "Docker"
	verify_on "Vbox"
	

	
}


# Function to display the submenu
show_submenu() {
    SUBMENU=$(whiptail --title "Service Manager" --menu "Choose a sub-option:" 15 60 3 \
    "1" "Sub Option 1" \
    "2" "Sub Option 2" \
    "3" "Back to Main Menu" 3>&1 1>&2 2>&3)

    case $SUBMENU in
        1) echo "You chose Sub Option 1";;
        2) echo "You chose Sub Option 2";;
        3) show_main_menu;;  # Return to main menu
        *) echo "Invalid option";;
    esac
}

# Main loop to ensure the program runs
while true; do
    show_main_menu
done