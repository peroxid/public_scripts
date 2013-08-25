cd /export/zones; for i in $(ls); do cat /root/.ssh/authorized_keys >> $i/root/root/.ssh/authorized_keys; done
cd -

