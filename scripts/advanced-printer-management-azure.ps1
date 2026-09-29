### FILE: index.php
<?php
// Fetch data from Microsoft Graph and render UI cards for printer management
$printers = $ms->graphCall('/print/printers', $_SESSION['ms_access_token']);
foreach ($printers['value'] as $printer) {
    render_premium_card(
        $printer['displayName'],
        $printer['isAcceptingJobs'] ? 'Available' : 'Unavailable',
        $printer['jobsPending'] . ' jobs pending',
        $printer['isAcceptingJobs'] ? 'up' : 'down',
        '🖨',
        intval($printer['jobsPending'] / 100 * 100)
    );
}
?>

### FILE: scripts/Automation.ps1
<#
.SYNOPSIS
   Manage Universal Print configurations through Microsoft Graph.
.DESCRIPTION
   Connects to Microsoft Graph to manage printer configurations and updates for Universal Print services.
.EXAMPLE
   .\Automation.ps1 -TenantID 'your-tenant-id' -PrinterName 'Printer1'
.NOTES
   Author:      Souhaiel Morhag
   Company:     MSEndpoint.com
   Blog:        https://msendpoint.com
   Academy:     https://app.msendpoint.com/academy
   LinkedIn:    https://linkedin.com/in/souhaiel-morhag
   GitHub:      https://github.com/Msendpoint
   License:     MIT
#>

Param(
    [Parameter(Mandatory = $true)]
    [string]$TenantID,

    [Parameter(Mandatory = $true)]
    [string]$PrinterName
)

Try {
    Import-Module Microsoft.Graph.UniversalPrint -ErrorAction Stop
    Connect-MgGraph -Scopes 'UniversalPrint.ReadWrite'

    $printer = Get-MgPrintPrinter -PrinterName $PrinterName
    If ($null -eq $printer) {
        throw 'Printer not found in directory'
    }

    # Additional management logic can be included here
    Write-Host 'Managing printer: ' -ForegroundColor Green -NoNewline
    Write-Host $printer.displayName
}
Catch {
    Write-Error 'An error occurred: ' $_
    Exit 1
}