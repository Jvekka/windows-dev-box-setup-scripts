
# tools we expect devs across many scenarios will want
choco install -y git --package-parameters="'/GitAndUnixToolsOnPath /WindowsTerminal'"
choco install -y sysinternals
choco install -y powershell-core
choco install -y microsoft-windows-terminal
# choco install -y azure-cli | Not doing anything with Az/O365 currently
choco install -y vagrant

# vscode installed in own script