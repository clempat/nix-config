# WiFi Hotspot configuration - Manual activation required
{ pkgs, config, lib, ... }: {

  # Install hostapd and dnsmasq packages but don't auto-enable services
  environment.systemPackages = with pkgs; [ hostapd dnsmasq ];

  # Enable IP forwarding for when hotspot is manually activated
  boot.kernel.sysctl = { "net.ipv4.conf.all.forwarding" = true; };

  # Create hostapd config file
  environment.etc."hostapd/hostapd.conf".text = ''
    interface=wlan0
    driver=nl80211
    ssid=Jellyfin-Travel
    hw_mode=g
    channel=7
    wmm_enabled=1
    macaddr_acl=0
    auth_algs=1
    ignore_broadcast_ssid=0
    wpa=2
    wpa_passphrase=familytrip2024
    wpa_key_mgmt=WPA-PSK
    rsn_pairwise=CCMP
  '';

  # Create dnsmasq config for hotspot
  environment.etc."dnsmasq-hotspot.conf".text = ''
    interface=wlan0
    bind-interfaces
    dhcp-range=192.168.42.2,192.168.42.20,255.255.255.0,24h
    dhcp-option=3,192.168.42.1
    dhcp-option=6,8.8.8.8,8.8.4.4
    server=8.8.8.8
    log-queries
    log-dhcp
    listen-address=192.168.42.1
    port=5353
  '';

  # Create KDE desktop entry for hotspot control
  environment.etc."xdg/autostart/jellyfin-hotspot.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Jellyfin Hotspot Control
    Comment=Start/Stop WiFi hotspot for Jellyfin media sharing
    Exec=kdialog --title "Jellyfin Hotspot" --radiolist "Hotspot Control:" 1 "Start Hotspot" off 2 "Stop Hotspot" off 3 "Check Status" on --geometry 400x200
    Icon=network-wireless
    Categories=Network;System;
    NoDisplay=true
  '';

  # Create GUI helper script  
  environment.etc."hotspot-gui.sh" = {
    text = ''
      #!/run/current-system/sw/bin/bash

      ACTION=$(kdialog --title "Jellyfin Hotspot Control" --radiolist "Choose action:" \
        "start" "Start Hotspot (disconnect WiFi)" off \
        "stop" "Stop Hotspot (reconnect WiFi)" off \
        "status" "Check Status" on)
        
      if [ $? -eq 0 ]; then
        case "$ACTION" in
          start)
            if kdialog --title "Start Hotspot" --yesno "This will disconnect from current WiFi and start hotspot.\n\nSSID: Jellyfin-Travel\nPassword: familytrip2024\n\nContinue?"; then
              RESULT=$(/etc/hotspot-control.sh start 2>&1)
              kdialog --title "Hotspot Started" --msgbox "$RESULT"
            fi
            ;;
          stop)
            if kdialog --title "Stop Hotspot" --yesno "Stop the hotspot and reconnect to WiFi?"; then
              RESULT=$(/etc/hotspot-control.sh stop 2>&1)
              kdialog --title "Hotspot Stopped" --msgbox "$RESULT"
            fi
            ;;
          status)
            RESULT=$(/etc/hotspot-control.sh status 2>&1)
            kdialog --title "Hotspot Status" --msgbox "$RESULT"
            ;;
        esac
      fi
    '';
    mode = "0755";
  };

  # Create helper script to start/stop hotspot
  environment.etc."hotspot-control.sh" = {
    text = ''
       #!/run/current-system/sw/bin/bash

      case "$1" in
         start)
           echo "Starting WiFi Hotspot..."
           
           # Create NetworkManager hotspot profile
           nmcli connection add type wifi ifname wlan0 con-name Jellyfin-Hotspot autoconnect yes wifi.mode ap wifi.ssid Jellyfin-Travel ipv4.method shared ipv4.addresses 192.168.42.1/24 wifi-sec.key-mgmt wpa-psk wifi-sec.psk familytrip2024
           
           # Activate the hotspot
           nmcli connection up Jellyfin-Hotspot
           
           echo "Hotspot started! SSID: Jellyfin-Travel, Password: familytrip2024"
           echo "Jellyfin accessible at: http://192.168.42.1:8096"
          ;;
          
         stop)
           echo "Stopping WiFi Hotspot..."
           
           # Deactivate and remove hotspot connection
           nmcli connection down Jellyfin-Hotspot 2>/dev/null
           nmcli connection delete Jellyfin-Hotspot 2>/dev/null
           
           echo "Hotspot stopped. WiFi re-enabled."
          ;;
          
         status)
           if nmcli connection show --active | grep -q "Jellyfin-Hotspot"; then
             echo "Hotspot is RUNNING"
             echo "SSID: Jellyfin-Travel"  
             echo "Jellyfin: http://192.168.42.1:8096"
           else
             echo "Hotspot is STOPPED"
           fi
          ;;
          
        *)
          echo "Usage: $0 {start|stop|status}"
          echo ""
          echo "start  - Start WiFi hotspot (disconnects from current WiFi)"
          echo "stop   - Stop hotspot and reconnect to WiFi"
          echo "status - Check hotspot status"
          ;;
      esac
    '';
    mode = "0755";
  };
}

