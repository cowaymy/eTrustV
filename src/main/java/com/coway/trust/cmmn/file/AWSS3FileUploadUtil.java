package com.coway.trust.cmmn.file;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FilenameUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AWSS3Service;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileUtil;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.util.EgovWebUtil;
import com.coway.trust.util.MimeTypeUtil;
import com.coway.trust.util.UUIDGenerator;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

/**
 * @Class Name : AWSS3FileUploadUtil.java
 * @Description : Spring Based S3 File Upload Utils
 * @Modification Information
 *
 * Modif User Change Contents ------- -------- --------------------------- 2021.07.05 Kevin
 *
 * @author Kevin
 * @since 2021.08.26
 * @version 1.0
 * @see
 */
@Component
public class AWSS3FileUploadUtil{
	/**
	 * 파일을 Upload 처리한다.
	 *
	 * @param request
	 * @param uploadPath
	 * @param subPath
	 * @param maxFileSize
	 * @return
	 * @throws Exception
	 */

    @Autowired
    private AWSS3Service awsservice;

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/*public List<EgovFormBasedFileVo> uploadFiles(HttpServletRequest request, String uploadPath, String subPath,
			final long maxFileSize) throws Exception {
		return uploadFiles(request, uploadPath, subPath, maxFileSize, false);
	}*/

	/**
	 * 파일을 Upload 처리한다.
	 *
	 * @param request
	 * @param uploadPath
	 * @param subPath
	 * @param maxFileSize
	 * @param addExtension
	 *            : application-xxx.properties 의 web.resource.upload.file(resource 접근 가능 파일 경로) 를 참조한 경우 확장자가 있어야지만 바로 열
	 *            수 있다.
	 * @return
	 * @throws Exception
	 */
	/*public List<EgovFormBasedFileVo> uploadFiles(HttpServletRequest request, String uploadPath, String subPath,
			final long maxFileSize, boolean addExtension) throws Exception {
		List<EgovFormBasedFileVo> list = new ArrayList<>();

		Gson gson = new Gson();
	    Map<String, Object> params  = new HashMap<>();
	    JsonArray  fileContentsArr  = new JsonArray();
        boolean contentsCheck = false;
        String oRtnCode;
        String oRtnMsg;
		try {
			//TH Project

			   MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest) request;
			   //Iterator<?> fileIter = mptRequest.getFileNames();

			   //Map<String, MultipartFile>   =  mptRequest.getFileNames();

	           Map<String, String[]> parameterMap = request.getParameterMap();
	           parameterMap.forEach((key,value) -> { params.put(key, value[0]); });

	           Map<String, MultipartFile> fileMap = mptRequest.getFileMap();

	           Collection < MultipartFile > values = fileMap.values();
	           MultipartFile[] filesArr = values.toArray(new MultipartFile[values.size()]);




	           if(params.containsKey("fileContentsArr")) {
	        	   fileContentsArr  = gson.fromJson(params.get("fileContentsArr").toString(),JsonArray.class);
	           }
	             logger.info("Iterators.size(fileIter):{}",filesArr.length);
	           if(fileContentsArr.size() == filesArr.length) {
	        	   contentsCheck = true;
	           }
	         logger.info("contentsCheck):{}-{}-{}",contentsCheck,fileContentsArr.size(),filesArr.length);

	        // Change to boring for loop cuz need to use index
             //while (fileIter.hasNext()) {
	           for(int i = 0; i < filesArr.length; i++) {
				//MultipartFile mFile = mptRequest.getFile((String) fileIter.next());

        	   MultipartFile mFile = filesArr[i];

				if (mFile.getSize() > maxFileSize) {
					throw new ApplicationException(AppConstants.FAIL,
							CommonUtils.getBean("messageSourceAccessor", MessageSourceAccessor.class).getMessage(
									AppConstants.MSG_FILE_MAX_LIMT,
									new Object[] { CommonUtils.formatFileSize(maxFileSize) }));
				}

				EgovFormBasedFileVo vo = new EgovFormBasedFileVo();

				String tmp = mFile.getOriginalFilename();

				if (tmp.lastIndexOf("\\") >= 0) {
					tmp = tmp.substring(tmp.lastIndexOf("\\") + 1);
				}

				String blackUploadPath = EgovWebUtil.filePathBlackList(uploadPath);
				String blackSubPath = EgovWebUtil.filePathBlackList(subPath);

				vo.setFileName(tmp);
				vo.setContentType(mFile.getContentType());
				vo.setServerPath(blackUploadPath);
				vo.setServerSubPath(blackSubPath);

				String physicalName = getPhysicalFileName();

//				if (addExtension) {
//					physicalName = physicalName + "." + FilenameUtils.getExtension(tmp).toLowerCase();
//				}

				vo.setPhysicalName(physicalName);
				vo.setSize(mFile.getSize());
				vo.setExtension(FilenameUtils.getExtension(tmp).toLowerCase());

				int seq             = 0;
				String contentsType = "";
				String fileName     = "";

				if(contentsCheck) {
					JsonObject fileContents = fileContentsArr.get(i).getAsJsonObject();

					logger.info("fileContents:,{}",fileContents.toString());

					seq          = fileContents.get("seq").getAsInt();
					contentsType = fileContents.get("contentsType").getAsString();
					fileName     = fileContents.get("fileName").getAsString();

					logger.info("seq:{}, i+1:{},tmp:{},fileName:{}",seq,i+1,tmp,fileName);

					if(seq == (i+1) && tmp.equals(fileName)) {
						vo.setFileContentsType(contentsType);
					}else {

					    // it is possible that JsonArray is not organaized as same as iterator)
					    for(int j = 0; j < fileContentsArr.size(); j++) {
					    	fileContents = fileContentsArr.get(j).getAsJsonObject();

					    	if(fileContents.get("fileName").getAsString().equals(tmp)){
					    		vo.setFileContentsType(fileContents.get("contentsType").getAsString());
					    	}
					    }

					}

					if(vo.getFileContentsType()==null) {
						logger.warn("Should check again");
						vo.setFileContentsType("COM");
					}

				}else {
					logger.warn("Should check again");
					vo.setFileContentsType("COM");
				}

				if (mFile.getSize() > 0) {
					InputStream is = null;

					try {
						is = mFile.getInputStream();

						if (MimeTypeUtil.isNotAllowFile(is)) {
							throw new ApplicationException(AppConstants.FAIL,
									mFile.getOriginalFilename() + AppConstants.MSG_IS_NOT_ALLOW);
						}
						JsonObject rtnJson = awsservice.uploadFile(subPath, mFile,physicalName);

			             oRtnCode          = rtnJson.get("oRtnCode").getAsString();
			             oRtnMsg           = rtnJson.get("oRtnMsg").getAsString();

			             if(!oRtnCode.equals("TRUE")) {
			                 logger.error("File upload is failed with reason:{}",oRtnMsg);
			                 throw new Exception("File upload is failed with reason:"+oRtnMsg);
			             }else {
			                 logger.info("File upload is completed.");
			             }
						list.add(vo);

//						saveFile(is, new File(EgovWebUtil.filePathBlackList(vo.getServerPath() + SEPERATOR
//								+ vo.getServerSubPath() + SEPERATOR + vo.getPhysicalName())));
					}catch(Exception e) {
						logger.error("Exception : AWSS3FileUploadUtil.uploadFiles "+e.getMessage());
						e.printStackTrace();

					}finally {
						if (is != null) {
							is.close();
						}
					}

				}
			}

			return list;
		}catch(Exception e) {
			logger.error("Exception : AWSS3FileUploadUtil.uploadFiles "+e.getMessage());
			e.printStackTrace();
			return list;
		}

	}*/

	public static String getPhysicalFileName() {
		return UUIDGenerator.get().toUpperCase();
	}

}
