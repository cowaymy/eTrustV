package com.coway.trust.biz.api.impl;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.StopWatch;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.api.ChatbotSurveyMgmtApiService;
import com.coway.trust.biz.api.CommonApiService;
import com.coway.trust.biz.api.vo.CBTApiRespForm;
import com.coway.trust.biz.api.vo.ChatbotVO;
import com.coway.trust.biz.api.vo.HcSurveyResultCsvVO;
import com.coway.trust.biz.api.vo.HcSurveyResultForm;
import com.coway.trust.biz.api.vo.SurveyCategoryDto;
import com.coway.trust.biz.api.vo.SurveyCategoryVO;
import com.coway.trust.biz.api.vo.SurveyTargetAnsDto;
import com.coway.trust.biz.api.vo.SurveyTargetAnsVO;
import com.coway.trust.biz.api.vo.SurveyTargetQuesDto;
import com.coway.trust.biz.api.vo.SurveyTargetQuesVO;
import com.coway.trust.biz.application.impl.FileApplicationImpl;
import com.coway.trust.biz.misc.chatbotSurveyMgmt.impl.ChatbotSurveyMgmtMapper;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.SFTPUtil;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.Session;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("chatbotSurveyMgmtApiService")
public class ChatbotSurveyMgmtApiServiceImpl extends EgovAbstractServiceImpl implements ChatbotSurveyMgmtApiService{
	private static final Logger LOGGER = LoggerFactory.getLogger(FileApplicationImpl.class);

	@Resource(name = "ChatbotSurveyMgmtApiMapper")
	private ChatbotSurveyMgmtApiMapper chatbotSurveyMgmtApiMapper;

	@Resource(name = "commonApiService")
	private CommonApiService commonApiService;

	@Resource(name = "CommonApiMapper")
	private CommonApiMapper commonApiMapper;

	@Resource(name = "chatbotSurveyMgmtMapper")
	private ChatbotSurveyMgmtMapper chatbotSurveyMgmtMapper;

	private int cbtApiUserId = 7;

	@Value("${cbt.api.client.username}")
	private String CBTApiClientUser;

	@Value("${cbt.api.client.password}")
	private String CBTApiClientPassword;

	@Value("${cbt.api.url.domains}")
	private String CBTApiDomains;

	@Value("${cbt.api.url.ques}")
	private String CBTApiUrlQues;

	@Value("${cbt.api.url.surveyee}")
	private String CBTApiUrlSurveyee;

	@Value("${com.file.upload.path}")
	private String uploadFileDir;

	// SFTP
	@Value("${cbt.api.sftp.host}")
	private String CBTApiSftpHost;

	@Value("${cbt.api.sftp.port}")
	private int CBTApiSftpPort;

	@Value("${cbt.api.sftp.username}")
	private String CBTApiSftpUser;

	@Value("${cbt.api.sftp.password}")
	private String CBTApiSftpPassword;

	@Value("${cbt.api.sftp.surveyee.rootpath}")
	private String CBTApiSftpSurveyeeRootpath;

	@Value("${cbt.api.sftp.surveyResp.rootpath}")
	private String CBTApiSftpSurveyRespRootpath;

	@Override
	public Map<String, Object> pushSurveyQues(Map<String, Object> params, HttpServletRequest request) throws Exception{

		// Third Layer
		List<EgovMap> surveyCatDto = chatbotSurveyMgmtMapper.getSurveyCategoryList();
		List<EgovMap> surveyQuesDto = chatbotSurveyMgmtMapper.getSurveyTargetQuesList();
//		List<EgovMap> surveyAnsDto = chatbotSurveyMgmtMapper.getSurveyTargetAnsList();
		List<EgovMap> surveyAnsDto = null;

		if(surveyQuesDto.size() > 0){
			String[] surveyQuesArray= new String[surveyQuesDto.size()];

			for(int i = 0; i < surveyQuesDto.size(); i++){
				surveyQuesArray[i] = surveyQuesDto.get(i).get("survId").toString();
			}

			surveyAnsDto = chatbotSurveyMgmtMapper.getSurveyTargetAnsList(surveyQuesArray);
		}

		int surveyCatRecord = surveyCatDto.size();
		int surveyQuesRecord = surveyQuesDto.size();
		int surveyAnsRecord = surveyAnsDto == null ? 0 : surveyAnsDto.size();

		List<SurveyCategoryDto> sCat = new ArrayList<>();
		for(EgovMap catList : surveyCatDto){
	 		SurveyCategoryDto surveyCategoryList = SurveyCategoryDto.create(catList);
			sCat.add(surveyCategoryList);
		}

		List<SurveyTargetQuesDto> sTargetQues = new ArrayList<>();
		List<SurveyTargetAnsDto> sTargetAns = new ArrayList<>();

		if(surveyQuesDto.size() > 0){
    		for(EgovMap quesList : surveyQuesDto){
    			SurveyTargetQuesDto surveyTargetQuesList = SurveyTargetQuesDto.create(quesList);
    			sTargetQues.add(surveyTargetQuesList);
    		}

    		for(EgovMap ansList : surveyAnsDto){
    			SurveyTargetAnsDto surveyTargetAnsList = SurveyTargetAnsDto.create(ansList);
    			sTargetAns.add(surveyTargetAnsList);
    		}
		}

		// Second Layer
		SurveyCategoryVO surveyCategoryVO = new SurveyCategoryVO();
		surveyCategoryVO.setTotalRecord(surveyCatRecord);
		surveyCategoryVO.setData(sCat);

		SurveyTargetQuesVO surveyTargetQuesVO = new SurveyTargetQuesVO();
		surveyTargetQuesVO.setTotalRecord(surveyQuesRecord);
		surveyTargetQuesVO.setData(sTargetQues);

		SurveyTargetAnsVO surveyTargetAnsVO = new SurveyTargetAnsVO();
		surveyTargetAnsVO.setTotalRecord(surveyAnsRecord);
		surveyTargetAnsVO.setData(sTargetAns);

		// First Layer
		ChatbotVO chatbotVO = new ChatbotVO();
		chatbotVO.setSurveyCategory(surveyCategoryVO);
		chatbotVO.setSurveyTargetQues(surveyTargetQuesVO);
		chatbotVO.setSurveyTargetAns(surveyTargetAnsVO);

		GsonBuilder builder = new GsonBuilder();
		builder.serializeNulls();
		Gson gson = builder.setPrettyPrinting().create();
		String jsonString = gson.toJson(chatbotVO);

		Gson gson1 = new GsonBuilder().create();
	    String longJsonString = gson1.toJson(chatbotVO); // without beautify

		LOGGER.debug("Start Calling Chatbot API ....\n");

		// Call informNewMasterData
		String cbtUrl = CBTApiDomains + CBTApiUrlQues;

		EgovMap reqInfo = new EgovMap();
		reqInfo.put("jsonString", jsonString);
		reqInfo.put("cbtUrl", cbtUrl);
		reqInfo.put("longJsonString", longJsonString);

		Map<String, Object> resultValue = new HashMap<String, Object>();
		resultValue = cbtReqApi(reqInfo);

		LOGGER.debug("End Calling Chatbot API ....\n");

		LOGGER.debug("Start update is_sync ....\n");

		if(resultValue.containsKey("message") && resultValue.get("message").toString().equals("Success")){
    		EgovMap updInfo = new EgovMap();
    		updInfo.put("userId", params.get("userId"));

    		if(surveyQuesDto.size() > 0){
    			for(int i = 0; i < surveyQuesDto.size(); i++){
    				updInfo.put("survId", surveyQuesDto.get(i).get("survId"));

    				chatbotSurveyMgmtMapper.updateSync(updInfo);
    			}
    		}
		}

		LOGGER.debug("End update is_sync ....\n");

		return resultValue;
	}

	@Override
	public Map<String, Object> cbtReqApi(Map<String, Object> params){

		Map<String, Object> resultValue = new HashMap<String, Object>();
		resultValue.put("status", AppConstants.FAIL);
		resultValue.put("message", "CBT Failed: Please contact Administrator.");

		String respTm = null;

		// Uncomment if using BASIC AUTH
//		String auth = CBTApiClientUser + ":" + CBTApiClientPassword;
//		byte[] encodedAuth = 	Base64.getEncoder().encode(auth.getBytes(StandardCharsets.UTF_8));
//		String authorization = "Basic " + new String(encodedAuth);

		StopWatch stopWatch = new StopWatch();
	    stopWatch.reset();
	    stopWatch.start();

	    String cbtUrl = params.get("cbtUrl").toString();
		String jsonString = params.get("jsonString").toString();
		String output1 = "";

		CBTApiRespForm p = new CBTApiRespForm();

		try{
			URL url = new URL(cbtUrl);

			//insert to api0004m
			LOGGER.error("Start Calling CBT API .... " + cbtUrl + "......\n");
	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	        conn.setDoOutput(true);
	        conn.setRequestMethod("POST");
	        conn.setRequestProperty("Content-Type", "application/json");
	        conn.setRequestProperty("ClientId", CBTApiClientUser);
	        conn.setRequestProperty("ClientAccessToken", CBTApiClientPassword);
//	        conn.setRequestProperty("Authorization", authorization); // Uncomment if using BASIC AUTH
	        OutputStream os = conn.getOutputStream();
	        os.write(jsonString.getBytes());
	        os.flush();

	        LOGGER.error("Start Calling CBT API return......\n");
	        LOGGER.error("Start Calling CBT API return" + conn.getResponseMessage() + "......\n");

			if (conn.getResponseCode() != HttpURLConnection.HTTP_CREATED) {
				BufferedReader br = new BufferedReader(new InputStreamReader(
		                (conn.getInputStream())));
				conn.getResponseMessage();

		        String output = "";
		        LOGGER.debug("Output from Server .... \n");
		        while ((output = br.readLine()) != null) {
		        	output1 = output;
		        	LOGGER.debug(output);
		        }

		        Gson g = new Gson();
		        p = g.fromJson(output1, CBTApiRespForm.class);
		        if(p.isSuccess() == true){
		        	p.setStatusCode(AppConstants.RESPONSE_CODE_SUCCESS);
		        	resultValue.put("status", AppConstants.SUCCESS);
					resultValue.put("message", "Success");
		        }else{
		        	p.setStatusCode(AppConstants.RESPONSE_CODE_INVALID);
		        	resultValue.put("status", AppConstants.FAIL);
					resultValue.put("message", "Fail");
		        }

				conn.disconnect();

				br.close();
			}else{
				p.setStatusCode(AppConstants.RESPONSE_CODE_INVALID);
				p.setSuccess(false);
				resultValue.put("status", AppConstants.FAIL);
				resultValue.put("message", "No Response");
			}
		}catch(Exception e){
			LOGGER.error("Timeout:");
			LOGGER.error("[Chatbot API] - Caught Exception: " + e);
			p.setStatusCode(AppConstants.RESPONSE_CODE_TIMEOUT);
			p.setSuccess(false);
			resultValue.put("status", AppConstants.RESPONSE_CODE_TIMEOUT);
			resultValue.put("message", "Time Out");
		}finally{
			stopWatch.stop();
		    respTm = stopWatch.toString();

		    params.put("responseCode", resultValue.get("status") == null ? "" : resultValue.get("status").toString());
            params.put("responseMessage", resultValue.get("message") == null ? "" : resultValue.get("message").toString());
//            params.put("reqPrm", jsonString != null ? jsonString.length() >= 2000 ? jsonString.substring(0,2000) : jsonString : jsonString);
//            params.put("ipAddr", "");
            params.put("url", cbtUrl);
            params.put("respTm", respTm);
            params.put("resPrm", output1);
            params.put("apiUserId", cbtApiUserId);
            params.put("longReqPrm", params.get("longJsonString").toString());
//            params.put("refNo", params.get("memCode") == null ? params.get("username").toString() :params.get("memCode").toString());

            rtnRespMsg(params);
		}

		return resultValue;
	}

	@Override
	public Map<String,Object> hcSurveyResult(HttpServletRequest request, Map<String, Object> params) throws Exception {
	    String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0", sysUserId = "0";

	    Map<String, Object> resultValue = new HashMap<String, Object>();
		resultValue.put("status", AppConstants.FAIL);
		resultValue.put("message", "CBT Failed: Please contact Administrator.");

	    StopWatch stopWatch = new StopWatch();
	    stopWatch.reset();
	    stopWatch.start();

	    // Check file whether exist or not
    	String data = commonApiService.decodeJson(request);
    	Gson g = new Gson();
    	HcSurveyResultForm p = g.fromJson(data, HcSurveyResultForm.class);

    	Exception e1 = null;
    	if(p.getFileName().toString().isEmpty()){
    		resultValue.put("status", AppConstants.FAIL);
    		resultValue.put("message", "file name is required");
    		return resultValue;
    	}else if(!p.getFileName().toString().isEmpty() && !p.getFileName().toString().toUpperCase().contains("CSV")){
    		resultValue.put("status", AppConstants.FAIL);
    		resultValue.put("message", "file format is invalid");
    		return resultValue;
    	}
    	params.put("reqParam", data);

	    EgovMap authorize = verifyBasicAuth(params, request);

	    if(String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS).equals(authorize.get("code").toString())){
	    	// Create file in TO DIR
			String toRootPath = uploadFileDir + "/Chatbot/SurveyResponse"; // to dir
			String fileName = p.getFileName().toString();
			LOGGER.debug(">>> FileName :" + fileName);

			File file = new File(toRootPath + "/");

		    if (!file.exists()) {
                file.mkdirs();
            }

		    //===========================
		    // Connect SFTP and download file :: START
		    //===========================
		    try{
    		    // Connect SFTP and get csv file
    		    // Prepare data to access SFTP
    	    	String host = CBTApiSftpHost;
    			int port = CBTApiSftpPort;
    			String userName = CBTApiSftpUser;
    			String password = CBTApiSftpPassword;
    			String fromRootPath = CBTApiSftpSurveyRespRootpath; // from dir
    			boolean downloadSuccess = true;

    			// Connect sftp
    			SFTPUtil util = new SFTPUtil();
    			util.init(host, userName, password, port);

    			// download file
    			String path = toRootPath + "/"+ fileName;
    			LOGGER.debug(">>> downloadFileName :" + path);

    			boolean bl = util.download(fromRootPath, fileName, path);
    			if(!bl){
    				LOGGER.debug("Error file download : " + path);
    				downloadSuccess = false;
    			}

    			// disconnection
    			util.disconnection();

    			if(!downloadSuccess){
    				resultValue.put("status", AppConstants.FAIL);
    				resultValue.put("message", "Error download file from SFTP");
    				return resultValue;
    			}
		    }catch(Exception e){
		    	LOGGER.error("Timeout:");
				LOGGER.error("[Chatbot API] - Caught Exception: " + e);
				resultValue.put("status", AppConstants.RESPONSE_CODE_TIMEOUT);
				resultValue.put("message", "Unexpected Error");
				return resultValue;
		    }
		    //===========================
		    // Connect SFTP and download file :: END
		    //===========================

		    //======================================
		    // Read content of csv file :: START
		    //======================================
	    	List<HcSurveyResultCsvVO> hcSurveyResultCsvVO = new ArrayList<>();

	    	try{
    		    FileReader fr = new FileReader(file + "/" + fileName);

    		    BufferedReader br = new BufferedReader(fr);

    		    // Skip first row (Column header)
    		    br.readLine();

    		    String line = "";

    		    while ((line = br.readLine()) != null) {
    		    	String[] items = null;

    		    	int startResponse = line.indexOf("\"{\"");
    		    	int endResponse = line.indexOf("\"}\"");

    		    	if(startResponse > 0 && endResponse >0){
    		    		String response = line.substring(startResponse, endResponse);
    		    		String data2 = line.substring(0, startResponse);
    		    		String[] test = data2.split(",");

    		    		items = Arrays.copyOf(test, test.length+1);
    		    		items[test.length] = response;

    		    	}else{
    		    		 items = line.split(",");
    		    	}

    		    	if(items.length > 0 ){
        		    	HcSurveyResultCsvVO res = HcSurveyResultCsvVO.create(items);
        		    	hcSurveyResultCsvVO.add(res);
    		    	} else{
    		    		LOGGER.error("[Chatbot API] : No record found");
    					resultValue.put("status", "204");
    					resultValue.put("message", "No record from survey Response");
    					return resultValue;
    		    	}
    	        }
    		    br.close();
	    	}catch (Exception e){
	    		LOGGER.error("Timeout:");
				LOGGER.error("[Chatbot API] - Caught Exception: " + e);
				resultValue.put("status", AppConstants.RESPONSE_CODE_TIMEOUT);
				resultValue.put("message", "Unexpected Error");
				return resultValue;
	    	}
		    //======================================
		    // Read content of csv file :: END
		    //======================================


	    	//======================================
		    // Insert into CBT0005D :: START
		    //======================================
	    	if(hcSurveyResultCsvVO.size() > 0){
    	    	for(int i = 0; i < hcSurveyResultCsvVO.size() ; i ++){
    	    		chatbotSurveyMgmtApiMapper.insertSurveyResp(hcSurveyResultCsvVO.get(i));
    	    	}
	    	}
	    	//======================================
		    // Insert into CBT0005D :: END
		    //======================================

			resultValue.put("status", AppConstants.SUCCESS);
			resultValue.put("message", "Download Survey Response successful.");

	    }

	    return resultValue;

	}

	@Override
	public EgovMap verifyBasicAuth(Map<String, Object> params, HttpServletRequest request){

		String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0", sysUserId = "0";

	    StopWatch stopWatch = new StopWatch();
	    stopWatch.reset();
	    stopWatch.start();

//	    Uncomment this when use Basic Auth
//    	String authorization = request.getHeader("Authorization");
//    	String[] values = {"",""};
//
//    	if (authorization != null && authorization.startsWith("Basic")) {
//    		// Authorization: Basic base64credentials
//    		String base64Credentials = authorization.substring("Basic".length()).trim();
//    		byte[] credDecoded = Base64.getDecoder().decode(base64Credentials);
//    		String credentials = new String(credDecoded, StandardCharsets.UTF_8);
//    		// credentials = username:password
//    		values = credentials.split(":", 2);
//    	}

	    String userName = request.getHeader("userName");
	    String key = request.getHeader("key");

    	Exception e1 = null;

    	EgovMap access = new EgovMap();
    	Map<String, Object> reqPrm = new HashMap<>();
//    	reqPrm.put("userName", values[0]);
//    	reqPrm.put("key", values[1]);
    	reqPrm.put("userName", userName);
    	reqPrm.put("key", key);

    	access = chatbotSurveyMgmtApiMapper.checkAccess(reqPrm);

    	if(access == null){
    		code = String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED);
    		message = AppConstants.RESPONSE_DESC_UNAUTHORIZED;
    	}else{
    		code = String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS);
    		message = AppConstants.RESPONSE_DESC_SUCCESS;

    		apiUserId = access.get("apiUserId").toString();
    		sysUserId = access.get("sysUserId").toString();
    		reqPrm.put("apiUserId", apiUserId);
    		reqPrm.put("sysUserId", sysUserId);
    	}

    	stopWatch.stop();
    	respTm = stopWatch.toString();

  		return commonApiService.rtnRespMsg(request, code, message, respTm, params.get("reqParam").toString(), null,apiUserId);
	}


	@Transactional(propagation = Propagation.REQUIRES_NEW)
	@Override
	public void rtnRespMsg(Map<String, Object> param) {

	    EgovMap data = new EgovMap();
	    Map<String, Object> params = new HashMap<>();

	      params.put("respCde", param.get("responseCode"));
	      params.put("errMsg", param.get("responseMessage"));
//	      params.put("reqParam", param.get("reqPrm"));
//	      params.put("ipAddr", "");
	      params.put("prgPath", param.get("url"));
	      params.put("respTm", param.get("respTm"));
	      params.put("respParam", param.get("resPrm"));
	      params.put("apiUserId", param.get("apiUserId"));
	      params.put("longReqParam", String.valueOf(param.get("longReqPrm")));
//	      params.put("refNo", param.get("refNo"));

//	      commonApiMapper.insertApiAccessLog(params);
	      chatbotSurveyMgmtApiMapper.insertApiAccessLog(params);

	  }

}
