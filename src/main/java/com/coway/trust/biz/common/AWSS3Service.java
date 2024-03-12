package com.coway.trust.biz.common;

import java.io.InputStream;
import java.util.HashMap;

import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MultipartFile;

import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.S3ObjectInputStream;
import com.google.gson.JsonObject;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface AWSS3Service {

//	JsonObject uploadFile( String dirName, MultipartFile multipartFile);
//	JsonObject uploadFile( String dirName, MultipartFile multipartFile, String fileId);
//	JsonObject uploadFile( String dirName, MultipartFile multipartFile, HashMap<String,String> hashMap);
//	JsonObject uploadFile( String dirName, MultipartFile multipartFile, HashMap<String,String> hashMap, String fileId);
	S3ObjectInputStream downloadSingleFile(  String dirName, String fileId);
	EgovMap downloadSingleFile1( EgovMap request);
	EgovMap listBucketObjects( EgovMap request)  throws Exception;
	EgovMap moveFile( EgovMap request)  throws Exception;
	ObjectMetadata objectMetaData(  String dirName, String fileId);

//	JsonObject uploadStream( String dirName, String fileName, InputStream is,
//            HashMap<String,String> tagMap);
//
//	JsonObject uploadStreamInternal( String dirName,  String base64String,
//            JsonObject tagJson);
//
//	JsonObject uploadStream( String dirName, String fileName, InputStream is,
//                             HashMap<String,String> tagMap , String fileId);

	JsonObject copyFile( String fromDirName, String toDirName, String fileId );

	JsonObject deleteFile( String dirName, String fileId );
}
