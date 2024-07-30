package com.coway.trust.biz.common.impl;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.DataOutputStream;
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
import org.json.JSONException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.api.CommonApiService;
import com.coway.trust.biz.common.WhatappsApiService;
import com.coway.trust.cmmn.model.WhatappsApiRespForm;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.SFTPUtil;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.Session;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("whatappsApiService")
public class WhatappsApiServiceImpl implements WhatappsApiService{
	private static final Logger LOGGER = LoggerFactory.getLogger(WhatappsApiServiceImpl.class);

	@Resource(name = "WhatappsApiMapper")
	private WhatappsApiMapper whatappsApiMapper;

	@Resource(name = "commonApiService")
	private CommonApiService commonApiService;

	@Value("${watapps.api.clientId}")
	private String waApiClientUser;

	@Value("${watapps.api.clientAccessToken}")
	private String waApiClientAccessToken;

	@Value("${watapps.api.url.domains}")
	private String waApiDomains;

	@Value("${watapps.api.country.code}")
	private String waApiCountryCode;

	@Value("${watapps.api.button.webUrl.domains}")
	 private String waApiBtnUrlDomains;

	@Value("${watapps.api.button.template}")
	private String waApiBtnTemplate;

	private int cbtApiUserId = 7;

	@Override
	public Map<String, Object> preBookWhatappsReqApi(Map<String, Object> params){
	  LOGGER.info("[preBookWhatappsReqApi] params :: {} " + params);

	  GsonBuilder builder = new GsonBuilder();
	  builder.serializeNulls();
    Gson gson = builder.setPrettyPrinting().create();
    String jsonString = gson.toJson(params);

    LOGGER.info("[preBookWhatappsReqApi] jsonString :: {} " + jsonString);
		Map<String, Object> resultValue = new HashMap<String, Object>();
		resultValue.put("status", AppConstants.FAIL);
		resultValue.put("message", "Whatapps Failed: Please contact Administrator.");

		String respTm = null;

		StopWatch stopWatch = new StopWatch();
	  stopWatch.reset();
	  stopWatch.start();

	  String waUrl = waApiDomains;
		String output1 = "";

		WhatappsApiRespForm p = new WhatappsApiRespForm();

		try{
			URL url = new URL(waUrl);

      //insert to API0004M
     	LOGGER.info("Start Calling Whatapps API .... " + waUrl + "......\n");
      HttpURLConnection conn = (HttpURLConnection) url.openConnection();
      conn.setDoOutput(true);
      conn.setRequestMethod("POST");
      conn.setRequestProperty("Content-Type", "application/json");
      conn.setRequestProperty("ClientId", waApiClientUser);
      conn.setRequestProperty("ClientAccessToken", waApiClientAccessToken);

      DataOutputStream os = new DataOutputStream(conn.getOutputStream());
      os.write(jsonString.getBytes());
      os.flush();
      os.close();

      LOGGER.info("Start Calling Whatapps API return......\n");
      LOGGER.info("Start Calling Whatapps API return" + conn.getResponseMessage() + "......\n");

			if (conn.getResponseCode() != HttpURLConnection.HTTP_CREATED) {
				    BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
				    conn.getResponseMessage();

		        String output = "";
		        LOGGER.info("Output from Server .... \n");
		        while ((output = br.readLine()) != null) {
		        	output1 = output;
		        	LOGGER.info(output);
		        }

		        Gson g = new Gson();
		        p = g.fromJson(output1, WhatappsApiRespForm.class);
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
			LOGGER.error("[Whatapps API] - Caught Exception: " + e);
			p.setStatusCode(AppConstants.RESPONSE_CODE_TIMEOUT);
			p.setSuccess(false);
			resultValue.put("status", AppConstants.RESPONSE_CODE_TIMEOUT);
			resultValue.put("message", "Time Out");
		}finally{
			  stopWatch.stop();
		    respTm = stopWatch.toString();

	      params.put("responseCode", resultValue.get("status") == null ? "" : resultValue.get("status").toString());
        params.put("responseMessage", resultValue.get("message") == null ? "" : resultValue.get("message").toString());
        params.put("url", waUrl);
        params.put("respTm", respTm);
        params.put("resPrm", output1);

       rtnRespMsg(params);
		}

		return resultValue;
	}

	public EgovMap verifyBasicAuth(Map<String, Object> params, HttpServletRequest request){
		String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0", sysUserId = "0";

	    StopWatch stopWatch = new StopWatch();
	    stopWatch.reset();
	    stopWatch.start();

	    String userName = request.getHeader("userName");
	    String key = request.getHeader("key");

    	Exception e1 = null;

    	EgovMap access = new EgovMap();
    	Map<String, Object> reqPrm = new HashMap<>();
    	reqPrm.put("userName", userName);
    	reqPrm.put("key", key);

    	access = whatappsApiMapper.checkAccess(reqPrm);

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
	public void rtnRespMsg(Map<String, Object> params2) {

	    EgovMap data = new EgovMap();
	    Map<String, Object> params = new HashMap<>();

	      params.put("respCde", params2.get("responseCode"));
	      params.put("errMsg", params2.get("responseMessage"));
	      params.put("prgPath", params2.get("url"));
	      params.put("respTm", params2.get("respTm"));
	      params.put("respParam", params2.get("resPrm"));
	      params.put("apiUserId", params2.get("apiUserId"));
	      params.put("longReqParam", String.valueOf(params2.get("longReqPrm")));
	      params.put("reqParam", params2.get("requestParam"));
	      System.out.print(params.get("reqParam"));

	      whatappsApiMapper.insertApiAccessLog(params);
	  }

	@Override
	public Map<String, Object> setWaTemplateConfiguration(Map<String, Object> params2) {

		// message
		Map<String, Object> msgMap = new HashMap();
		msgMap.put("type", AppConstants.WA_TYPE_TEMPLATE);

		// template
		Map<String, Object> templateMap = new HashMap();
		templateMap.put("template_name", params2.get("templateName"));
		templateMap.put("language", params2.get("language"));
		msgMap.put("template", templateMap);

		// data
		Map<String, Object> dataMap = new HashMap();

		dataMap.put("image_url", params2.get("imageUrl"));
		dataMap.put("video_url", params2.get("videoUrl"));
		dataMap.put("file_url", params2.get("fileUrl"));
		dataMap.put("body_params", params2.get("bodyParams"));
		dataMap.put("header", params2.get("header"));

		// buttons
		Map<String, Object> buttonsMap = new HashMap();
		String type = waApiBtnUrlDomains + params2.get("path");

		buttonsMap.put("type", type);
		buttonsMap.put("payload", params2.get("payload"));

		List<Map<String, Object>> btnList = new ArrayList<>();
		btnList.add(buttonsMap);
		dataMap.put("buttons", btnList);

		msgMap.put("data", dataMap);

		String telno = params2.get("telno").toString();
		if (params2.get("telno").toString().substring(0,2) != AppConstants.COUNTRY_CODE_MY)
			telno = AppConstants.CODE_MY + telno;

		// body
		Map<String, Object> params = new HashMap();
		params.put("platform", AppConstants.WA_PLATFORM);
		params.put("user_id", telno);
		params.put("message", msgMap);

		LOGGER.info("[WhatappsReqApi] params :: {} " + params);

		GsonBuilder builder = new GsonBuilder();
		builder.serializeNulls();
		builder.disableHtmlEscaping();
		Gson gson = builder.setPrettyPrinting().create();
		String jsonString = gson.toJson(params);

		LOGGER.info("[WhatappsReqApi] jsonString :: {} " + jsonString);
		Map<String, Object> resultValue = new HashMap<String, Object>();
		resultValue.put("status", AppConstants.FAIL);
		resultValue.put("message", "Whatapps Failed: Please contact Administrator.");

		String respTm = null;

		StopWatch stopWatch = new StopWatch();
		stopWatch.reset();
		stopWatch.start();

		String waUrl = waApiDomains;
		String output1 = "";

		WhatappsApiRespForm p = new WhatappsApiRespForm();

		try {
			URL url = new URL(waUrl);

			// insert to API0004M
			LOGGER.info("Start Calling Whatapps API .... " + waUrl + "......\n");
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setDoOutput(true);
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "application/json");
			conn.setRequestProperty("ClientId", waApiClientUser);
			conn.setRequestProperty("ClientAccessToken", waApiClientAccessToken);

			DataOutputStream os = new DataOutputStream(conn.getOutputStream());
			os.write(jsonString.getBytes());
			os.flush();
			os.close();

			LOGGER.info("Start Calling Whatapps API return......\n");
			LOGGER.info("Start Calling Whatapps API return" + conn.getResponseMessage() + "......\n");

			if (conn.getResponseCode() != HttpURLConnection.HTTP_CREATED) {
				BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
				conn.getResponseMessage();

				String output = "";
				LOGGER.info("Output from Server .... \n");
				while ((output = br.readLine()) != null) {
					output1 = output;
					LOGGER.info(output);
				}

				Gson g = new Gson();
				p = g.fromJson(output1, WhatappsApiRespForm.class);
				if (p.isSuccess() == true) {
					p.setStatusCode(AppConstants.RESPONSE_CODE_SUCCESS);
					resultValue.put("status", AppConstants.SUCCESS);
					resultValue.put("message", "Success");
				} else {
					p.setStatusCode(AppConstants.RESPONSE_CODE_INVALID);
					resultValue.put("status", AppConstants.FAIL);
					resultValue.put("message", p.getError());
				}

				conn.disconnect();

				br.close();
			} else {
				p.setStatusCode(AppConstants.RESPONSE_CODE_INVALID);
				p.setSuccess(false);
				resultValue.put("status", AppConstants.FAIL);
				resultValue.put("message", "No Response");
			}
		} catch (Exception e) {
			LOGGER.error("Timeout:");
			LOGGER.error("[Whatapps API] - Caught Exception: " + e);
			p.setStatusCode(AppConstants.RESPONSE_CODE_TIMEOUT);
			p.setSuccess(false);
			resultValue.put("status", AppConstants.RESPONSE_CODE_TIMEOUT);
			resultValue.put("message", "Time Out");
		} finally {
			stopWatch.stop();
			respTm = stopWatch.toString();
			Map<String, Object> apiLog = new HashMap();
			apiLog.put("requestParam", jsonString);
			apiLog.put("responseCode", resultValue.get("status") == null ? "" : resultValue.get("status").toString());
			apiLog.put("responseMessage",
					resultValue.get("message") == null ? "" : resultValue.get("message").toString());
			apiLog.put("url", waUrl);
			apiLog.put("respTm", respTm);
			apiLog.put("resPrm", output1);
			apiLog.put("apiUserId", cbtApiUserId);

			rtnRespMsg(apiLog);
		}

		return resultValue;
	}

}
