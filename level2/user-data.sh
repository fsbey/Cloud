user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y amazon-ssm-agent
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    yum -y install git
    cd /var/www/html
    git clone https://github.com/gabrielecirulli/2048.git
    cd 2048
    mv * ../
    cd ..
    rm -rf 2048
    systemctl restart httpd
    EOF
    