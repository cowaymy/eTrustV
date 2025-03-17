# Step 1: Maven을 사용하여 빌드
FROM maven:3.8.6-openjdk-8 AS builder

ARG arg_packaging=jar

RUN echo ${arg_packaging}

WORKDIR /app

COPY pom.xml .

RUN mvn verify clean --fail-never

COPY src src

RUN mvn package -Dspring.profiles.active=dev

FROM openjdk:18-jdk-slim
# WORKDIR /usr/local/tomcat/
# For Crystal Report Font Missing
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update -y
RUN apt-get install -y apt-utils    --no-install-recommends
RUN apt-get install -y libfreetype6 --no-install-recommends
RUN apt-get install -y fontconfig   --no-install-recommends
RUN apt-get install -y fonts-dejavu --no-install-recommends

WORKDIR /app


ARG arg_spring_profile_active
ENV env_spring_profile_active=${arg_spring_profile_active}

ARG arg_application_name
ENV env_application_name=${arg_application_name}

ENV env_app=${arg_application_name}.${arg_packaging}

RUN echo ${env_spring_profile_active}
RUN echo ${env_application_name}





# Step 2: Tomcat 8을 사용하여 실행
FROM tomcat:8-jdk8


# Tomcat 환경 변수 설정 (UTF-8 인코딩, Spring Profile)
ENV CATALINA_OPTS="-Dfile.encoding=UTF-8 -Dspring.profiles.active=dev"


# JNDI 데이터 소스 설정을 위한 context.xml 복사
COPY context.xml /usr/local/tomcat/conf/context.xml


COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war


# Tomcat 포트 설정
EXPOSE 8080

# Tomcat 실행
CMD ["catalina.sh", "run"]