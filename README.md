# docker-kafka

kafka 클러스터(3대로 구성)

## 실행
# zookeeper 먼저 실행
[docker-zookeeper](https://github.com/cyon13/docker-zookeeper) 먼저 실행 후 kafka 실행
```sh
# docker-compose 실행
docker-compose up -d
```

## 접속
```sh
docker exec -it kafka1 bash
jps #(kafka가 실행되어 있으면 정상)
```

## zookeeper에서 확인
```sh
# zookeeper 접속
ssh zk1
# zookeeper cli 실행
$ZOOKEEPER_HOME/bin/zkCli.sh

# znode root 디렉토리 검색
ls /  # my-kafka-cluster 가 출력 되면 정상

# znode kafka brokers의 id 확인
ls /my-kafka-cluster/brokers/ids  # 1, 2, 3 이 출력 되면 정상
