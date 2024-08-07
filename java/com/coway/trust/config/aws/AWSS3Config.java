package com.coway.trust.config.aws;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Component;

import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;

//@Configuration
//@ComponentScan("com.coway.trust")
@Component
public class AWSS3Config {
	private static Logger logger = LoggerFactory.getLogger(AWSS3Config.class);

    // Access key id will be read from the application.properties file during the application intialization.
    @Value("${cloud.aws.credentials.accessKey}")
    private String accessKey;
    // Secret access key will be read from the application.properties file during the application intialization.
    @Value("${cloud.aws.credentials.secretKey}")
    private String secretKey;
    // Region will be read from the application.properties file  during the application intialization.
    @Value("${cloud.aws.region}")
    private String region;

//    @Bean
//    public BasicAWSCredentials basicAWSCredentials() {
//        return new BasicAWSCredentials(accessKey, secretKey);
//    }

//    @Bean
//    public static AmazonS3Client amazonS3Client() {
//        return (AmazonS3Client) AmazonS3ClientBuilder.standard()
//                .withCredentials(new BasicAWSCredentials(accessKey, secretKey))
//                .build();
//    }

    /*@Primary
    @Bean(name = "amazonS3Client")
	public AmazonS3 amazonS3Client() {
    	logger.info("Start loading AmazonS3 Client with {}:{}",accessKey,secretKey);
        return AmazonS3ClientBuilder
                .standard()
                .withRegion(region)
                .withCredentials(new AWSStaticCredentialsProvider(
                        new BasicAWSCredentials(accessKey, secretKey)))
                .build();
    }*/
}