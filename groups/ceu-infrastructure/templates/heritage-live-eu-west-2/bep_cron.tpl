*/1 6-20 * * *  /home/ceu/chd3backend/partition.sh
*/1 6-20 * * *  /home/ceu/chd3backend/invoice.sh
*/1 6-20 * * *  /home/ceu/chd3backend/images.sh
*/1 6-20 * * *  /home/ceu/chd3backend/reports.sh
*/1 6-20 * * *  /home/ceu/chd3backend/packages.sh
*/1 6-20 * * *  /home/ceu/chd3backend/scud.sh
*/1 6-20 * * *  /home/ceu/chd3backend/fiche.sh
#
*/1 6-20 * * *  /home/ceu/chd3backend/jobsheet.sh
*/5 6-20 * * *  /home/ceu/chd3backend/internal.sh
#
##Print only on Tux2
*/1 6-20 * * *  /home/ceu/chd3backend/print.sh
*/1 6-20 * * *  /home/ceu/chd3backend/email.sh
#
*/1 6-20 * * *  /home/ceu/chd3backend/fax.sh
*/5 6-20 * * *  /home/ceu/chd3backend/faxStatus.sh
## SR - amend  cron due to session problems
#*/10 0-23 * * *  /home/ceu/chd3backend/weedall.sh
#
## Dump yesterdays order details
0 5 * * 2-6 /home/ceu/publ_cust/dump_orderDetail.sh >/tmp/orderDetail.out 2>&1
#
## FTP Order Details
0 6 * * 2-6 /home/ceu/publ_cust/OrderDetailftp.sh 172.16.200.33 ${ USER } ${ PASSWORD } > /dev/null 2>&1
#
## Perform IMPORT of PUBL Customer Database into CEU Customer Table
25 7 * * 0-6 /home/ceu/publ_cust/process_new_publ_dump.sh /home/ceu/custupdt/customer_info >/tmp/results-7-25 2>&1
#
#SR*/5 8-17 * * 1-5 /home/ceu/chd3backend/printerQueueChecker.sh
#
#SR0 0 * * 0 > /home/ceu/backend.log
#
## send a list of cert orders to cert copies section as a double check

#SR5 10,12,14,16,18 * * 1-5 /home/ceu/chd3backend/checkCerts.sh
#DC0 8-18 * * 1-5 /home/ceu/chd3backend/SameDaycheckCerts.sh
1 8-18 * * 1-5 /home/ceu/chd3backend/StandardcheckCerts.sh

0 8,9,10,11,12,13,14,15,16,17,18 * * 1-5 /home/ceu/chd3backend/getCEUFicheOrders.sh
#sr - start INC0279140
#20 15 * * 1-5 /home/ceu/chd3backend/getCEUFicheOrders.sh
#40 15 * * 1-5 /home/ceu/chd3backend/getCEUFicheOrders.sh
#sr - end INC0279140
#
##Cleanup Jobs
5 1 * * * find /mnt/nfs/onsite/ceu/post -path /mnt/nfs/onsite/ceu/post/.snapshot/ -prune -o -type f -ctime +4 -exec rm -f {} \;
15 1 * * * find /mnt/nfs/onsite/ceu/email -path /mnt/nfs/onsite/ceu/email/CEU/.snapshot/ -prune -o -type f -ctime +4 -exec rm -f {} \;
20 1 * * * find /mnt/nfs/onsite/ceu/online -path /mnt/nfs/onsite/ceu/online/.snapshot/ -prune -o -type f -ctime +1 -exec rm -f {} \;
