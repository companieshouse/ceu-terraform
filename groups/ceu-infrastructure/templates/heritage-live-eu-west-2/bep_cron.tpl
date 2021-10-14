#LIVE## DO NOT EDIT THIS FILE - edit the master and reinstall.
#LIVE## (/tmp/crontab.8223 installed on Fri Mar  2 14:08:07 2007)
#LIVE## (Cron version -- $Id: crontab.c,v 2.13 1994/01/17 03:20:37 vixie Exp $)
#LIVE#MARK*/1 6-20 * * *  /home/ceu/chd3backend/partition.sh
#LIVE*/1 6-20 * * *  /home/ceu/chd3backend/invoice.sh
#LIVE*/1 6-20 * * *  /home/ceu/chd3backend/images.sh
#LIVE*/1 6-20 * * *  /home/ceu/chd3backend/reports.sh
#LIVE*/1 6-20 * * *  /home/ceu/chd3backend/packages.sh
#LIVE*/1 6-20 * * *  /home/ceu/chd3backend/scud.sh
#LIVE*/1 6-20 * * *  /home/ceu/chd3backend/fiche.sh
#LIVE#
#LIVE*/1 6-20 * * *  /home/ceu/chd3backend/jobsheet.sh
#LIVE*/5 6-20 * * *  /home/ceu/chd3backend/internal.sh
#LIVE#
#LIVE##Print only on Tux2
#LIVE*/1 6-20 * * *  /home/ceu/chd3backend/print.sh
#LIVE*/1 6-20 * * *  /home/ceu/chd3backend/email.sh
#LIVE#
#LIVE*/1 6-20 * * *  /home/ceu/chd3backend/fax.sh
#LIVE*/5 6-20 * * *  /home/ceu/chd3backend/faxStatus.sh
#LIVE## SR - amend  cron due to session problems
#LIVE#*/10 0-23 * * *  /home/ceu/chd3backend/weedall.sh
#LIVE#
#LIVE## Dump yesterdays order details
#LIVE0 5 * * 2-6 /home/ceu/publ_cust/dump_orderDetail.sh >/tmp/orderDetail.out 2>&1
#LIVE#
#LIVE## Perform IMPORT of PUBL Customer Database into CEU Customer Table
#LIVE25 7 * * 0-6 /home/ceu/publ_cust/process_new_publ_dump.sh /home/custupdt/customer_info >/tmp/results-7-25 2>&1
#LIVE#
#LIVE#SR*/5 8-17 * * 1-5 /home/ceu/chd3backend/printerQueueChecker.sh
#LIVE#
#LIVE#SR0 0 * * 0 > /home/ceu/backend.log
#LIVE#
#LIVE## send a list of cert orders to cert copies section as a double check
#LIVE
#LIVE#SR5 10,12,14,16,18 * * 1-5 /home/ceu/chd3backend/checkCerts.sh
#LIVE#DC0 8-18 * * 1-5 /home/ceu/chd3backend/SameDaycheckCerts.sh
#LIVE1 8-18 * * 1-5 /home/ceu/chd3backend/StandardcheckCerts.sh
#LIVE
#LIVE0 8,9,10,11,12,13,14,15,16,17,18 * * 1-5 /home/ceu/chd3backend/getCEUFicheOrders.sh
#LIVE#sr - start INC0279140
#LIVE#20 15 * * 1-5 /home/ceu/chd3backend/getCEUFicheOrders.sh
#LIVE#40 15 * * 1-5 /home/ceu/chd3backend/getCEUFicheOrders.sh
#LIVE#sr - end INC0279140
#LIVE#
#LIVE##Cleanup Jobs
#LIVE5 1 * * * find /mnt/ceu/ais/post -path /mnt/ceu/ais/post/.snapshot/ -prune -o -type f -ctime +4 -exec rm -f {} \;
#LIVE10 1 * * * find /mnt/ceu/ais/fax -path /mnt/ceu/ais/fax/.snapshot/ -prune -o -type f -ctime +4 -exec rm -f {} \;
#LIVE15 1 * * * find /mnt/ceu/ais/email -path /mnt/ceu/ais/email/CEU/.snapshot/ -prune -o -type f -ctime +4 -exec rm -f {} \;
#LIVE20 1 * * * find /mnt/ceu/ais/online -path /mnt/ceu/ais/online/.snapshot/ -prune -o -type f -ctime +1 -exec rm -f {} \;
