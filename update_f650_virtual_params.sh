#!/bin/bash

echo "Memperbarui virtual parameters untuk device F650..."

# URL GenieACS API
API_URL="http://localhost:7557"
DEVICE_ID="94FE9D-F650-ZICG103EAB7D"

# Cek koneksi
if ! curl -s "$API_URL/devices" > /dev/null; then
    echo "Error: Tidak dapat terhubung ke GenieACS API!"
    exit 1
fi

echo "Koneksi ke GenieACS berhasil!"

# Update virtual parameters untuk F650
echo "Memperbarui virtual parameters..."

# 1. Update pppoeUsername - untuk IPoE username
curl -s -X PUT "$API_URL/virtualParameters/pppoeUsername" \
    -H "Content-Type: application/json" \
    -d '{
        "script": "// Username untuk IPoE/PPPoE\nlet username = \"\";\nlet ipoeUser = declare(\"InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANIPConnection.1.X_CT-COM_IPoEName\", {value: Date.now()});\nlet pppoeUser = declare(\"InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANPPPConnection.1.Username\", {value: Date.now()});\n\nif (ipoeUser.size && ipoeUser.value[0]) {\n    username = ipoeUser.value[0];\n} else if (pppoeUser.size && pppoeUser.value[0]) {\n    username = pppoeUser.value[0];\n}\n\nreturn {writable: false, value: [username, \"xsd:string\"]};"
    }' && echo " ✓ pppoeUsername updated"

# 2. Update pppoeIP - untuk IP address
curl -s -X PUT "$API_URL/virtualParameters/pppoeIP" \
    -H "Content-Type: application/json" \
    -d '{
        "script": "// IP Address untuk WAN Connection\nlet ip = \"\";\nlet ipoeIP = declare(\"InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANIPConnection.1.ExternalIPAddress\", {value: Date.now()});\nlet pppoeIP = declare(\"InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANPPPConnection.1.ExternalIPAddress\", {value: Date.now()});\n\nif (ipoeIP.size && ipoeIP.value[0]) {\n    ip = ipoeIP.value[0];\n} else if (pppoeIP.size && pppoeIP.value[0]) {\n    ip = pppoeIP.value[0];\n}\n\nreturn {writable: false, value: [ip, \"xsd:string\"]};"
    }' && echo " ✓ pppoeIP updated"

echo ""
echo "Selesai memperbarui virtual parameters untuk F650!"
echo "Memulai task untuk memproses virtual parameters..."

# Trigger virtual parameters untuk device F650
curl -s -X POST "$API_URL/devices/$DEVICE_ID/tasks" \
    -H "Content-Type: application/json" \
    -d '{
        "name": "getParameterValues",
        "parameterNames": [
            "VirtualParameters.pppoeUsername",
            "VirtualParameters.pppoeIP"
        ]
    }' && echo " ✓ Task created"

echo ""
echo "Virtual parameters telah diperbarui dan task telah dibuat!"
echo "Silakan tunggu beberapa menit dan refresh halaman web GenieACS untuk melihat perubahan."
