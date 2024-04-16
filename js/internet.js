function icon(wifiState, ethernetState, strength) {
    let img;

    if(ethernetState && !wifiState) {
        img = "../icons/ethernet.svg";
    }

    else if(!ethernetState && wifiState) {
        if(strength < 55) {
            img = "../icons/wifi_epic";
        }

        else if(strength < 70) {
            img = "../icons/wifi_medium";
        }

        else {
            img = "../icons/wifi_low";
        }
    }

    else {
        img = "../icons/no_access.svg";
    }

    return img;
}