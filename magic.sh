add_externalip(){
    INSTANCES=("magiclogic-01" "magiclogic-02" "magiclogic-03" "magiclogic-04" "magiclogic-05" "magiclogic-06" "magiclogic-07" "magiclogic-08")
    for INSTANCE in ${INSTANCES[*]};
    do
        EXTERNAL_IP=$(gcloud compute instances describe $INSTANCE --project shipwire-eng-core-prod --zone us-central1-c --format="get(networkInterfaces[0].accessConfigs[0].natIP)")
        if [[ -z "$EXTERNAL_IP" ]]
        then
            echo "$INSTANCE VM is alredy Has External IP"
        else
            IP_ADDRESS=$(gcloud compute addresses list --project shipwire-eng-core-prod |grep $INSTANCE-external |awk '{match($0,/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/); ip = substr($0,RSTART,RLENGTH); print ip}')
            gcloud compute instances add-access-config $INSTANCE --access-config-name "External NAT" --address IP_ADDRESS
        fi
    done
}

remove_external_ip(){
    INSTANCES=("magiclogic-01" "magiclogic-02" "magiclogic-03" "magiclogic-04" "magiclogic-05" "magiclogic-06" "magiclogic-07" "magiclogic-08")
for INSTANCE in ${INSTANCES[*]};
    do
        EXTERNAL_IP=$(gcloud compute instances describe $INSTANCE --project shipwire-eng-core-prod --zone us-central1-c --format="get(networkInterfaces[0].accessConfigs[0].natIP)")
        if [[ -z "$EXTERNAL_IP" ]]
        then
            gcloud compute instances delete-access-config $INSTANCE  --access-config-name "External NAT"
        else
            echo "$INSTANCE instance dosent contain public IP"
        fi
    done
}