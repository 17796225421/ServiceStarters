# 关闭cmd兼容模式
Set-StrictMode -Off

# 获取监听在10011端口的进程PID
$processIDs = netstat -ano | Select-String ":10011" | ForEach-Object { $_.ToString().Split()[-1] }

# 定义一个空的哈希表，用于存储已经被结束的进程PID
$endedPids = @{}

# 对获取到的PID进行遍历
foreach($processID in $processIDs){
    # 如果pid不存在于哈希表中，则尝试结束进程并将pid添加到哈希表中
    if($endedPids[$processID] -eq $null){
        try {
            Stop-Process -Id $processID -Force -ErrorAction Stop
            $endedPids[$processID] = 1
            # 输出已经被停止的进程的PID
            Write-Host "Process $processID has been stopped." 
        }
        catch {
            Write-Host "Cannot stop process $processID, possibly due to insufficient permissions or process does not exist."
        }
    }
}

# 使用Start-Process启动一个新的PowerShell子进程
# 使用"-WorkingDirectory"参数指定新的工作目录，这样就不会影响到你的终端当前目录
# 使用"-Wait"参数，当Node服务退出时，新的PowerShell子进程也会退出，这样就可以确保退出终端后Node服务不会继续运行
Start-Process -FilePath "PowerShell.exe" -NoNewWindow -WorkingDirectory "C:\Users\zhouzihong\Desktop\aibrower\script\switch" -Wait -ArgumentList "-Command", "& node server.js"