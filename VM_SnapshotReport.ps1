# отчет по наличию снапшотов у ВМ в среде VMWare


$vCenters = 'vcenter65','nonprod-vcenter'

$body = ""
foreach($vc in $vCenters){
    Connect-VIServer -Server $vc
    $snaps = get-vm|Get-Snapshot |select vm, @{n = "SizeGB";e={[math]::round($_.SizeGB,3)} }, name, description
    Disconnect-VIServer -Server $vc -Confirm:$false
    $body = $body + "<br>↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓<b>" + $vc + "</b>↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓<br>"
    foreach($i in $snaps){
        $body = $body + "<br><b>VM:</b>" + $i.VM + "<br>"
        $body = $body + "<b>SizeGB:</b>" + $i.SizeGB + "<br>"
        $body = $body + "<b>Name:</b>" + $i.Name.Replace('%252f','-') + "<br>"
        $body = $body + "<b>Description:</b>" + $i.Description + "<br>"
    }
}
$encoding = [System.Text.Encoding]::UTF8
Send-MailMessage -From "Admin@contoso.com"  -BodyAsHtml -to "LeadAdmins@contoso.com" -Subject "Snapshots VMs" -Body $body  -SmtpServer mail.contoso.com -Encoding $encoding