package com.coway.trust.biz.common.impl;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.io.IOUtils;
import org.apache.tika.Tika;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import com.amazonaws.AmazonClientException;
import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.auth.DefaultAWSCredentialsProviderChain;
import com.amazonaws.client.builder.AwsClientBuilder.EndpointConfiguration;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.CopyObjectRequest;
import com.amazonaws.services.s3.model.GetObjectRequest;
import com.amazonaws.services.s3.model.ListObjectsRequest;
import com.amazonaws.services.s3.model.ListObjectsV2Request;
import com.amazonaws.services.s3.model.ListObjectsV2Result;
import com.amazonaws.services.s3.model.ObjectListing;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.ObjectTagging;
import com.amazonaws.services.s3.model.PutObjectRequest;
//import com.amazonaws.services.s3.model.PutObjectResult;
import com.amazonaws.services.s3.model.S3Object;
import com.amazonaws.services.s3.model.S3ObjectInputStream;
import com.amazonaws.services.s3.model.S3ObjectSummary;
import com.amazonaws.services.s3.model.Tag;
import com.amazonaws.services.s3.transfer.MultipleFileDownload;
import com.amazonaws.services.s3.transfer.Transfer;
import com.amazonaws.services.s3.transfer.TransferManager;
import com.amazonaws.services.s3.transfer.TransferManagerBuilder;
import com.coway.trust.biz.common.AWSS3Service;
import com.coway.trust.util.CommonUtils;
import com.google.common.io.ByteSource;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.AwsCredentialsProvider;
import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3AsyncClient;
import software.amazon.awssdk.services.s3.model.ListObjectsResponse;
import software.amazon.awssdk.services.s3.model.S3Exception;
import software.amazon.awssdk.transfer.s3.S3TransferManager;
import software.amazon.awssdk.transfer.s3.model.CompletedFileDownload;
import software.amazon.awssdk.transfer.s3.model.DownloadFileRequest;
import software.amazon.awssdk.transfer.s3.model.FileDownload;
import software.amazon.awssdk.transfer.s3.progress.LoggingTransferListener;



@Service("awsService")
public class AWSS3ServiceImpl implements AWSS3Service {

	private static Logger logger = LoggerFactory.getLogger(AWSS3ServiceImpl.class);
    // Access key id will be read from the application.properties file during the application intialization.
    @Value("${cloud.aws.credentials.accessKey}")
    private String accessKey;
    // Secret access key will be read from the application.properties file during the application intialization.
    @Value("${cloud.aws.credentials.secretKey}")
    private String secretKey;
    // Region will be read from the application.properties file  during the application intialization.
    @Value("${cloud.aws.region}")
    private String region;
    @Value("${com.file.upload.path}")
    private String commonPath;

    /*@Autowired
    private CommonUtils commonUtils;*/


    private Gson gson = new Gson();
    @Value("${cloud.aws.s3.bucket}")
    private String bucket;

    private AmazonS3 amazonS3Client() throws Exception{
    	logger.info("Start loading AmazonS3 Client with {}:{}:{}:{}",accessKey,secretKey,region,bucket);

    	AmazonS3 aa = null;
    	try{
    		aa = AmazonS3ClientBuilder
                .standard()
//                .withRegion(Regions.AP_SOUTHEAST_1)
                //.withRegion(region)
                .withEndpointConfiguration(new EndpointConfiguration(
                        "https://s3.amazonaws.com",
                        region))
                .withCredentials(new AWSStaticCredentialsProvider(
                        new BasicAWSCredentials(accessKey, secretKey)))
                .build();
    	} catch (AmazonServiceException ase) {
            // Handle errors related to Amazon Web Services (AWS) service
            ase.printStackTrace();
        } catch (AmazonClientException ace) {
            // Handle errors related to the Amazon S3 client
            ace.printStackTrace();
        } catch (Exception e) {
            // Handle any other exceptions that may occur
            e.printStackTrace();
        }

    	logger.info("end loading AmazonS3 Client ");

        return aa;
//        AmazonS3ClientBuilder
//                .standard()
//                .withRegion(Regions.AP_SOUTHEAST_1)
//                //.withRegion(region)
////                .withEndpointConfiguration(new EndpointConfiguration(
////                        "https://s3.eu-west-1.amazonaws.com",
////                        region))
//                .withCredentials(new AWSStaticCredentialsProvider(
//                        new BasicAWSCredentials(accessKey, secretKey)))
//                .build();
    }

//    @Lazy
//    @Resource(name = "amazonS3Client")
//    private AmazonS3 amazonS3;

//    @Autowired
//    public AWSS3ServiceImpl(AmazonS3Client amazonS3Client) {
//        this.amazonS3Client=amazonS3Client;
//    }

    // @Async annotation ensures that the method is executed in a different background thread
    // but not consume the main thread.
    /*@Async
    public JsonObject uploadFile( String dirName, MultipartFile multipartFile) {
    	return uploadFile(  dirName,  multipartFile,new  HashMap<String,String>() , UUID.randomUUID().toString().toUpperCase());

    }

    @Async
    public JsonObject uploadFile( String dirName, MultipartFile multipartFile,String fileId) {
    	return uploadFile(  dirName,  multipartFile,new  HashMap<String,String>(), fileId);

    }

    @Async
    public JsonObject uploadFile( String dirName, MultipartFile multipartFile,HashMap<String,String> tagMap) {
    	return uploadFile(  dirName,  multipartFile, tagMap, UUID.randomUUID().toString().toUpperCase());

    }*/

    /*@Async
    public JsonObject uploadFile( String dirName, MultipartFile multipartFile,  HashMap<String,String> tagMap , String fileId) {
    	logger.info("File upload in progress.");
    	File file = null;
    	JsonObject rtnJson = new JsonObject();

        String oRtnCode = "";
        String oRtnMsg = "";
        String oUploadedFileName = "";


        try {
            file = convertMultiPartFileToFile(multipartFile);
            if(tagMap.size()>0) {
            	rtnJson = uploadFileToS3Bucket(bucket, dirName, file,tagMap, fileId);
            	logger.info(rtnJson.toString());

            }else {

            	rtnJson = uploadFileToS3Bucket(bucket, dirName, file, fileId);
            	logger.info(rtnJson.toString());

            }
             oRtnCode          = rtnJson.get("oRtnCode").getAsString();
             oRtnMsg           = rtnJson.get("oRtnMsg").getAsString();

             if(!oRtnCode.equals("TRUE")) {
                 logger.error("File upload is failed with reason:{}",oRtnMsg);
                 throw new Exception("File upload is failed with reason:"+oRtnMsg);
             }else {
                 logger.info("File upload is completed.");
             }


            file.delete();  // To remove the file locally created in the project folder.
            return rtnJson;
        } catch (final AmazonServiceException ex) {
        	logger.info("File upload is failed.");
        	logger.error("Error= {} while uploading file.", ex.getMessage());
        	return rtnJson;
        } catch(Exception e){
        	logger.info("File upload is failed.");
        	logger.error("Error= {} while uploading file.", e.getMessage());
        	return rtnJson;
        }finally {
        	if(file!=null) {file.delete();};
        }

    }*/

    /*@Async
    public JsonObject uploadStream(String dirName, String fileName, InputStream is,
            HashMap<String,String> tagMap) {
    	return uploadStream(  dirName,  fileName, is, tagMap,  UUID.randomUUID().toString().toUpperCase());

    }

    @Async
    public JsonObject uploadStreamInternal(String dirName,  String base64String,
            JsonObject tagJson) {
    	InputStream decoded = null;
    	JsonObject errRtnJson = new JsonObject();
		HashMap<String,String> map = new HashMap<String,String>();
		String fileName = "";
		try {
			HashMap<String, String> tagMap = gson.fromJson(tagJson.toString(), map.getClass());
	    	if(!tagMap.containsKey("actual-filename")) {
	    		throw new Exception ("No File Name");
	    	}
	    	String[] arrOfStr = base64String.split(",", 2);

	    	logger.debug(arrOfStr[0]);

	    	if(!CommonUtils.isValidBase64(arrOfStr[1])) {
	    		throw new Exception ("Not valid BASE64");
	    	}
	    	//is = IOUtils.toInputStream(base64String, "UTF-8");
	    	//decoded = ByteSource.wrap(initialArray).openStream()
	    	byte[] decoder = Base64.getDecoder().decode(arrOfStr[1]);
	    	decoded = ByteSource.wrap(decoder).openStream();

	    	fileName = tagMap.get("actual-filename");

	    	return uploadStream(  dirName,  fileName, decoded, tagMap,  UUID.randomUUID().toString().toUpperCase());
		}catch(Exception e) {
			logger.error("Exception occurred on uploadFile:{}"+e.toString());
    		e.printStackTrace();

    		errRtnJson.addProperty("oRtnCode","FALSE");
    		errRtnJson.addProperty("oRtnMsg",e.getMessage());
            return errRtnJson;
    	}finally {

    	   if(decoded!=null) {
    		   try {
				decoded.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
    	   }
       }



    }*/

    /*@Async
    public JsonObject uploadStream( String dirName, String fileName, InputStream is,
    		                       HashMap<String,String> tagMap , String fileId) {
    	logger.info("File upload in progress.");
    	File file = null;
    	JsonObject rtnJson = new JsonObject();

        String oRtnCode = "";
        String oRtnMsg = "";
        String oUploadedFileName = "";


        try {

            if(tagMap.size()>0) {
            	rtnJson = uploadStreamToS3Bucket(bucket, dirName, fileName, is,tagMap, fileId);
            	logger.info(rtnJson.toString());

            }else {

            	rtnJson = uploadStreamToS3Bucket(bucket, dirName, fileName, is, fileId);
            	logger.info(rtnJson.toString());

            }
             oRtnCode          = rtnJson.get("oRtnCode").getAsString();
             oRtnMsg           = rtnJson.get("oRtnMsg").getAsString();

             if(!oRtnCode.equals("TRUE")) {
                 logger.error("File upload is failed with reason:{}",oRtnMsg);
                 throw new Exception("File upload is failed with reason:"+oRtnMsg);
             }else {
                 logger.info("File upload is completed.");
             }


            file.delete();  // To remove the file locally created in the project folder.
            return rtnJson;
        } catch (final AmazonServiceException ex) {
        	logger.info("File upload is failed.");
        	logger.error("Error= {} while uploading file.", ex.getMessage());
        	return rtnJson;
        } catch(Exception e){
        	logger.info("File upload is failed.");
        	logger.error("Error= {} while uploading file.", e.getMessage());
        	return rtnJson;
        }finally {
        	if(file!=null) {file.delete();};
        }

    }*/

    @Async
    public S3ObjectInputStream  downloadSingleFile( String dirName, String fileId) {

    	logger.info("AWSS3 ServiceImpl File download in progress for id:({}/{}).",dirName,fileId);

    	S3ObjectInputStream  s3ObjectInputStream  = null;
        try {
//            file = convertMultiPartFileToFile(multipartFile);
//            uploadFileToS3Bucket(bucket, file);
//            logger.info("File upload is completed.");
//            file.delete();  // To remove the file locally created in the project folder.

          logger.info("AWSS3 ServiceImpl downloadSingleFile bucket : " + bucket);

            GetObjectRequest getObjectRequest = new GetObjectRequest(bucket, dirName+"/"+fileId);

            logger.info("AWSS3 ServiceImpl getObjectRequest : " + getObjectRequest);

            AmazonS3 amazonS3 = this.amazonS3Client();

            logger.info("AWSS3 ServiceImpl downloadSingleFile amazonS3 : " + amazonS3);

            S3Object s3Object = amazonS3.getObject(getObjectRequest);

            logger.info("AWSS3 ServiceImpl downloadSingleFile s3Object : " + s3Object);

            //test/02/25be0d92-e38e-472f-8d25-02aaf9d12540
            //test/02/25be0d92-e38e-472f-8d25-02aaf9d12540
            s3ObjectInputStream = s3Object.getObjectContent();

            logger.info("AWSS3 ServiceImpl downloadSingleFile s3ObjectInputStream : " + s3ObjectInputStream);


        	//return s3ObjectInputStream;
        } catch (final AmazonServiceException ex) {
        	String errorCode = ex.getErrorCode();

            logger.debug("AmazonServiceException code:{}", errorCode);
        	logger.info("File download is failed.");
        	logger.error("Error while downloading file = {} .", ex.getMessage());
        	if(s3ObjectInputStream != null){
        		s3ObjectInputStream.abort();
        	}
        	//return s3ObjectInputStream;

        }catch (AmazonClientException ace) {
            // Handle errors related to the Amazon S3 client
        	logger.debug("AmazonClientException code:{}");
            ace.printStackTrace();
        } catch (final Exception ex) {
        	logger.info("File download is failed.");
        	logger.error("Error= {} while uploading file.", ex.getMessage());
        	if(s3ObjectInputStream != null){
        		s3ObjectInputStream.abort();
        	}
        	//return s3ObjectInputStream;

        }
        finally {
        	if(s3ObjectInputStream!=null) {try {
            	s3ObjectInputStream.abort();
        		s3ObjectInputStream.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}};
			return s3ObjectInputStream;
        }

    }

    public ObjectMetadata objectMetaData( String dirName, String fileId) {

    	logger.info("AWSS3 ServiceImpl objectMetaData File download in progress for id:({}/{}).",dirName,fileId);

    	ObjectMetadata objectMetadata = null;
        try {
//            file = convertMultiPartFileToFile(multipartFile);
//            uploadFileToS3Bucket(bucket, file);
//            logger.info("File upload is completed.");
//            file.delete();  // To remove the file locally created in the project folder.

            AmazonS3 amazonS3 = this.amazonS3Client();

            logger.info("AWSS3 ServiceImpl objectMetaData amazonS3 ",amazonS3 );

            logger.info("AWSS3 ServiceImpl objectMetaData bucket : " + bucket);

            objectMetadata = amazonS3.getObjectMetadata(bucket, dirName+"/"+fileId);

            logger.info("AWSS3 ServiceImpl objectMetaDat : " + objectMetadata);
            //test/02/25be0d92-e38e-472f-8d25-02aaf9d12540
            //test/02/25be0d92-e38e-472f-8d25-02aaf9d12540

        	return objectMetadata;
        } catch (final AmazonServiceException ex) {
        	String errorCode = ex.getErrorCode();

            logger.debug("AmazonServiceException code:{}", errorCode);
        	logger.info("File download is failed.");
        	logger.error("Error while downloading file = {} .", ex.getMessage());
        	return objectMetadata;

        }catch (final Exception ex) {
        	logger.info("File download is failed.");
        	logger.error("Error= {} while uploading file.", ex.getMessage());
        	return objectMetadata;

        }

    }

//    private File convertMultiPartFileToFile( MultipartFile multipartFile) {
//        final File file = new File(multipartFile.getOriginalFilename());
//        try (final FileOutputStream outputStream = new FileOutputStream(file)) {
//            outputStream.write(multipartFile.getBytes());
//        } catch (final IOException ex) {
//        	logger.error("Error converting the multi-part file to file= ", ex.getMessage());
//        }
//        return file;
//    }


    /*private File convertMultiPartFileToFile(MultipartFile multipartFile) throws IOException {
        File convFile = new File(System.getProperty("java.io.tmpdir") + System.getProperty("file.separator") +
                multipartFile.getOriginalFilename());
                multipartFile.transferTo(convFile);
        return convFile;
      }*/

    /*private JsonObject uploadFileToS3Bucket( String bucketName, String dirName,  File file, String fileId) {
    	return uploadFileToS3Bucket( bucketName,  dirName, file, new HashMap<String, String>(), fileId );
    }*/

    /*private JsonObject uploadFileToS3Bucket(String bucketName, String dirName, File file, Map<String, String> tagMap, String fileId ) {
    	JsonObject rtnJson = new JsonObject();
    	try {
            //final String uniqueFileName = LocalDateTime.now() + "_" + file.getName();
        	final String uniqueFileName = dirName+"/"+fileId;

            logger.info("Uploading file to bucket:({}) with name={} ",bucketName, uniqueFileName);

            Tika tika = new Tika();
            String mimeType = tika.detect(file);
             String fileName = file.getName();
             ObjectMetadata metadata = new ObjectMetadata();
    	     // copy previous metadata
             metadata.addUserMetadata("actual-filename", URLEncoder.encode(fileName, "UTF-8"));
             metadata.setContentLength(file.length());
             metadata.setContentType(mimeType);
             logger.info("file.getName():{}",fileName);
             logger.info("file.getName+URLEncode():{}",URLEncoder.encode(fileName, "UTF-8"));
             logger.info("file.mimeType():{}",mimeType);

             InputStream is = new FileInputStream(file);
             final PutObjectRequest putObjectRequest = new PutObjectRequest(bucketName, uniqueFileName, is, metadata);

            List<Tag> tags = new ArrayList<Tag>();
            AmazonS3 amazonS3Client = this.amazonS3Client();
            if(tagMap.size()>0) {
                //tags.add(new Tag("TESTTAG", "10000"));
                tagMap.forEach((key,value) -> tags.add(new Tag(key,value)));
                putObjectRequest.setTagging(new ObjectTagging(tags));
//                List<Bucket> buckets = amazonS3Client.listBuckets();
//                for (Bucket b : buckets) {
//                	logger.info("Uploading file to bucket:({}) with name={}",b.getName());
//                    //System.out.println("* " + b.getName());
//                }
            }

            PutObjectResult uploadResult =  amazonS3Client.putObject(putObjectRequest);

            //Check Uploaded file via AWS S3 getObject
            GetObjectRequest getObjectRequest = new GetObjectRequest(bucket, uniqueFileName);
            S3Object uplodaedS3Object = amazonS3Client.getObject(getObjectRequest);

            ObjectMetadata returnedMetaData =  uplodaedS3Object.getObjectMetadata();
            Map<String, String> returnedUserMetaData = returnedMetaData.getUserMetadata();
            logger.info("returnedUserMetaData values {}", returnedUserMetaData);
            String rtnUploadedActualFileName = returnedMetaData.getUserMetaDataOf("actual-filename");
            logger.info("Returned Actual filename on User Metadata:{}",returnedMetaData.getUserMetaDataOf("actual-filename"));
            logger.info("Returned contents Type on Metadata:{}",returnedMetaData.getRawMetadataValue("Content-Type"));


            is.close();
            boolean doesItExists = amazonS3Client.doesObjectExist(bucketName, uniqueFileName);

            if(doesItExists) {

                    rtnJson.addProperty("oRtnCode","TRUE");
                    rtnJson.addProperty("oRtnMsg","-");
                    rtnJson.addProperty("oOriginalFileName",fileName);
                    rtnJson.addProperty("oUploadedFileName",uniqueFileName);

            }else {
                rtnJson.addProperty("oRtnCode","FALSE");
                rtnJson.addProperty("oRtnMsg","File Not uploaded!");
                rtnJson.addProperty("oOriginalFileName",fileName);
                rtnJson.addProperty("oUploadedFileName",uniqueFileName);
            }


            return rtnJson;
    	}catch (Exception e) {
    		logger.error("Exception on S3 File upload:{}",e.toString());
    		e.printStackTrace();
            rtnJson.addProperty("oRtnCode","FALSE");
            rtnJson.addProperty("oRtnMsg",e.getMessage());

    		return rtnJson;
    	}

    }*/

    /*private JsonObject uploadStreamToS3Bucket( String bucketName, String dirName, String fileName, InputStream is,  String fileId) {
    	return uploadStreamToS3Bucket( bucketName,  dirName, fileName, is , new HashMap<String, String>(), fileId );
    }*/

    /*private JsonObject uploadStreamToS3Bucket(String bucketName, String dirName, String fileName, InputStream is, Map<String, String> tagMap, String fileId ) {
    	JsonObject rtnJson = new JsonObject();
    	try {
            //final String uniqueFileName = LocalDateTime.now() + "_" + file.getName();
        	final String uniqueFileName = dirName+"/"+fileId;

            logger.info("Uploading file to bucket:({}) with name={} ",bucketName, uniqueFileName);

            Tika tika = new Tika();
            String mimeType = tika.detect(is);
             ObjectMetadata metadata = new ObjectMetadata();
    	     // copy previous metadata
             metadata.addUserMetadata("actual-filename", URLEncoder.encode(fileName, "UTF-8"));
             //metadata.setContentLength(IOUtils.toByteArray(is).length);
             metadata.setContentType(mimeType);
             logger.info("file.getName():{}",fileName);
             logger.info("file.getName+URLEncode():{}",URLEncoder.encode(fileName, "UTF-8"));
             logger.info("file.mimeType():{}",mimeType);

//             InputStream is = new FileInputStream(file);
             final PutObjectRequest putObjectRequest = new PutObjectRequest(bucketName, uniqueFileName, is, metadata);

            List<Tag> tags = new ArrayList<Tag>();
            AmazonS3 amazonS3Client = this.amazonS3Client();
            if(tagMap.size()>0) {
                //tags.add(new Tag("TESTTAG", "10000"));
                tagMap.forEach((key,value) -> tags.add(new Tag(key,value)));
                putObjectRequest.setTagging(new ObjectTagging(tags));
//                List<Bucket> buckets = amazonS3Client.listBuckets();
//                for (Bucket b : buckets) {
//                	logger.info("Uploading file to bucket:({}) with name={}",b.getName());
//                    //System.out.println("* " + b.getName());
//                }
            }

            PutObjectResult uploadResult =  amazonS3Client.putObject(putObjectRequest);

            //Check Uploaded file via AWS S3 getObject
            GetObjectRequest getObjectRequest = new GetObjectRequest(bucket, uniqueFileName);
            S3Object uplodaedS3Object = amazonS3Client.getObject(getObjectRequest);

            ObjectMetadata returnedMetaData =  uplodaedS3Object.getObjectMetadata();
            Map<String, String> returnedUserMetaData = returnedMetaData.getUserMetadata();
            logger.info("returnedUserMetaData values {}", returnedUserMetaData);
            String rtnUploadedActualFileName = returnedMetaData.getUserMetaDataOf("actual-filename");
            logger.info("Returned Actual filename on User Metadata:{}",returnedMetaData.getUserMetaDataOf("actual-filename"));
            logger.info("Returned contents Type on Metadata:{}",returnedMetaData.getRawMetadataValue("Content-Type"));


            is.close();
            boolean doesItExists = amazonS3Client.doesObjectExist(bucketName, uniqueFileName);

            if(doesItExists) {

                    rtnJson.addProperty("oRtnCode","TRUE");
                    rtnJson.addProperty("oRtnMsg","-");
                    rtnJson.addProperty("oOriginalFileName",fileName);
                    rtnJson.addProperty("oUploadedFileName",uniqueFileName);

            }else {
                rtnJson.addProperty("oRtnCode","FALSE");
                rtnJson.addProperty("oRtnMsg","File Not uploaded!");
                rtnJson.addProperty("oOriginalFileName",fileName);
                rtnJson.addProperty("oUploadedFileName",uniqueFileName);
            }


            return rtnJson;
    	}catch (Exception e) {
    		logger.error("Exception on S3 File upload:{}",e.toString());
    		e.printStackTrace();
            rtnJson.addProperty("oRtnCode","FALSE");
            rtnJson.addProperty("oRtnMsg",e.getMessage());

    		return rtnJson;
    	}

    }
*/

    /*private PutObjectResult upload(String filePath, String uploadKey) throws Exception {
        return upload(new FileInputStream(filePath), uploadKey);
    }*/

    /*private PutObjectResult upload(InputStream inputStream, String uploadKey) throws Exception {
        PutObjectRequest putObjectRequest = new PutObjectRequest(bucket, uploadKey, inputStream, new ObjectMetadata());

        putObjectRequest.setCannedAcl(CannedAccessControlList.PublicRead);
        AmazonS3 amazonS3 = null;
		try {
			amazonS3 = this.amazonS3Client();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        PutObjectResult putObjectResult = amazonS3.putObject(putObjectRequest);

        IOUtils.closeQuietly(inputStream);

        return putObjectResult;
    }*/

    /*public List<PutObjectResult> upload(MultipartFile[] multipartFiles) throws IOException {
        List<PutObjectResult> putObjectResults = new ArrayList<>();

        Arrays.stream(multipartFiles)
                .filter(multipartFile -> !StringUtils.isEmpty(multipartFile.getOriginalFilename()))
                .forEach(multipartFile -> {
                    try {
						putObjectResults.add(upload(multipartFile.getInputStream(), multipartFile.getOriginalFilename()));
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
                });

        return putObjectResults;
    }*/

    /*public ResponseEntity<byte[]> download(String key) throws Exception {



        GetObjectRequest getObjectRequest = new GetObjectRequest(bucket, key);
        AmazonS3 amazonS3 = this.amazonS3Client();
        S3Object s3Object = amazonS3.getObject(getObjectRequest);


        ObjectMetadata s3ObjectMetadata = s3Object.getObjectMetadata();
        String contentsType = s3ObjectMetadata.getContentType();

        S3ObjectInputStream objectInputStream = s3Object.getObjectContent();

        byte[] bytes = IOUtils.toByteArray(objectInputStream);

        String fileName = URLEncoder.encode(key, "UTF-8").replaceAll("\\+", "%20");

        HttpHeaders httpHeaders = new HttpHeaders();
        if(contentsType.equals("")||contentsType==null) {
        	httpHeaders.setContentType(MediaType.APPLICATION_OCTET_STREAM);
        }else {
        	MediaType mediaType = MediaType.parseMediaType(contentsType);
        	httpHeaders.setContentType(mediaType);
        }

        httpHeaders.setContentLength(bytes.length);
        httpHeaders.setContentDispositionFormData("attachment", fileName);

        return new ResponseEntity<>(bytes, httpHeaders, HttpStatus.OK);
    }*/

    /*public List<S3ObjectSummary> list() throws Exception {
        AmazonS3 amazonS3 = null;
		try {
			amazonS3 = this.amazonS3Client();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        ObjectListing objectListing = amazonS3.listObjects(new ListObjectsRequest().withBucketName(bucket));

        List<S3ObjectSummary> s3ObjectSummaries = objectListing.getObjectSummaries();

        return s3ObjectSummaries;
    }*/

    public JsonObject copyFile( String fromDirName, String toDirName, String fileId ) {
    	JsonObject rtnJson = new JsonObject();
    	String encodedUrl   = "";
    	try {
    		AmazonS3 amazonS3 = this.amazonS3Client();


    		boolean doesItExists = amazonS3.doesObjectExist(bucket, fromDirName+"/"+fileId);
    		if(!doesItExists) {
    			throw new Exception("No object existed:"+fromDirName+"/"+fileId);
    		}


            CopyObjectRequest copyObjRequest = new CopyObjectRequest(bucket, fromDirName+"/"+fileId, bucket, toDirName+"/"+fileId);
            amazonS3.copyObject(copyObjRequest);

            rtnJson.addProperty("oRtnCode","TRUE");
            rtnJson.addProperty("oRtnMsg","-");
            rtnJson.addProperty("oFromObject",fromDirName+"/"+fileId);
            rtnJson.addProperty("oToObject",toDirName+"/"+fileId);
    		return rtnJson;
    	}catch (AmazonServiceException ase) {
    		logger.error("Exception on copyFile:",ase.getMessage());

    		logger.error("Caught an AmazonServiceException, which means your request made it "
                    + "to Amazon S3, but was rejected with an error response for some reason.");
    		logger.error("Error Message:    " + ase.getMessage());
    		logger.error("HTTP Status Code: " + ase.getStatusCode());
    		logger.error("AWS Error Code:   " + ase.getErrorCode());
    		logger.error("Error Type:       " + ase.getErrorType());
    		logger.error("Request ID:       " + ase.getRequestId());

            rtnJson.addProperty("oRtnCode","FALSE");
            rtnJson.addProperty("oRtnMsg",ase.getMessage());
    		return rtnJson;

        } catch (AmazonClientException ace) {

        	logger.error("Exception on copyFile:",ace.getMessage());
        	logger.error("Caught an AmazonClientException, which means the client encountered "
                    + "a serious internal problem while trying to communicate with S3, "
                    + "such as not being able to access the network.");


            rtnJson.addProperty("oRtnCode","FALSE");
            rtnJson.addProperty("oRtnMsg",ace.getMessage());
            return rtnJson;
        }catch(Exception e) {

    		logger.error("Exception on copyFile:",e.getMessage());
    		e.printStackTrace();

            rtnJson.addProperty("oRtnCode","FALSE");
            rtnJson.addProperty("oRtnMsg",e.getMessage());
    		return rtnJson;
    	}
    };

    public JsonObject deleteFile( String dirName, String fileId ){
    	JsonObject rtnJson = new JsonObject();
    	try {
    		AmazonS3 amazonS3 = this.amazonS3Client();


    		boolean doesItExists = amazonS3.doesObjectExist(bucket, dirName+"/"+fileId);
    		if(!doesItExists) {
    			throw new Exception("No object existed:"+dirName+"/"+fileId);
    		}

            amazonS3.deleteObject(bucket, dirName+"/"+fileId);

            rtnJson.addProperty("oRtnCode","TRUE");
            rtnJson.addProperty("oRtnMsg","-");
            rtnJson.addProperty("oDeletedObject",dirName+"/"+fileId);

    		return rtnJson;
    	}catch (AmazonServiceException ase) {
    		logger.error("Exception on deleteFile(AmazonServiceException):",ase.getMessage());

    		logger.error("Caught an AmazonServiceException, which means your request made it "
                    + "to Amazon S3, but was rejected with an error response for some reason.");
    		logger.error("Error Message:    " + ase.getMessage());
    		logger.error("HTTP Status Code: " + ase.getStatusCode());
    		logger.error("AWS Error Code:   " + ase.getErrorCode());
    		logger.error("Error Type:       " + ase.getErrorType());
    		logger.error("Request ID:       " + ase.getRequestId());

            rtnJson.addProperty("oRtnCode","FALSE");
            rtnJson.addProperty("oRtnMsg",ase.getMessage());
    		return rtnJson;

        } catch (AmazonClientException ace) {
        	logger.error("Exception on deleteFile(AmazonClientException):",ace.getMessage());
        	logger.error("Caught an AmazonClientException, which means the client encountered "
                    + "a serious internal problem while trying to communicate with S3, "
                    + "such as not being able to access the network.");
        	logger.error("Error Message: " + ace.getMessage());

            rtnJson.addProperty("oRtnCode","FALSE");
            rtnJson.addProperty("oRtnMsg",ace.getMessage());
            return rtnJson;
        }catch(Exception e) {

    		logger.error("Exception on deleteFile:",e.getMessage());
    		e.printStackTrace();

            rtnJson.addProperty("oRtnCode","FALSE");
            rtnJson.addProperty("oRtnMsg",e.getMessage());
    		return rtnJson;
    	}
    }

	@Async
	public EgovMap downloadSingleFile1(EgovMap request) {
		EgovMap result = new EgovMap();
		try {

			S3ObjectInputStream s3ObjIs = null;
			String contentType = "";
			String dirName = request.get("directory").toString();
			String fileId = request.get("fileId").toString();
			String uploadPath = request.get("uploadPath").toString();

			logger.info("AWSS3 Controller POST download-single-file dirName : " + dirName);
			logger.info("AWSS3 Controller POST download-single-file fileId : " + fileId);

			// s3ObjIs = aWSS3ServiceImpl.downloadSingleFile( dirName, fileId);
			logger.info("AWSS3 ServiceImpl File download in progress for id:({}/{}).", dirName, fileId);

			S3ObjectInputStream s3ObjectInputStream = null;
			S3Object s3Object = null;
			try {
				// file = convertMultiPartFileToFile(multipartFile);
				// uploadFileToS3Bucket(bucket, file);
				// logger.info("File upload is completed.");
				// file.delete(); // To remove the file locally created in the project folder.

				logger.info("AWSS3 ServiceImpl downloadSingleFile bucket : " + bucket);

				GetObjectRequest getObjectRequest = new GetObjectRequest(bucket, dirName + "/" + fileId);

				logger.info("AWSS3 ServiceImpl getObjectRequest : " + getObjectRequest);

				AmazonS3 amazonS3 = this.amazonS3Client();

				logger.info("AWSS3 ServiceImpl downloadSingleFile amazonS3 : " + amazonS3);

				// S3Object
				s3Object = amazonS3.getObject(getObjectRequest);

				logger.info("AWSS3 ServiceImpl downloadSingleFile s3Object : " + s3Object);

				s3ObjectInputStream = s3Object.getObjectContent();

				logger.info("AWSS3 ServiceImpl downloadSingleFile s3ObjectInputStream : " + s3ObjectInputStream);

				s3ObjIs = s3ObjectInputStream;
			} catch (final AmazonServiceException ex) {
				String errorCode = ex.getErrorCode();

				logger.debug("AmazonServiceException code:{}", errorCode);
				logger.info("File download is failed.");
				logger.error("Error while downloading file = {} .", ex.getMessage());
				if (s3ObjectInputStream != null) {
					s3ObjectInputStream.abort();
				}
				s3ObjIs = s3ObjectInputStream;
				result.put("status", "-2");
				result.put("message", ex.getMessage());
			} catch (AmazonClientException ace) {
	            // Handle errors related to the Amazon S3 client
	            ace.printStackTrace();
	            logger.error("AmazonClientException = {} .", ace.getMessage());
	            result.put("status", "-3");
				result.put("message", ace.getMessage());
	        } catch (final Exception ex) {
				logger.info("File download is failed.");
				logger.error("Error= {} while uploading file.", ex.getMessage());
				if (s3ObjectInputStream != null) {
					s3ObjectInputStream.abort();
				}
				s3ObjIs = s3ObjectInputStream;
				result.put("status", "-4");
				result.put("message", ex.getMessage());
			}

			if (s3ObjIs == null) {

				// return new ResponseEntity<>(null, HttpStatus.BAD_REQUEST);
				result.put("status", "0");
				result.put("message", "No File.");
				throw new Exception("No s3ObjIs");
			}

			ObjectMetadata metadata = this.objectMetaData(dirName, fileId);

			logger.info("Content-Type: " + metadata.getContentType());
			Map<String, String> userMetaData = metadata.getUserMetadata();

			logger.info("userMetaData: " + metadata.getUserMetadata());

			contentType = metadata.getContentType();
			String fileName = userMetaData.get("actual-filename");

			logger.info("fileName: {}", fileName);
			logger.info("fileSize: {}", metadata.getContentLength());

			if (fileName == null || fileName.equals("")) {
				// throw new Exception ("No File Name");
				fileName = fileId;
			}

			InputStreamResource inputStreamResource = new InputStreamResource(s3ObjIs);
			InputStream in = new BufferedInputStream(s3Object.getObjectContent());
			ByteArrayOutputStream out = new ByteArrayOutputStream();

			byte[] buf = new byte[1024];

			int n = 0;

			while (-1 != (n = in.read(buf))) {

				out.write(buf, 0, n);

			}
			in.close();
			byte[] response = out.toByteArray();
			FileOutputStream fos = new FileOutputStream(commonPath + uploadPath + "/" + fileName);
			fos.write(response);
			fos.close();

			result.put("status", "1");

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			logger.error("downloadSingleFile1: {}", e.toString());
			// return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
			result.put("status", result.get("status") != null ? result.get("status") : "-1");
			result.put("message", result.get("message") != null ? result.get("message") : e.getMessage());
		} finally {
			// if(s3ObjIs!=null) { try { s3ObjIs.abort(); s3ObjIs.close();}catch (Exception e) {}};
			logger.error("downloadSingleFile1 finally");
			return result;
		}
	}

	public EgovMap listBucketObjects(EgovMap request) throws Exception {

		EgovMap result = new EgovMap();
		S3Object s3Object = null;
		String dirName = request.get("directory").toString();
		String fileType = request.get("fileType") == null ? "" : request.get("fileType").toString();
	       try {

	    	   AmazonS3 amazonS3 = this.amazonS3Client();

				logger.info("AWSS3 ServiceImpl downloadSingleFile amazonS3 : " + amazonS3);

//				GetObjectRequest getObjectRequest = new GetObjectRequest(bucket, dirName + "/" + fileId);
//
//				logger.info("AWSS3 ServiceImpl getObjectRequest : " + getObjectRequest);
//
//				// S3Object
//				s3Object = amazonS3.getObject(getObjectRequest);

				logger.info("Objects in S3 bucket %s:\n", bucket);
				//final AmazonS3 s3 = AmazonS3ClientBuilder.standard().withRegion(Regions.DEFAULT_REGION).build();
				ListObjectsV2Request req = new ListObjectsV2Request().withBucketName(bucket).withPrefix(dirName+ "/").withDelimiter(dirName+ "/");
				ListObjectsV2Result listing = amazonS3.listObjectsV2(req);

				List<S3ObjectSummary> objects = listing.getObjectSummaries();

				List<String> fileList = new ArrayList<String>();
				for (S3ObjectSummary os : objects) {
					HashMap<String, Object> file = new HashMap<String, Object>();
				    System.out.println("* " + os.getKey());
				    if(os.getKey().toString().contains(fileType)){
					    fileList.add(os.getKey().toString());
				    }
				}

				if(fileList.size() > 0){
					result.put("files", fileList);
					result.put("status", 1);
				}else{
					result.put("status", 0);
					result.put("message", "no file");
				}
				logger.info("AWSS3 ServiceImpl listBucketObjects result : " + result);

//	            ListObjectsRequest listObjects = ListObjectsRequest
//	                    .builder()
//	                    .bucket(bucket)
//	                    .build();
//
//	            ListObjectsResponse res = amazonS3.listObjects(listObjects);
//	            List<S3Object> objects = res.contents();
//
//	            for (ListIterator iterVals = objects.listIterator(); iterVals.hasNext(); ) {
//	                S3Object myValue = (S3Object) iterVals.next();
//	                System.out.print("\n The name of the key is " + myValue.key());
//	                System.out.print("\n The object is " + calKb(myValue.size()) + " KBs");
//	                System.out.print("\n The owner is " + myValue.owner());
//
//	             }

	        } catch (S3Exception e) {
	        	result.put("status", 0);
	        	result.put("message", "S3Exception");
	        	return result;
	        }
		return result;
	    }

	public EgovMap moveFile(EgovMap request) throws Exception {
		logger.info("AWSS3 ServiceImpl moveFile start");
		EgovMap result = new EgovMap();
        String sourceKey = request.get("sourceFile").toString();
        String targetKey = request.get("targetFile").toString();
        String fileId = request.get("fileId").toString();

        AmazonS3 amazonS3 = this.amazonS3Client();

		logger.info("AWSS3 ServiceImpl downloadSingleFile amazonS3 : " + amazonS3);

        TransferManager transferManager = TransferManagerBuilder.standard()
            .withS3Client(amazonS3)
            .build();

        /*try {
            // List objects in the bucket with the specified prefix
            ObjectListing objects = amazonS3.listObjects(bucket, request.get("directory").toString());

            // Check if there are any objects with the common prefix
            if (!objects.getObjectSummaries().isEmpty()) {
                System.out.println("The folder exists.");
            } else {
                System.out.println("The folder does not exist.");
                amazonS3.putObject(bucket, request.get("directory").toString(), "");
            }
        } catch (AmazonServiceException e) {
            e.printStackTrace();
        }*/

        boolean exist = false;
        try {
        	EgovMap params = new EgovMap();
        	String directory = targetKey.replaceAll(request.get("fileId").toString(), "");
        	params.put("directory", directory);
        	params.put("fileType", ".xls");
    		EgovMap returnResult = this.listBucketObjects(params);

    		if(returnResult.get("status").toString().equals("1")){
    			List<String> fileList = new ArrayList<String>();
    			fileList = (List<String>) returnResult.get("files");


    			for (String filePath : fileList) {
    				if(filePath.contains(fileId)){
    					exist = true;
    				}

    				if(exist) break;
    			}
    		}

    		logger.info("AWSS3 ServiceImpl downloadSingleFile exist : " + exist);
    		if(exist){
    			SimpleDateFormat dateFormat1 = new SimpleDateFormat("yyyyMMddHHmm");
				Date currentDate1 = new Date();
				String todayFormattedDate1 = dateFormat1.format(currentDate1);
				String file = targetKey.replaceAll(request.get("fileType").toString(), "");
				targetKey =  file + "_" + todayFormattedDate1 + request.get("fileType").toString();
    		}


        	// Copy the object from the source to the target
            Transfer transfer = transferManager.copy(bucket, sourceKey, bucket, targetKey);

            logger.info("AWSS3 ServiceImpl downloadSingleFile getProgress " + transfer.getProgress());
            logger.info("AWSS3 ServiceImpl downloadSingleFile getState " + transfer.getState());
            // Wait for the transfer to complete
            try {
				transfer.waitForCompletion();
				logger.info("AWSS3 ServiceImpl moveFile complete");
				logger.info("AWSS3 ServiceImpl downloadSingleFile getProgress " + transfer.getProgress());
	            logger.info("AWSS3 ServiceImpl downloadSingleFile getState " + transfer.getState());
			} catch (AmazonClientException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

         // Delete the source object
            amazonS3.deleteObject(bucket, sourceKey);

            logger.info("File moved successfully to the target folder.");
        } catch (AmazonServiceException e) {
            e.printStackTrace();
        } finally {
            transferManager.shutdownNow();
        }

        logger.info("AWSS3 ServiceImpl moveFile end");
        return result;
	}
}
