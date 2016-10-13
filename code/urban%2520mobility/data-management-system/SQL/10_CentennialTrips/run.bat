TITLE Run all SQL
for %%G in (*.sql) do sqlcmd /S USA0128AS017 /d UrbanMobility -E -i"%%G"
pause