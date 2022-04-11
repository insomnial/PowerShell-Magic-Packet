<# Send a magic packet to the supplied MAC address #>
# initial start from https://www.pdq.com/blog/wake-on-lan-wol-magic-packet-powershell/

# Parameter help description
$mac = $args[0]

#split MAC on ":" or "-" into an array of bytes
$MacByteArray = $Mac -split "[:-]" | ForEach-Object { [Byte] "0x$_"}

#create packet array with padding to make Magic Packet
[Byte[]] $MagicPacket = (,0xFF * 6) + ($MacByteArray  * 16)

#create UDP client to handle network connection
$UdpClient = New-Object System.Net.Sockets.UdpClient
$UdpClient.Connect(([System.Net.IPAddress]::Broadcast),7)

#send packet
$bytesSent = $UdpClient.Send($MagicPacket,$MagicPacket.Length)

"Packet sent $bytesSent bytes"

#clean up
$UdpClient.Close()
