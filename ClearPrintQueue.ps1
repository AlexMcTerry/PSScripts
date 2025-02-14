# Очистка очереди печати на серверах по списку. Удаляются документы, старше 2х дней.
# Очищается папка spool, заранее перенесенная в c:\spool от tmp файлов.

$printservers = 'список принт-серверов'

foreach($pserv in $printservers){
    Get-Printer -ComputerName $pserv | Get-PrintJob | where {$_.SubmittedTime -lt (get-date).AddDays(-1)}|Remove-PrintJob -ErrorAction SilentlyContinue
    Get-ChildItem -Path \\$pserv\c$\spool\*.tmp| Remove-Item
}