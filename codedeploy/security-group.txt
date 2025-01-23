


aws ec2 create-security-group \
    --group-name MySecurityGroup \
    --description "flask-memcached-sg" \
    --vpc-id vpc-0bcc7205ac3507ed6

"GroupId": "sg-00d0ddf5dac1eefc4"

aws ec2 authorize-security-group-ingress \
    --group-id sg-00d0ddf5dac1eefc4 \
    --protocol tcp --port 22 --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-id sg-00d0ddf5dac1eefc4 \
    --protocol tcp --port 80 --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-id sg-00d0ddf5dac1eefc4 \
    --protocol tcp --port 8095 --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-id sg-00d0ddf5dac1eefc4 \
    --protocol tcp --port 8096 --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-id sg-00d0ddf5dac1eefc4 \
    --protocol icmp \
    --port -1 \
    --cidr 0.0.0.0/0
