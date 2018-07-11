# Head-Counter
Tensorflow Object Detection API head count
# 事前準備：
    - install protoc
    $ curl -OL https://github.com/google/protobuf/releases/download/v3.4.0/protoc-3.4.0-linux-x86_64.zip
    $ unzip protoc-3.4.0-linux-x86_64.zip -d protoc3
    $ sudo mv protoc3/bin/* /usr/local/bin/
    $ sudo mv protoc3/include/* /usr/local/include/
    $ chown nicole /usr/local/bin/protoc
    $ chown -R nicole /usr/local/include/google
    $ protoc object_detection/protos/*.proto --python_out=.
    
    - install cuda9.0
    $ wget https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64-deb
    $ dpkg -i cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64-deb
    $ apt-key add /var/cuda-repo-9-0-local/7fa2af80.pub
    $ apt-get update
    $ apt-get install cuda


  
    - install tensorflow
    $ pip3 install tensorflow-gpu==1.5
    
    # Tensorflow Object Detection API
    $ pip3 install pillow
    $ pip3 install lxml
    $ pip3 install jupyter
    $ pip3 install matplotlib
    $ git clone https://github.com/tensorflow/models
    $ cd models/research
    $ export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim
    $ export LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}:/usr/lib/nvidia-396/
    
# 新增 main program 以及修改visualization_utils.py:    
    1. 把 main.py 放到 object_detection 底下
    2. 修改 把visualization_utils.py 放到object_detection/utils 底下,覆蓋掉原本的
    3. 執行 object_detection/utils/main.py
        $ python3 main.py  

# send json 
    $ cd /var/www
    $ vim result.php
    <?php
      $filename = "/home/nicole/LSA/models/research/object_detection/result.txt";
      $str="";
      header('Content-Type: application/json');
      if(file_exists($filename)){
      $file = fopen($filename, "r");
        if($file != NULL){
          $str .= fgets($file);
          echo json_encode($str, JSON_NUMERIC_CHECK);
        }
      }
    ?>
#  Source
   - [tensorflow/models](https://github.com/tensorflow/models)

## License

[Apache License 2.0](LICENSE)
