cd /export/zones; for i in $(ls); do echo $(cat /root/.ssh/authorized_keys | grep hipa2) >> $i/root/root/.ssh/authorized_keys; done

