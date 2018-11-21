param(
[Parameter(Mandatory=$false,ValueFromPipeline=$true)]
[string]$Address = "",
[string]$Location = "",
[string]$Backup = ""
)



$router = [Firewall]::new($Address)
$router.Location = $Store
$router.Backup = $Backup
$router.ping()



class Firewall {
    [string]$IPaddress
    [string]$Location
    [string]$Backup
    [int]$status = 1


    Firewall([string]$ip){
        $this.IPaddress = $ip
    }

    ping(){
	#Email credentials
        $secpasswd = ConvertTo-SecureString "<password>" -AsPlainText -Force
        $mycreds = New-Object System.Management.Automation.PSCredential ("<email>", $secpasswd)
        $from = "<email>"
        $to = "<email>"
        $smtp = "<server>"

        
        DO{
        
        $ok = Test-Connection $this.IPaddress -Count 5 -Quiet
        if (-not($ok)){
            
            if ($this.status -eq(1) ){
                
                $this.status = 0
                
                $badSub = "Internet down at " + $this.Location  
                $body = "PC IP: " + $this.IPaddress + "  Backup IP: "
                
                Send-MailMessage -To $to -From $from -Subject $badSub -Body $body.ToString()  -SmtpServer $smtp -Credential $mycreds

            }
        }
        else { 
            if ($this.status -eq(0)){
                $this.status = 1
                
                $badSub = "Internet is back up at " + $this.Location 
                $body = "PC IP: " + $this.IPaddress
                

                Send-MailMessage -To $to -From $from -Subject $badSub -Body $body.ToString()  -SmtpServer $smtp -Credential $mycreds
            }
        }
        Start-Sleep 30
        }while ($this.IPaddress)
        
    }
}











