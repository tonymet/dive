.PHONY: volumes mysql

volumes:
	mkdir -p storage/{logs,sessions,meta} mysql log

mysql:
	 docker exec -it dockvine_env_mysql_1 mysql -e "CREATE DATABASE dockvine"
