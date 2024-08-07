package com.coway.trust.web.file;

import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.URI;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.S3ObjectInputStream;
import com.coway.trust.biz.common.AWSS3Service;
import com.coway.trust.biz.common.impl.AWSS3ServiceImpl;
import com.coway.trust.util.CommonUtils;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;


@Controller
@RequestMapping(value= "/file")
public class AWSS3Controller {
	private static final Logger logger = LoggerFactory.getLogger(AWSS3Controller.class);

	@Resource(name = "awsService")
    private AWSS3Service awsService;

    @Value("${com.file.upload.path}")
    private String uploadDir;


    /*@Autowired
    private CommonUtils commonUtils;*/

    private Gson gson = new Gson();


    /*@RequestMapping(value= "/upload", method = RequestMethod.POST)
    public ResponseEntity<String> uploadFile(
    		          @RequestParam(value= "dirName") String dirName,
    		          @RequestPart(value= "file")  MultipartFile multipartFile,
    		          @RequestParam(value= "tagJson") String tagJson
    		          )  {
    	JsonObject rtnJson = new JsonObject();
    	try {
    		HashMap<String,String> map = new HashMap<String,String>();
        	HashMap<String, String> tagMap = gson.fromJson(tagJson, map.getClass());
        	rtnJson = awsService.uploadFile(dirName, multipartFile,tagMap);
//            final String response = "[" + multipartFile.getOriginalFilename() + "] uploaded successfully.";

            return new ResponseEntity<>(rtnJson.toString(), HttpStatus.OK);
    	}catch (Exception e) {
    		logger.error("Exception occurred on uploadFile:{}"+e.toString());
    		e.printStackTrace();

            rtnJson.addProperty("oRtnCode","FALSE");
            rtnJson.addProperty("oRtnMsg",e.getMessage());
            return new ResponseEntity<>(rtnJson.toString(), HttpStatus.INTERNAL_SERVER_ERROR);
    	}

    }*/

    /*@RequestMapping(value= "/uploadByBase64", method = RequestMethod.POST)
    public ResponseEntity<String> uploadBase64Pdf(
    		 HttpServletRequest  req
			, RequestEntity<String> requestEntity

    		          )  {
    	JsonObject rtnJson = new JsonObject();
    	String fileName = "";
    	String dirName ="";
    	String base64String ="";
    	JsonObject tagJson =  new JsonObject();
    	String reqBody = "";
    	JsonObject jsonObjectBody = new JsonObject();

    	try {
            HttpHeaders headers = requestEntity.getHeaders();
            logger.info("request headers : " + headers);
            HttpMethod method = requestEntity.getMethod();
            logger.info("request method : " + method);
            logger.info("request url: " + requestEntity.getUrl());
            reqBody = requestEntity.getBody();
            logger.debug("reqBody:{}" ,reqBody);
        	if(reqBody==""||reqBody==null){
            	throw new Exception("BODYEMPTY");
            }

        	if(reqBody==""||reqBody==null){
            	throw new Exception("BODYEMPTY");
            }
        	if(CommonUtils.isJSONValid(reqBody)) {
        		jsonObjectBody = JsonParser.parseString(reqBody).getAsJsonObject();
           	}

        	tagJson = jsonObjectBody.get("tagJson").getAsJsonObject();
        	dirName = jsonObjectBody.get("dirName").getAsString();
        	base64String = jsonObjectBody.get("base64String").getAsString();


        	rtnJson = awsService.uploadStreamInternal(dirName, base64String,tagJson);
//            final String response = "[" + multipartFile.getOriginalFilename() + "] uploaded successfully.";

            return new ResponseEntity<>(rtnJson.toString(), HttpStatus.OK);
    	}catch (Exception e) {
    		logger.error("Exception occurred on uploadFile:{}"+e.toString());
    		e.printStackTrace();

            rtnJson.addProperty("oRtnCode","FALSE");
            rtnJson.addProperty("oRtnMsg",e.getMessage());
            return new ResponseEntity<>(rtnJson.toString(), HttpStatus.INTERNAL_SERVER_ERROR);
    	}

    }*/

    @RequestMapping(value= "/download-single-file", method = RequestMethod.POST)
    public ResponseEntity<byte[]> postDownloadFile(
	    		@RequestParam(value= "dirName") String dirName,
	    		@RequestParam(value= "fileId") String fileId,
	    		HttpServletResponse response
    		) {
    	         S3ObjectInputStream s3ObjIs  = null;
		         String contentType = "";
			        try {
			          logger.info("AWSS3 Controller download-single-file dirName : " + dirName);
			          logger.info("AWSS3 Controller download-single-file fileId : " + fileId);

			        	s3ObjIs = awsService.downloadSingleFile(  dirName, fileId);

			        	if(s3ObjIs==null) {

			        		return new ResponseEntity<>(null, HttpStatus.BAD_REQUEST);
			        	}

			        	ObjectMetadata metadata =  awsService.objectMetaData(  dirName, fileId);

			            logger.info("Content-Type: " + metadata.getContentType());

			            Map<String, String> userMetaData = metadata.getUserMetadata();
			            contentType =  metadata.getContentType();

			            logger.info("userMetaData: " + userMetaData);

			            String fileName = userMetaData.get("actual-filename");

			            logger.info("fileName: {}", fileName);
			            logger.info("fileSize: {}", metadata.getContentLength());

			            if(fileName.equals("")||fileName == null) {
			            	throw new Exception ("No File Name");
			            }
			            //InputStreamResource inputStreamResource = new InputStreamResource(s3ObjIs);
			            //InputStreamResource resource = new InputStreamResource(stream);
			            byte[] bytes = IOUtils.toByteArray(s3ObjIs);

			            HttpHeaders headers = new HttpHeaders();
			            headers.add("Cache-Control", "no-cache, no-store, must-revalidate");
			            headers.add("Content-Disposition", "attachment; filename=" + fileName);
			            headers.add("Content-Type", contentType);

			            headers.add("Pragma", "no-cache");
			            headers.add("Expires", "0");
			            headers.add("Last-Modified", new Date().toString());
			            headers.add("ETag", String.valueOf(System.currentTimeMillis()));

			            return ResponseEntity.ok()
			                    .headers(headers)
			                    .contentLength(metadata.getContentLength())
			                    //.contentType(MediaType.APPLICATION_OCTET_STREAM )
			                    .body(bytes);

					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();

						return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
					}finally {
						if(s3ObjIs!=null) { try { s3ObjIs.abort(); s3ObjIs.close();}catch (Exception e) {}};
					}

    }

    @RequestMapping(value= "/copy-file", method = RequestMethod.POST)
    public ResponseEntity<Object> postCopyFile(
	    		@RequestParam(value= "fromDirName") String fromDirName,
	    		@RequestParam(value= "toDirName") String toDirName,
	    		@RequestParam(value= "fileId") String fileId,
	    		HttpServletResponse response) {
    	         JsonObject rtnJsonObj = new JsonObject();
		         String contentType = "";
		         String exceptionKey = "UNKNOWN";
			        try {
			        	rtnJsonObj = awsService.copyFile(  fromDirName, toDirName, fileId);

			        	return CommonUtils.httpReqRtnString("S","OK",rtnJsonObj,"ok");

					} catch (Exception e) {

			        	e.printStackTrace();
			        	if(CommonUtils.isJSONObject(e.getMessage())){
			        		return CommonUtils.httpReqRtnString("E",exceptionKey,gson.fromJson(e.getMessage(),JsonObject.class),"ie");
			        	}else if(CommonUtils.isJSONArray(e.getMessage())){
			        		return CommonUtils.httpReqRtnString("E",exceptionKey,gson.fromJson(e.getMessage(),JsonArray.class),"ie");
			        	}else {
			        		return CommonUtils.httpReqRtnString("E",exceptionKey+"-"+e.getMessage(),new JsonArray(),"ie");
			        	}

					}

    }


    @RequestMapping(value= "/delete-file", method = RequestMethod.POST)
    public ResponseEntity<Object> postDeleteFile(
	    		@RequestParam(value= "dirName") String dirName,
	    		@RequestParam(value= "fileId") String fileId,
	    		HttpServletResponse response) {
    	         JsonObject rtnJsonObj = new JsonObject();
		         String contentType = "";
		         String exceptionKey = "UNKNOWN";
			        try {
			        	rtnJsonObj = awsService.deleteFile(  dirName,  fileId);

			        	return CommonUtils.httpReqRtnString("S","OK",rtnJsonObj,"ok");

					} catch (Exception e) {

			        	e.printStackTrace();
			        	if(CommonUtils.isJSONObject(e.getMessage())){
			        		return CommonUtils.httpReqRtnString("E",exceptionKey,gson.fromJson(e.getMessage(),JsonObject.class),"ie");
			        	}else if(CommonUtils.isJSONArray(e.getMessage())){
			        		return CommonUtils.httpReqRtnString("E",exceptionKey,gson.fromJson(e.getMessage(),JsonArray.class),"ie");
			        	}else {
			        		return CommonUtils.httpReqRtnString("E",exceptionKey+"-"+e.getMessage(),new JsonArray(),"ie");
			        	}

					}
    }

    @RequestMapping(value= "/download-single-file", method = RequestMethod.GET)
    public ResponseEntity<byte[]> getDownloadFile(
	    		@RequestParam(value= "dirName") String dirName,
	    		@RequestParam(value= "fileId") String fileId,
	    		@RequestParam(value= "uploadDest") String uplDest,
	    		HttpServletResponse response
    		) {

    	//AWSS3ServiceImpl aWSS3ServiceImpl = new AWSS3ServiceImpl();
    	         S3ObjectInputStream s3ObjIs  = null;
		         String contentType = "";
			        try {

			          logger.info("AWSS3 Controller POST download-single-file dirName : " + dirName);
                logger.info("AWSS3 Controller POST download-single-file fileId : " + fileId);

			        	s3ObjIs = awsService.downloadSingleFile(  dirName, fileId);

			        	if(s3ObjIs==null) {

			        		return new ResponseEntity<>(null, HttpStatus.BAD_REQUEST);
			        	}

			        	ObjectMetadata metadata =  awsService.objectMetaData(  dirName, fileId);

			            logger.info("Content-Type: " + metadata.getContentType());
			            Map<String, String> userMetaData = metadata.getUserMetadata();

			            logger.info("userMetaData: " + metadata.getUserMetadata());

			            contentType =  metadata.getContentType();
			            String fileName = userMetaData.get("actual-filename");

			            logger.info("fileName: {}", fileName);
			            logger.info("fileSize: {}", metadata.getContentLength());

			            if(fileName == null || fileName.equals("")) {
			            	//throw new Exception ("No File Name");
			              fileName = fileId;
			            }

			            //InputStreamResource inputStreamResource = new InputStreamResource(s3ObjIs);
			            //InputStreamResource resource = new InputStreamResource(stream);
			            byte[] bytes = IOUtils.toByteArray(s3ObjIs);

			            HttpHeaders headers = new HttpHeaders();
			            headers.add("Cache-Control", "no-cache, no-store, must-revalidate");
			            headers.add("Content-Disposition", "attachment; filename=" + fileName);
			            headers.add("Content-Type", contentType);

			            headers.add("Pragma", "no-cache");
			            headers.add("Expires", "0");
			            headers.add("Last-Modified", new Date().toString());
			            headers.add("ETag", String.valueOf(System.currentTimeMillis()));

			            URI myURI = new URI(uploadDir + uplDest);

			            return ResponseEntity.ok()
			                    .headers(headers)
			                    .contentLength(metadata.getContentLength())
			                    //.contentType(MediaType.APPLICATION_OCTET_STREAM )
			                    .location(myURI)
			                    .body(bytes);

					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();

						return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
					}finally {
						if(s3ObjIs!=null) { try { s3ObjIs.abort(); s3ObjIs.close();}catch (Exception e) {}};
					}

    }
    @RequestMapping(value= "/download-multi-file", method = RequestMethod.POST, produces="application/zip")
    public ResponseEntity<byte[]> postDownloadMultiZipFile(
	    		@RequestParam(value= "dirKeyListJsonArr") String s3DirKeyListJsonArrString,
	    		HttpServletResponse response
    		) throws IOException {

		         String zipFileName = "zipfile.zip";
		         byte[] zipOutBytes =  null;
		         ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
		         BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(byteArrayOutputStream);
		         ZipOutputStream zipOutputStream = new ZipOutputStream(bufferedOutputStream);
		         HashMap<String,Integer> fileCheckMap = new HashMap<String,Integer>();

			        try {

			        	if(!CommonUtils.isJSONArray(s3DirKeyListJsonArrString)) {
			        		//throw new Exception ("s3DirKeyListJsonArrString is not JSONArray!");
			        		return new ResponseEntity<>(null, HttpStatus.BAD_REQUEST);
			        	}

			        	JsonArray s3DirKeyListJsonArr = new JsonParser().parse(s3DirKeyListJsonArrString).getAsJsonArray();
			        	//s3ObjIs = service.downloadSingleFile(  dirName, fileId);

                        if(s3DirKeyListJsonArr.size()==0) {
                        	return new ResponseEntity<>(null, HttpStatus.BAD_REQUEST);
                        }
			        	//ObjectMetadata metadata =  service.objectMetaData(  dirName, fileId);
//			            logger.info("Content-Type: " + metadata.getContentType());
//			            Map<String, String> userMetaData = metadata.getUserMetadata();
//			            contentType =  metadata.getContentType();
//			            String fileName = userMetaData.get("actual-filename");
//			            logger.info("fileName: {}", fileName);
//			            logger.info("fileSize: {}", metadata.getContentLength());
//			            if(fileName.equals("")||fileName == null) {
//			            	throw new Exception ("No File Name");
//			            }
			            //InputStreamResource inputStreamResource = new InputStreamResource(s3ObjIs);
			            //InputStreamResource resource = new InputStreamResource(stream);
                        for(int i = 0; i< s3DirKeyListJsonArr.size(); i++){

                        	    Integer fileDupCnt = 0;

	    	    	        	JsonElement s3DirKeyListJsonElem = s3DirKeyListJsonArr.get(i);

	    	    	        	JsonObject s3DirKeyListJsonObj = s3DirKeyListJsonElem.getAsJsonObject();
	    	    	        	logger.debug(s3DirKeyListJsonObj.toString());

	    	    	        	String dirName       = s3DirKeyListJsonObj.get("dirName").getAsString();
	    	    	        	String fileId    = s3DirKeyListJsonObj.get("fileId").getAsString();

	                        	S3ObjectInputStream s3ObjIs  = awsService.downloadSingleFile(  dirName, fileId);
	                        	ObjectMetadata metadata =  awsService.objectMetaData(  dirName, fileId);

	    			            Map<String, String> userMetaData = metadata.getUserMetadata();
	    			            String contentType =  metadata.getContentType();
	    			            String fileName = userMetaData.get("actual-filename");

	    			            if(fileCheckMap.containsKey(fileName)) {

	    			            	fileDupCnt = fileCheckMap.get(fileName)+1;

	    			            	fileCheckMap.put(fileName,fileDupCnt);

	    			            }else {
	    			            	fileCheckMap.put(fileName,fileDupCnt);
	    			            }

	    			            logger.info("fileName: {}", fileName);
	    			            logger.info("contentType: {}", contentType);
	    			            logger.info("fileSize: {}", metadata.getContentLength());

	    			            if(fileDupCnt != 0) {
	    			            	fileName = fileDupCnt.toString()+"_"+fileName;
	    			            }
	    			            logger.info("zipped FileName: {}", fileName);

	    			            zipOutputStream.putNextEntry(new ZipEntry(fileName));
	                            IOUtils.copy(s3ObjIs, zipOutputStream);

	                            s3ObjIs.close();
	                            zipOutputStream.closeEntry();

	                        	//byte[] bytes = IOUtils.toByteArray(s3ObjIs);

                        	//if(s3ObjIs!=null) { try { s3ObjIs.abort(); s3ObjIs.close();}catch (Exception e) {}}

                        	}

			            HttpHeaders headers = new HttpHeaders();
			            headers.add("Cache-Control", "no-cache, no-store, must-revalidate");
			            headers.add("Content-Disposition", "attachment; filename=" + zipFileName);
			            //headers.add("Content-Type", contentType);

			            headers.add("Pragma", "no-cache");
			            headers.add("Expires", "0");
			            headers.add("Last-Modified", new Date().toString());
			            headers.add("ETag", String.valueOf(System.currentTimeMillis()));


			            if (zipOutputStream != null) {
			                zipOutputStream.finish();
			                zipOutputStream.flush();
			                IOUtils.closeQuietly(zipOutputStream);
			            }

			            IOUtils.closeQuietly(bufferedOutputStream);
			            IOUtils.closeQuietly(byteArrayOutputStream);

			            return ResponseEntity.ok()
			                    .headers(headers)
			                    //.contentLength(metadata.getContentLength())
			                    .contentType(MediaType.APPLICATION_OCTET_STREAM )
			                    .body(byteArrayOutputStream.toByteArray());

					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
			            if (zipOutputStream != null) {
			                zipOutputStream.finish();
			                zipOutputStream.flush();
			                IOUtils.closeQuietly(zipOutputStream);
			            }
			            IOUtils.closeQuietly(bufferedOutputStream);
			            IOUtils.closeQuietly(byteArrayOutputStream);
						return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
					}

    }

    @RequestMapping(value= "/download-multi-file", method = RequestMethod.GET, produces="application/zip")
    public ResponseEntity<byte[]> gettDownloadMultiZipFile(
	    		@RequestParam(value= "dirKeyListJsonArr") String s3DirKeyListJsonArrString,
	    		HttpServletResponse response
    		) throws IOException {

		         String zipFileName = "zipfile.zip";
		         byte[] zipOutBytes =  null;
		         ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
		         BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(byteArrayOutputStream);
		         ZipOutputStream zipOutputStream = new ZipOutputStream(bufferedOutputStream);
		         HashMap<String,Integer> fileCheckMap = new HashMap<String,Integer>();

			        try {

			        	if(!isJSONArray(s3DirKeyListJsonArrString)) {
			        		//throw new Exception ("s3DirKeyListJsonArrString is not JSONArray!");
			        		return new ResponseEntity<>(null, HttpStatus.BAD_REQUEST);
			        	}

			        	JsonArray s3DirKeyListJsonArr = new JsonParser().parse(s3DirKeyListJsonArrString).getAsJsonArray();
			        	//s3ObjIs = service.downloadSingleFile(  dirName, fileId);

                        if(s3DirKeyListJsonArr.size()==0) {
                        	return new ResponseEntity<>(null, HttpStatus.BAD_REQUEST);
                        }
			        	//ObjectMetadata metadata =  service.objectMetaData(  dirName, fileId);
//			            logger.info("Content-Type: " + metadata.getContentType());
//			            Map<String, String> userMetaData = metadata.getUserMetadata();
//			            contentType =  metadata.getContentType();
//			            String fileName = userMetaData.get("actual-filename");
//			            logger.info("fileName: {}", fileName);
//			            logger.info("fileSize: {}", metadata.getContentLength());
//			            if(fileName.equals("")||fileName == null) {
//			            	throw new Exception ("No File Name");
//			            }
			            //InputStreamResource inputStreamResource = new InputStreamResource(s3ObjIs);
			            //InputStreamResource resource = new InputStreamResource(stream);
                        for(int i = 0; i< s3DirKeyListJsonArr.size(); i++){

                        	    Integer fileDupCnt = 0;

	    	    	        	JsonElement s3DirKeyListJsonElem = s3DirKeyListJsonArr.get(i);

	    	    	        	JsonObject s3DirKeyListJsonObj = s3DirKeyListJsonElem.getAsJsonObject();
	    	    	        	logger.debug(s3DirKeyListJsonObj.toString());

	    	    	        	String dirName       = s3DirKeyListJsonObj.get("dirName").getAsString();
	    	    	        	String fileId    = s3DirKeyListJsonObj.get("fileId").getAsString();

	                        	S3ObjectInputStream s3ObjIs  = awsService.downloadSingleFile(  dirName, fileId);
	                        	ObjectMetadata metadata =  awsService.objectMetaData(  dirName, fileId);

	    			            Map<String, String> userMetaData = metadata.getUserMetadata();
	    			            String contentType =  metadata.getContentType();
	    			            String fileName = userMetaData.get("actual-filename");

	    			            if(fileCheckMap.containsKey(fileName)) {

	    			            	fileDupCnt = fileCheckMap.get(fileName)+1;

	    			            	fileCheckMap.put(fileName,fileDupCnt);

	    			            }else {
	    			            	fileCheckMap.put(fileName,fileDupCnt);
	    			            }

	    			            logger.info("fileName: {}", fileName);
	    			            logger.info("contentType: {}", contentType);
	    			            logger.info("fileSize: {}", metadata.getContentLength());

	    			            if(fileDupCnt != 0) {
	    			            	fileName = fileDupCnt.toString()+"_"+fileName;
	    			            }
	    			            logger.info("zipped FileName: {}", fileName);

	    			            zipOutputStream.putNextEntry(new ZipEntry(fileName));
	                            IOUtils.copy(s3ObjIs, zipOutputStream);

	                            s3ObjIs.close();
	                            zipOutputStream.closeEntry();

	                        	//byte[] bytes = IOUtils.toByteArray(s3ObjIs);

                        	//if(s3ObjIs!=null) { try { s3ObjIs.abort(); s3ObjIs.close();}catch (Exception e) {}}

                        	}

			            HttpHeaders headers = new HttpHeaders();
			            headers.add("Cache-Control", "no-cache, no-store, must-revalidate");
			            headers.add("Content-Disposition", "attachment; filename=" + zipFileName);
			            //headers.add("Content-Type", contentType);

			            headers.add("Pragma", "no-cache");
			            headers.add("Expires", "0");
			            headers.add("Last-Modified", new Date().toString());
			            headers.add("ETag", String.valueOf(System.currentTimeMillis()));


			            if (zipOutputStream != null) {
			                zipOutputStream.finish();
			                zipOutputStream.flush();
			                IOUtils.closeQuietly(zipOutputStream);
			            }

			            IOUtils.closeQuietly(bufferedOutputStream);
			            IOUtils.closeQuietly(byteArrayOutputStream);

			            return ResponseEntity.ok()
			                    .headers(headers)
			                    //.contentLength(metadata.getContentLength())
			                    .contentType(MediaType.APPLICATION_OCTET_STREAM )
			                    .body(byteArrayOutputStream.toByteArray());

					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
			            if (zipOutputStream != null) {
			                zipOutputStream.finish();
			                zipOutputStream.flush();
			                IOUtils.closeQuietly(zipOutputStream);
			            }
			            IOUtils.closeQuietly(bufferedOutputStream);
			            IOUtils.closeQuietly(byteArrayOutputStream);
						return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
					}

    }

    public boolean isJSONArray(String test) {
        try {
            new JSONArray(test);
        } catch (JSONException ex) {

                return false;
        }
        return true;
    }

    public boolean isJSONObject(String test) {
        try {
            new JSONObject(test);
        } catch (JSONException ex) {

                return false;
        }
        return true;
    }

}