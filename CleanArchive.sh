sqlplus "/ as sysdba" << EOF
!echo "Current Maximum Archive log"
select thread#, max (sequence#) MAX_Thread from v\$archived_log where APPLIED='YES' group by thread#;
echo "Current ORABACK partition size"
SELECT name, free_mb, total_mb, free_mb/total_mb*100 "% Free_MB" FROM v\$asm_diskgroup where name='ORABACK';
exit
EOF
rman <<EOF
connect target /;
delete archivelog all completed before 'SYSDATE-7';
YES
exit;
EOF
sqlplus "/ as sysdba" << EOF
echo "Current ORABACK partition size after Deleting old Archive files"
SELECT name, free_mb, total_mb, free_mb/total_mb*100 "% Free_MB" FROM v\$asm_diskgroup where name='ORABACK';
exit
EOF


select max(sequence#) from v$archived_log where applied='YES';
