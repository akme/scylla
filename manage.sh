#!/usr/bin/env bash
#DC="" - scylladb doesn't support from cmdline
#SEEDS="" # 10.10.10.1,10.10.10.2,10.10.10.3
#CQLSH_HOST=10.10.10.1

check_container()
{
  if [ ! "$(docker ps -a | grep "scylla1")" ]; then
    echo "need to run init"
    exit 1
  fi
}

while [ "$1" != "" ]; do
  case $1 in
    -s| --seeds ) shift
      SEEDS="--seeds=$1"
      ;;
    -add) shift
      check_container
      SEEDS="--seeds=`docker inspect --format='{{ .NetworkSettings.IPAddress }}' scylla1`"
      docker run -d scylladb/scylla $SEEDS
      exit
      ;;
    -init)  shift
      docker run -d --name scylla1 scylladb/scylla
      exit
      ;;
    -status) shift
      docker exec -it scylla1 nodetool status
      exit
      ;;
    -connect) shift
      docker exec -it scylla1 cqlsh
      #        -i | --interactive )    interactive=1
      #				echo $interactive
      #                                ;;
      #        -h | --help )           usage
      #                                exit
      #                                ;;
      #        * )                     usage
      #                                exit 1
  esac
  shift
done
