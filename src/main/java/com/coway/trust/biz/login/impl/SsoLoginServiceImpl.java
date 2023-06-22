/*
 * Copyright 2008-2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.coway.trust.biz.login.impl;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.atomic.AtomicInteger;

import javax.annotation.Resource;
import javax.net.ssl.HttpsURLConnection;

import org.apache.commons.lang3.time.StopWatch;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.api.project.LMS.LMSApiRespForm;
import com.coway.trust.biz.api.impl.CommonApiMapper;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.impl.FileMapper;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.login.LoginHistory;
import com.coway.trust.biz.login.LoginService;
import com.coway.trust.biz.login.SsoLoginService;
import com.coway.trust.biz.login.LoginService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.LoginSubAuthVO;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.login.SsoLoginApiRespForm;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.stream.JsonReader;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import springfox.documentation.spring.web.json.Json;

@Service("ssoLoginService")
public class SsoLoginServiceImpl implements SsoLoginService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SsoLoginServiceImpl.class);

	@Autowired
	private LoginMapper loginMapper;

	@Autowired
	private AdaptorService adaptorService;

	@Autowired
    private FileService fileService;

	@Autowired
    private FileMapper fileMapper;

	@Autowired
    private MessageSourceAccessor messageAccessor;

	@Resource(name = "CommonApiMapper")
	  private CommonApiMapper commonApiMapper;

	private int ssoApiUserId = 4;

	@Value("${sso.api.url.token}")
	private String ssoUrlToken;

	@Value("${sso.api.url.api}")
	private String ssoUrlApi;

	@Value("${sso.api.master.clientSecret}")
	private String ssoMasterSecret;

	@Value("${sso.api.master.clientId}")
	private String ssoMasterClient;

	@Value("${sso.api.master.username}")
	private String ssoMasterUsername;

	@Value("${sso.api.master.password}")
	private String ssoMasterPasswd;

	@Override
	public Map<String, Object> ssoCreateUser(Map<String, Object> params)   {
		LOGGER.debug("ssoCreateUser");

		Map<String,Object> adminAccessTokenMap = getAdminAccessToken(params) ;
		if(adminAccessTokenMap.get("status").toString().equals(AppConstants.FAIL)){
			throw new ApplicationException(AppConstants.FAIL, messageAccessor.getMessage("member.msg.ssoErr"));
		}
		String adminAccessToken = adminAccessTokenMap.get("adminAccessToken").toString();

		Map<String, Object> userParams = new HashMap<String, Object>();
		userParams.put("_USER_ID", params.get("memCode").toString());
		LoginVO userLoginVO = loginMapper.selectLoginInfoById(userParams);

		Map<String, Object> userInfo = new HashMap<String, Object>();
		userInfo.put("bearer", adminAccessToken);
		userInfo.put("username", userLoginVO.getUserName());
		userInfo.put("userPass", userLoginVO.getUserPassWord());
		userInfo.put("userEmail", userLoginVO.getUserEmail());
		userInfo.put("userFullName", userLoginVO.getUserFullname());
		Map<String,Object> userCreationMap = userCreation(userInfo) ;

		Map<String,Object> userActiveMap = new HashMap<String, Object>();
		if(userCreationMap.get("status").toString().equals(AppConstants.FAIL)){
//			userActiveMap.put("status", AppConstants.FAIL);
			throw new ApplicationException(AppConstants.FAIL, messageAccessor.getMessage("member.msg.ssoErr"));
		}

		return userCreationMap;
	}

	@Override
	public Map<String, Object> ssoUpdateUserStatus(Map<String, Object> params)  {
		LOGGER.debug("ssoUpdateUserStatus");

		Map<String,Object> adminAccessTokenMap = getAdminAccessToken(params) ;
		if(adminAccessTokenMap.get("status").toString().equals(AppConstants.FAIL)){
			throw new ApplicationException(AppConstants.FAIL, messageAccessor.getMessage("member.msg.ssoErr"));
		}
		String adminAccessToken = adminAccessTokenMap.get("adminAccessToken").toString();

		Map<String, Object> usernameParams = new HashMap<String, Object>();
		usernameParams.put("bearer", adminAccessToken);
		usernameParams.put("username", params.get("memCode").toString());
		Map<String,Object> userIdMap = getUserId(usernameParams) ;

		Map<String,Object> userActiveMap = new HashMap<String, Object>();
		if(userIdMap.get("status").toString().equals(AppConstants.FAIL)){
			userActiveMap.put("status", AppConstants.FAIL);
		}else{
			usernameParams.put("keycloakUserId", userIdMap.get("keycloakUserId").toString());
			usernameParams.put("enabled", params.get("enabled").toString());
			userActiveMap = userActivateDeactivate(usernameParams) ;
		}

		return userActiveMap;

	}

	@Override
	public Map<String, Object> ssoDeleteUserStatus(Map<String, Object> params)  {
		LOGGER.debug("ssoDeleteUserStatus");

		Map<String,Object> adminAccessTokenMap = getAdminAccessToken(params) ;
		if(adminAccessTokenMap.get("status").toString().equals(AppConstants.FAIL)){
			throw new ApplicationException(AppConstants.FAIL, messageAccessor.getMessage("member.msg.ssoErr"));
		}
		String adminAccessToken = adminAccessTokenMap.get("adminAccessToken").toString();

		Map<String, Object> usernameParams = new HashMap<String, Object>();
		usernameParams.put("bearer", adminAccessToken);
		usernameParams.put("username", params.get("memCode").toString());
		Map<String,Object> userIdMap = getUserId(usernameParams) ;

		Map<String,Object> userActiveMap = new HashMap<String, Object>();
		if(userIdMap.get("status").toString().equals(AppConstants.FAIL)){
			userActiveMap.put("status", AppConstants.FAIL);
		}else{
			usernameParams.put("keycloakUserId", userIdMap.get("keycloakUserId").toString());
			userActiveMap = userDelete(usernameParams) ;
		}

		return userActiveMap;

	}

	@Override
	public Map<String, Object> ssoUpdateUserInfo(Map<String, Object> params)  {
		LOGGER.debug("ssoUpdateUserStatus");

		Map<String,Object> adminAccessTokenMap = getAdminAccessToken(params) ;
		if(adminAccessTokenMap.get("status").toString().equals(AppConstants.FAIL)){
			throw new ApplicationException(AppConstants.FAIL, messageAccessor.getMessage("member.msg.ssoErr"));
		}
		String adminAccessToken = adminAccessTokenMap.get("adminAccessToken").toString();

		Map<String, Object> usernameParams = new HashMap<String, Object>();
		usernameParams = params;
		usernameParams.put("bearer", adminAccessToken);
		usernameParams.put("username", params.get("memCode").toString().trim());
		Map<String,Object> userIdMap = getUserId(usernameParams) ;

		Map<String,Object> userActiveMap = new HashMap<String, Object>();
		if(userIdMap.get("status").toString().equals(AppConstants.FAIL)){
			userActiveMap.put("status", AppConstants.FAIL);
		}else{
			usernameParams.put("keycloakUserId", userIdMap.get("keycloakUserId").toString());
			userActiveMap = userInfoUpdate(usernameParams) ;
		}

		return userActiveMap;
	}

	@Override
	public Map<String, Object> ssoUpdateUserPassword(Map<String, Object> params)  {
		LOGGER.debug("ssoUpdateUserStatus");

		Map<String,Object> adminAccessTokenMap = getAdminAccessToken(params) ;
		if(adminAccessTokenMap.get("status").toString().equals(AppConstants.FAIL)){
			throw new ApplicationException(AppConstants.FAIL, messageAccessor.getMessage("member.msg.ssoErr"));
		}
		String adminAccessToken = adminAccessTokenMap.get("adminAccessToken").toString();

		Map<String, Object> usernameParams = new HashMap<String, Object>();
		usernameParams.put("bearer", adminAccessToken);
		usernameParams.put("username", params.get("memCode").toString());
		Map<String,Object> userIdMap = getUserId(usernameParams) ;

		Map<String,Object> userActiveMap = new HashMap<String, Object>();
		if(userIdMap.get("status").toString().equals(AppConstants.FAIL)){
			userActiveMap.put("status", AppConstants.FAIL);
		}else{
			usernameParams.put("keycloakUserId", userIdMap.get("keycloakUserId").toString());
			usernameParams.put("userPass", params.get("password").toString());
			userActiveMap = userResetPassword(usernameParams) ;

			usernameParams.put("enabled", "true");
			userActiveMap = userActivateDeactivate(usernameParams) ;
		}

		return userActiveMap;
	}

	@Override
	public LoginVO selectSSOcredential(Map<String, Object> params)  {
		LOGGER.debug("selectSSOcredential");

		String respTm = null;
		String lmsApiUserId = "3";

		//get Admin access token
		Map<String,Object> adminAccessTokenMap = getAdminAccessToken(null) ;
		if(adminAccessTokenMap.get("status").toString().equals(AppConstants.FAIL)){
			throw new ApplicationException(AppConstants.FAIL, messageAccessor.getMessage("member.msg.ssoErr"));
		}
		String adminAccessToken = adminAccessTokenMap.get("adminAccessToken").toString();

		//admin create normal user
		Map<String, Object> userParams = new HashMap<String, Object>();
//		userParams.put("_USER_ID", "CD105302");
		userParams.put("_USER_ID", params.get("userIdFindPopTxt"));
		LoginVO userLoginVO = loginMapper.selectLoginInfoById(userParams);

		Map<String, Object> userInfo = new HashMap<String, Object>();
		userInfo.put("bearer", adminAccessToken);
		userInfo.put("username", userLoginVO.getUserName());
		userInfo.put("userPass", userLoginVO.getUserPassWord());
		userInfo.put("userEmail", userLoginVO.getUserEmail());
		userInfo.put("userFullName", userLoginVO.getUserFullname());
		Map<String,Object> userCreationMap = userCreation(userInfo) ;


		//get normal user id using username
		/*Map<String, Object> usernameParams = new HashMap<String, Object>();
		usernameParams.put("bearer", adminAccessToken);
		usernameParams.put("username", params.get("userIdFindPopTxt"));
		Map<String,Object> userIdMap = getUserId(usernameParams) ;*/

		//normal user reset password
		/*usernameParams.put("keycloakUserId", userIdMap.get("keycloakUserId").toString());
		usernameParams.put("userPass", "admin1234");
		Map<String,Object> userResetPasswordMap = userResetPassword(usernameParams);*/

		//activate or deactivate user
		/*usernameParams.put("keycloakUserId", userIdMap.get("keycloakUserId").toString());
		usernameParams.put("enabled", false);
		Map<String,Object> userActiveMap = userActivateDeactivate(usernameParams) ;*/


		LoginVO loginVO = loginMapper.selectFindUserIdPop(params);
		return loginVO;
	}

	@Override
    public Map<String, Object> getAdminAccessToken(Map<String, Object> params) {
		Map<String,Object> returnParams = new HashMap<String, Object>();
		String adminAccessToken = "";

		String respTm = null;
		StopWatch stopWatch = new StopWatch();
	    stopWatch.reset();
	    stopWatch.start();

		String ssoUrl = ssoUrlToken + "/protocol/openid-connect/token/";
		String output1 = "";
		SsoLoginApiRespForm p = new SsoLoginApiRespForm();
		try{
			URL url = new URL(ssoUrl);
			//URL url = new URL(null, ssoUrl, new sun.net.www.protocol.https.Handler());

			//insert to api0004m
			//
			LOGGER.error("Start Calling keycloak API ...." + ssoUrl + "......\n");
	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	        conn.disconnect();

	        conn.setDoOutput(true);
	        conn.setRequestMethod("POST");
	        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
	        //conn.setRequestProperty("Authorization", authorization);
	        conn.setRequestProperty("client_id", ssoMasterClient);
	        conn.setRequestProperty("username", ssoMasterUsername);
	        conn.setRequestProperty("password", ssoMasterPasswd);
	        conn.setRequestProperty("grant_type", "password");
	        conn.setRequestProperty("client_secret", ssoMasterSecret);
	        /*if (params != null && params.size() > 0) {
	        	for(int i = 0 ; i < params.size() ; i++){
	        		params.get(i)
	        	}
	            Iterator<String> it = headers.keySet().iterator();
	            while (it.hasNext()) {
	                String key = it.next();
	                String value = headers.get(key);
	                httpConn.setRequestProperty(key, value);
	            }
	        }*/

	        conn.connect();
	        DataOutputStream out = new DataOutputStream(conn.getOutputStream());
	        String credentialsStr = "client_id="
	        		+ ssoMasterClient
	        		+ "&username="
	        		+ ssoMasterUsername
	        		+ "&password="
	        		+ ssoMasterPasswd
	        		+ "&grant_type=password&client_secret="
	        		+ ssoMasterSecret;
	        out.writeBytes(credentialsStr);
	        //OutputStream os = conn.getOutputStream();
	        //os.write(jsonString.getBytes());
	        out.flush();
	        out.close();

	        LOGGER.error("Start Calling keycloak API return......\n");
	        LOGGER.error("Start Calling keycloak API return" + conn.getResponseMessage() + "......\n");

	        InputStream inputStream;
	        if (conn.getResponseCode() == 200) {
	            inputStream = conn.getInputStream();
	            returnParams.put("status", AppConstants.SUCCESS);
	            returnParams.put("msg", "");
	        } else {
	            inputStream = conn.getErrorStream();
	            returnParams.put("status", AppConstants.FAIL);
	        }

			if (conn.getResponseCode() != HttpURLConnection.HTTP_CREATED) {
				BufferedReader br = new BufferedReader(new InputStreamReader(
		                (conn.getInputStream())));
				//conn.getResponseMessage();
				// BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));


		        String output = "";
		        LOGGER.debug("Output from Server .... \n");
		        while ((output = br.readLine()) != null) {
		        	output1 = output;
		        	LOGGER.debug(output);
		        	returnParams.put("msg", output);
		        }

		        Gson g = new Gson();
		        p = g.fromJson(output1, SsoLoginApiRespForm.class);

		        LOGGER.error("Start Calling keycloak API return LoginApiRespForm" + p.toString() + "......\n");
		        LOGGER.error("Start Calling keycloak API return getAccess_token : " + p.getAccess_token() + "......\n");
		        returnParams.put("adminAccessToken", p.getAccess_token());
		        //adminAccessToken = p.getAccess_token();
		        /*String msg = p.getMessage() != null ? "LMS: " + p.getMessage().toString() : "";
		        if(p.getStatus() ==null || p.getStatus().isEmpty()){
		        	p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
//		        	resultValue.put("status", AppConstants.FAIL);
//					resultValue.put("message", msg);
		        }else if(p.getStatus().equals("true")){
		        	p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS));
//		        	resultValue.put("status", AppConstants.SUCCESS);
//					resultValue.put("message", msg);
		        }else{
//		        	resultValue.put("status", AppConstants.FAIL);
//					resultValue.put("message", msg);
		        	p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
		        }*/
				conn.disconnect();

				br.close();
			}else{
//				resultValue.put("status", AppConstants.FAIL);
//				resultValue.put("message", "No Response");
//				p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
//				p.setMessage("No Response");
			}
		}catch(Exception e){
			LOGGER.error("Timeout:");
			LOGGER.error("[keycloak] - Caught Exception: " + e);
			returnParams.put("status", AppConstants.FAIL);
//			resultValue.put("status", AppConstants.RESPONSE_CODE_TIMEOUT);
//			p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_TIMEOUT));
//			p.setStatus(String.valueOf(AppConstants.RESPONSE_CODE_TIMEOUT));
//			p.setMessage("Timeout " + e.toString());
		}finally{
			stopWatch.stop();
		    respTm = stopWatch.toString();

		    params.put("responseCode", returnParams.get("status") == null ? "" : returnParams.get("status").toString());
            params.put("responseMessage", returnParams.get("msg") == null ? "" : returnParams.get("msg").toString());
            params.put("reqPrm", "getAdminAccessToken");
            params.put("ipAddr", "");
            params.put("url", ssoUrl);
            params.put("respTm", respTm);
            params.put("resPrm", output1);
            params.put("apiUserId", ssoApiUserId);
            params.put("refNo", params.get("memCode") == null ? params.get("username").toString() :params.get("memCode").toString());

			rtnRespMsg(params);

			return returnParams;
		}
    }

	@Override
    public Map<String, Object> userCreation(Map<String, Object> params) {
		Map<String,Object> returnParams = new HashMap<String, Object>();
		String adminAccessToken = "";

		String respTm = null;
		StopWatch stopWatch = new StopWatch();
	    stopWatch.reset();
	    stopWatch.start();

		String ssoUrl = ssoUrlApi + "/users";
		String jsonString = "";
		//String jsonString = params.get("jsonString").toString();
		//String refNo = params.get("refNo").toString();
		String output1 = "";
		SsoLoginApiRespForm p = new SsoLoginApiRespForm();
		try{
			URL url = new URL(ssoUrl);

			//insert to api0004m
			//
			LOGGER.error("Start Calling keycloak API ...." + ssoUrl + "......\n");
			HttpURLConnection conn1 = (HttpURLConnection) url.openConnection();
			conn1.disconnect();
	        conn1.setDoOutput(true);
	        conn1.setRequestMethod("POST");
	        conn1.setRequestProperty("Content-Type", "application/json");
	        conn1.setRequestProperty("Authorization", "Bearer " + params.get("bearer").toString());

	        /*if (params != null && params.size() > 0) {
	        	for(int i = 0 ; i < params.size() ; i++){
	        		params.get(i)
	        	}
	            Iterator<String> it = headers.keySet().iterator();
	            while (it.hasNext()) {
	                String key = it.next();
	                String value = headers.get(key);
	                httpConn.setRequestProperty(key, value);
	            }
	        }*/

	        conn1.connect();
	        DataOutputStream out = new DataOutputStream(conn1.getOutputStream());
//	        String jsonString = "{\"enabled\": true,\"username\": \"trytest\",\"email\": \"trytest@gmail.com\",\"firstName\": \"trytest\",\"lastName\": \"trytest\",\"credentials\": [{\"type\": \"password\",\"value\": \"abc123\",\"temporary\": false}]}";
	        jsonString = "{\"enabled\": true,\"username\": \"" + params.get("username").toString()
	        		+ "\",\"email\": \"" + params.get("userEmail").toString()
	        		+ "\",\"firstName\": \"" + params.get("userFullName").toString()
	        		+ "\",\"credentials\": [{\"type\": \"password\",\"value\": \"" +  params.get("userPass").toString()
	        		+ "\",\"temporary\": false}]}";
	        //out.writeBytes(credentialsStr);
	        //OutputStream os = conn1.getOutputStream();
	        out.write(jsonString.getBytes());
	        out.flush();
	        out.close();

	        LOGGER.error("Start Calling keycloak API return......\n");
	        LOGGER.error("Start Calling keycloak API return getResponseCode " + conn1.getResponseCode() + "......\n");
	        LOGGER.error("Start Calling keycloak API return getResponseMessage " + conn1.getResponseMessage() + "......\n");

	        InputStream inputStream;
	        if (conn1.getResponseCode() == HttpURLConnection.HTTP_CREATED) {
	            inputStream = conn1.getInputStream();
	            returnParams.put("status", AppConstants.SUCCESS);
	            returnParams.put("msg", AppConstants.SUCCESS);
	            conn1.disconnect();
	        } else {
	            inputStream = conn1.getErrorStream();
	            returnParams.put("status", AppConstants.FAIL);
	            returnParams.put("msg", AppConstants.FAIL);
	        }

			if (conn1.getResponseCode() != HttpURLConnection.HTTP_CREATED) {
				BufferedReader br = new BufferedReader(new InputStreamReader(
		                (inputStream)));
				//conn1.getResponseMessage();
				// BufferedReader in = new BufferedReader(new InputStreamReader(conn1.getInputStream()));


		        String output = "";
		        LOGGER.debug("Output from Server .... \n");
		        while ((output = br.readLine()) != null) {
		        	output1 = output;
		        	LOGGER.debug(output);
		        }

		        Gson g = new Gson();
		        p = g.fromJson(output1, SsoLoginApiRespForm.class);

		        LOGGER.error("Start Calling keycloak API return LoginApiRespForm" + p.toString() + "......\n");

		        //adminAccessToken = p.getAccess_token();
		        /*String msg = p.getMessage() != null ? "LMS: " + p.getMessage().toString() : "";
		        if(p.getStatus() ==null || p.getStatus().isEmpty()){
		        	p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
//		        	resultValue.put("status", AppConstants.FAIL);
//					resultValue.put("message", msg);
		        }else if(p.getStatus().equals("true")){
		        	p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS));
//		        	resultValue.put("status", AppConstants.SUCCESS);
//					resultValue.put("message", msg);
		        }else{
//		        	resultValue.put("status", AppConstants.FAIL);
//					resultValue.put("message", msg);
		        	p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
		        }*/
				conn1.disconnect();

				br.close();
			}else{
//				resultValue.put("status", AppConstants.FAIL);
//				resultValue.put("message", "No Response");
//				p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
//				p.setMessage("No Response");
			}
		}catch(Exception e){
			LOGGER.error("Timeout:");
			LOGGER.error("[keycloak] - Caught Exception: " + e);
			returnParams.put("status", AppConstants.FAIL);
//			resultValue.put("status", AppConstants.RESPONSE_CODE_TIMEOUT);
//			p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_TIMEOUT));
//			p.setStatus(String.valueOf(AppConstants.RESPONSE_CODE_TIMEOUT));
//			p.setMessage("Timeout " + e.toString());
		}finally{
			stopWatch.stop();
		    respTm = stopWatch.toString();

		    params.put("responseCode", returnParams.get("status") == null ? "" : returnParams.get("status").toString());
            params.put("responseMessage", returnParams.get("msg") == null ? "" : returnParams.get("msg").toString());
            params.put("reqPrm", jsonString);
            params.put("ipAddr", "");
            params.put("url", ssoUrl);
            params.put("respTm", respTm);
            params.put("resPrm", output1);
            params.put("apiUserId", ssoApiUserId);
            params.put("refNo", params.get("memCode") == null ? params.get("username").toString() :params.get("memCode").toString());

			rtnRespMsg(params);

			return returnParams;
//			commonApiService.rtnRespMsg(ssoUrl, p.getCode().toString(), p.getMessage().toString(),respTm , jsonString, output1 ,lmsApiUserId, refNo);
		}
    }

	@Override
    public Map<String, Object> getUserId(Map<String, Object> params) {
		Map<String,Object> returnParams = new HashMap<String, Object>();
		String adminAccessToken = "";

		String respTm = null;
		StopWatch stopWatch = new StopWatch();
	    stopWatch.reset();
	    stopWatch.start();

//		String ssoUrl = "https://coway-keycloak-uat.aleph-labs.tech/auth/admin/realms/coway-agent/users/";
		String ssoUrl = ssoUrlApi + "/users/?username=" + params.get("username").toString() + "&exact=true";

		//String jsonString = params.get("jsonString").toString();
		//String refNo = params.get("refNo").toString();
		String output1 = "";
		SsoLoginApiRespForm p = new SsoLoginApiRespForm();
		try{
			URL url = new URL(ssoUrl);

			//insert to api0004m
			//
			LOGGER.error("Start Calling keycloak API ...." + ssoUrl + "......\n");
			HttpURLConnection conn1 = (HttpURLConnection) url.openConnection();
			conn1.disconnect();
	        conn1.setDoOutput(true);
	        conn1.setRequestMethod("GET");
	        conn1.setRequestProperty("Content-Type", "application/json");
	        conn1.setRequestProperty("Authorization", "Bearer " + params.get("bearer").toString());

	        /*if (params != null && params.size() > 0) {
	        	for(int i = 0 ; i < params.size() ; i++){
	        		params.get(i)
	        	}
	            Iterator<String> it = headers.keySet().iterator();
	            while (it.hasNext()) {
	                String key = it.next();
	                String value = headers.get(key);
	                httpConn.setRequestProperty(key, value);
	            }
	        }*/

	        conn1.connect();
	        /*DataOutputStream out = new DataOutputStream(conn1.getOutputStream());
//	        out.writeChars("username=CD105302&exact=true");
	        out.flush();
	        out.close();*/

	        LOGGER.error("Start Calling keycloak API return......\n");
	        LOGGER.error("Start Calling keycloak API return getResponseCode " + conn1.getResponseCode() + "......\n");
	        LOGGER.error("Start Calling keycloak API return getResponseMessage " + conn1.getResponseMessage() + "......\n");

	        InputStream inputStream;
	        if (conn1.getResponseCode() == 200) {
	            inputStream = conn1.getInputStream();
	            returnParams.put("status", AppConstants.SUCCESS);
	            returnParams.put("msg", "");
	        } else {
	            inputStream = conn1.getErrorStream();
	            returnParams.put("status", AppConstants.FAIL);
	        }

			if (conn1.getResponseCode() != HttpURLConnection.HTTP_CREATED) {
				BufferedReader br = new BufferedReader(new InputStreamReader(
		                (inputStream)));
				//conn1.getResponseMessage();
				// BufferedReader in = new BufferedReader(new InputStreamReader(conn1.getInputStream()));


		        String output = "";
		        LOGGER.debug("Output from Server .... \n");
		        while ((output = br.readLine()) != null) {
		        	output1 = output;
		        	LOGGER.debug(output);
		        	returnParams.put("msg", output);
		        }

		        Gson g = new Gson();
		        SsoLoginApiRespForm[] response = g.fromJson(output1, SsoLoginApiRespForm[].class);

		        LOGGER.error("Start Calling keycloak API return LoginApiRespForm" + p.toString() + "......\n");
		        returnParams.put("keycloakUserId", response[0].getId());
//		        LOGGER.error("Start Calling keycloak API return getId : " + p.getId() + "......\n");
//		        returnParams.put("keyclockUserId", p.getId());
		        //adminAccessToken = p.getAccess_token();
		        /*String msg = p.getMessage() != null ? "LMS: " + p.getMessage().toString() : "";
		        if(p.getStatus() ==null || p.getStatus().isEmpty()){
		        	p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
//		        	resultValue.put("status", AppConstants.FAIL);
//					resultValue.put("message", msg);
		        }else if(p.getStatus().equals("true")){
		        	p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS));
//		        	resultValue.put("status", AppConstants.SUCCESS);
//					resultValue.put("message", msg);
		        }else{
//		        	resultValue.put("status", AppConstants.FAIL);
//					resultValue.put("message", msg);
		        	p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
		        }*/
				conn1.disconnect();

				br.close();
			}else{
//				resultValue.put("status", AppConstants.FAIL);
//				resultValue.put("message", "No Response");
//				p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
//				p.setMessage("No Response");
			}
		}catch(Exception e){
			LOGGER.error("Timeout:");
			LOGGER.error("[keycloak] - Caught Exception: " + e);
			returnParams.put("status", AppConstants.FAIL);
//			resultValue.put("status", AppConstants.RESPONSE_CODE_TIMEOUT);
//			p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_TIMEOUT));
//			p.setStatus(String.valueOf(AppConstants.RESPONSE_CODE_TIMEOUT));
//			p.setMessage("Timeout " + e.toString());
		}finally{
			stopWatch.stop();
		    respTm = stopWatch.toString();

		    params.put("responseCode", returnParams.get("status") == null ? "" : returnParams.get("status").toString());
            params.put("responseMessage", returnParams.get("msg") == null ? "" : returnParams.get("msg").toString());
            params.put("reqPrm", "getUserId");
            params.put("ipAddr", "");
            params.put("url", ssoUrl);
            params.put("respTm", respTm);
            params.put("resPrm", output1);
            params.put("apiUserId", ssoApiUserId);
            params.put("refNo", params.get("memCode") == null ? params.get("username").toString() :params.get("memCode").toString());

			rtnRespMsg(params);

			return returnParams;
//			commonApiService.rtnRespMsg(ssoUrl, p.getCode().toString(), p.getMessage().toString(),respTm , jsonString, output1 ,lmsApiUserId, refNo);
		}
    }

	@Override
    public Map<String, Object> userResetPassword(Map<String, Object> params) {
		Map<String,Object> returnParams = new HashMap<String, Object>();
		String adminAccessToken = "";

		String respTm = null;
		StopWatch stopWatch = new StopWatch();
	    stopWatch.reset();
	    stopWatch.start();

	    String jsonString ="";
		String ssoUrl = ssoUrlApi + "/users/" + params.get("keycloakUserId").toString() + "/reset-password";
		//String jsonString = params.get("jsonString").toString();
		//String refNo = params.get("refNo").toString();
		String output1 = "";
		SsoLoginApiRespForm p = new SsoLoginApiRespForm();
		try{
			URL url = new URL(ssoUrl);

			//insert to api0004m
			//
			LOGGER.error("Start Calling keycloak API ...." + ssoUrl + "......\n");
			HttpURLConnection conn1 = (HttpURLConnection) url.openConnection();
			conn1.disconnect();
	        conn1.setDoOutput(true);
	        conn1.setRequestMethod("PUT");
	        conn1.setRequestProperty("Content-Type", "application/json");
	        conn1.setRequestProperty("Authorization", "Bearer " + params.get("bearer").toString());

	        /*if (params != null && params.size() > 0) {
	        	for(int i = 0 ; i < params.size() ; i++){
	        		params.get(i)
	        	}
	            Iterator<String> it = headers.keySet().iterator();
	            while (it.hasNext()) {
	                String key = it.next();
	                String value = headers.get(key);
	                httpConn.setRequestProperty(key, value);
	            }
	        }*/

	        conn1.connect();
	        DataOutputStream out = new DataOutputStream(conn1.getOutputStream());
	        jsonString = "{\"type\": \"password\",\"temporary\": false,\"value\": \""
	        		+ params.get("userPass").toString() + "\"}";
	        out.write(jsonString.getBytes());
	        out.flush();
	        out.close();

	        LOGGER.error("Start Calling keycloak API return......\n");
	        LOGGER.error("Start Calling keycloak API return getResponseCode " + conn1.getResponseCode() + "......\n");
	        LOGGER.error("Start Calling keycloak API return getResponseMessage " + conn1.getResponseMessage() + "......\n");

	        InputStream inputStream;
	        if (conn1.getResponseCode() == 204) {
	            //inputStream = conn1.getInputStream();
	            LOGGER.debug("reset success");
	            returnParams.put("status", AppConstants.SUCCESS);
	            returnParams.put("msg", "");
	            conn1.disconnect();

	        } else {
	            inputStream = conn1.getErrorStream();
	            returnParams.put("status", AppConstants.FAIL);

	            String output = "";
	            BufferedReader br = new BufferedReader(new InputStreamReader(
		                (inputStream)));
	            LOGGER.error("Output from Server .... \n");
		        while ((output = br.readLine()) != null) {
		        	output1 = output;
		        	LOGGER.error(output);
		        	returnParams.put("msg", output);
		        }
	        }

			/*if (conn1.getResponseCode() != HttpURLConnection.HTTP_CREATED) {
				BufferedReader br = new BufferedReader(new InputStreamReader(
		                (inputStream)));
				//conn1.getResponseMessage();
				// BufferedReader in = new BufferedReader(new InputStreamReader(conn1.getInputStream()));


		        String output = "";
		        LOGGER.debug("Output from Server .... \n");
		        while ((output = br.readLine()) != null) {
		        	output1 = output;
		        	LOGGER.debug(output);
		        }

		        Gson g = new Gson();
		        p = g.fromJson(output1, SsoLoginApiRespForm.class);

		        LOGGER.error("Start Calling keycloak API return LoginApiRespForm" + p.toString() + "......\n");
		        LOGGER.error("Start Calling keycloak API return getAccess_token : " + p.getAccess_token() + "......\n");
		        returnParams.put("adminAccessToken", p.getAccess_token());
		        //adminAccessToken = p.getAccess_token();
		        String msg = p.getMessage() != null ? "LMS: " + p.getMessage().toString() : "";
		        if(p.getStatus() ==null || p.getStatus().isEmpty()){
		        	p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
//		        	resultValue.put("status", AppConstants.FAIL);
//					resultValue.put("message", msg);
		        }else if(p.getStatus().equals("true")){
		        	p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS));
//		        	resultValue.put("status", AppConstants.SUCCESS);
//					resultValue.put("message", msg);
		        }else{
//		        	resultValue.put("status", AppConstants.FAIL);
//					resultValue.put("message", msg);
		        	p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
		        }

			}else{
//				resultValue.put("status", AppConstants.FAIL);
//				resultValue.put("message", "No Response");
//				p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
//				p.setMessage("No Response");
			}*/
		}catch(Exception e){
			LOGGER.error("Timeout:");
			LOGGER.error("[keycloak] - Caught Exception: " + e);
//			resultValue.put("status", AppConstants.RESPONSE_CODE_TIMEOUT);
//			p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_TIMEOUT));
//			p.setStatus(String.valueOf(AppConstants.RESPONSE_CODE_TIMEOUT));
//			p.setMessage("Timeout " + e.toString());
		}finally{
			stopWatch.stop();
		    respTm = stopWatch.toString();

		    params.put("responseCode", returnParams.get("status") == null ? "" : returnParams.get("status").toString());
            params.put("responseMessage", returnParams.get("msg") == null ? "" : returnParams.get("msg").toString());
            params.put("reqPrm", jsonString);
            params.put("ipAddr", "");
            params.put("url", ssoUrl);
            params.put("respTm", respTm);
            params.put("resPrm", output1);
            params.put("apiUserId", ssoApiUserId);
            params.put("refNo", params.get("memCode") == null ? params.get("username").toString() :params.get("memCode").toString());

			rtnRespMsg(params);

			return returnParams;
//			commonApiService.rtnRespMsg(ssoUrl, p.getCode().toString(), p.getMessage().toString(),respTm , jsonString, output1 ,lmsApiUserId, refNo);
		}
    }

	@Override
    public Map<String, Object> userActivateDeactivate(Map<String, Object> params) {
		Map<String,Object> returnParams = new HashMap<String, Object>();
		String adminAccessToken = "";

		String respTm = null;
		StopWatch stopWatch = new StopWatch();
	    stopWatch.reset();
	    stopWatch.start();

	    String jsonString = "";
		String ssoUrl = ssoUrlApi + "/users/" + params.get("keycloakUserId").toString();
		//String jsonString = params.get("jsonString").toString();
		//String refNo = params.get("refNo").toString();
		String output1 = "";
		SsoLoginApiRespForm p = new SsoLoginApiRespForm();
		try{
			URL url = new URL(ssoUrl);

			//insert to api0004m
			//
			LOGGER.error("Start Calling keycloak API ...." + ssoUrl + "......\n");
			HttpURLConnection conn1 = (HttpURLConnection) url.openConnection();
			conn1.disconnect();
	        conn1.setDoOutput(true);
	        conn1.setRequestMethod("PUT");
	        conn1.setRequestProperty("Content-Type", "application/json");
	        conn1.setRequestProperty("Authorization", "Bearer " + params.get("bearer").toString());

	        /*if (params != null && params.size() > 0) {
	        	for(int i = 0 ; i < params.size() ; i++){
	        		params.get(i)
	        	}
	            Iterator<String> it = headers.keySet().iterator();
	            while (it.hasNext()) {
	                String key = it.next();
	                String value = headers.get(key);
	                httpConn.setRequestProperty(key, value);
	            }
	        }*/

	        conn1.connect();
	        DataOutputStream out = new DataOutputStream(conn1.getOutputStream());
	        jsonString = "{\"enabled\": "
	        		+ params.get("enabled").toString() + "}";
	        out.write(jsonString.getBytes());
	        out.flush();
	        out.close();

	        LOGGER.error("Start Calling keycloak API return......\n");
	        LOGGER.error("Start Calling keycloak API return getResponseCode " + conn1.getResponseCode() + "......\n");
	        LOGGER.error("Start Calling keycloak API return getResponseMessage " + conn1.getResponseMessage() + "......\n");

	        InputStream inputStream;
	        if (conn1.getResponseCode() == 204) {
	        	returnParams.put("status", AppConstants.SUCCESS);
	        	returnParams.put("msg", "");
	            //inputStream = conn1.getInputStream();
	        	if(params.get("enabled").toString() == "false"){
	        		LOGGER.debug("deactivate success");
	        	}else{
	        		LOGGER.debug("activate success");
	        	}

	            conn1.disconnect();

	        } else {
	            inputStream = conn1.getErrorStream();
	            returnParams.put("status", AppConstants.FAIL);

	            String output = "";
	            BufferedReader br = new BufferedReader(new InputStreamReader(
		                (inputStream)));
	            LOGGER.error("Output from Server .... \n");
		        while ((output = br.readLine()) != null) {
		        	output1 = output;
		        	LOGGER.error(output);
		        	returnParams.put("msg", output);
		        }
	        }

			/*if (conn1.getResponseCode() != HttpURLConnection.HTTP_CREATED) {
				BufferedReader br = new BufferedReader(new InputStreamReader(
		                (inputStream)));
				//conn1.getResponseMessage();
				// BufferedReader in = new BufferedReader(new InputStreamReader(conn1.getInputStream()));


		        String output = "";
		        LOGGER.debug("Output from Server .... \n");
		        while ((output = br.readLine()) != null) {
		        	output1 = output;
		        	LOGGER.debug(output);
		        }

		        Gson g = new Gson();
		        p = g.fromJson(output1, SsoLoginApiRespForm.class);

		        LOGGER.error("Start Calling keycloak API return LoginApiRespForm" + p.toString() + "......\n");
		        LOGGER.error("Start Calling keycloak API return getAccess_token : " + p.getAccess_token() + "......\n");
		        returnParams.put("adminAccessToken", p.getAccess_token());
		        //adminAccessToken = p.getAccess_token();
		        String msg = p.getMessage() != null ? "LMS: " + p.getMessage().toString() : "";
		        if(p.getStatus() ==null || p.getStatus().isEmpty()){
		        	p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
//		        	resultValue.put("status", AppConstants.FAIL);
//					resultValue.put("message", msg);
		        }else if(p.getStatus().equals("true")){
		        	p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS));
//		        	resultValue.put("status", AppConstants.SUCCESS);
//					resultValue.put("message", msg);
		        }else{
//		        	resultValue.put("status", AppConstants.FAIL);
//					resultValue.put("message", msg);
		        	p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
		        }

			}else{
//				resultValue.put("status", AppConstants.FAIL);
//				resultValue.put("message", "No Response");
//				p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
//				p.setMessage("No Response");
			}*/
		}catch(Exception e){
			LOGGER.error("Timeout:");
			LOGGER.error("[keycloak] - Caught Exception: " + e);
//			resultValue.put("status", AppConstants.RESPONSE_CODE_TIMEOUT);
//			p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_TIMEOUT));
//			p.setStatus(String.valueOf(AppConstants.RESPONSE_CODE_TIMEOUT));
//			p.setMessage("Timeout " + e.toString());
		}finally{
			stopWatch.stop();
		    respTm = stopWatch.toString();

		    params.put("responseCode", returnParams.get("status") == null ? "" : returnParams.get("status").toString());
            params.put("responseMessage", returnParams.get("msg") == null ? "" : returnParams.get("msg").toString());
            params.put("reqPrm", jsonString);
            params.put("ipAddr", "");
            params.put("url", ssoUrl);
            params.put("respTm", respTm);
            params.put("resPrm", output1);
            params.put("apiUserId", ssoApiUserId);
            params.put("refNo", params.get("memCode") == null ? params.get("username").toString() :params.get("memCode").toString());

			rtnRespMsg(params);

			return returnParams;
//			commonApiService.rtnRespMsg(ssoUrl, p.getCode().toString(), p.getMessage().toString(),respTm , jsonString, output1 ,lmsApiUserId, refNo);
		}
    }

	@Override
    public Map<String, Object> userDelete(Map<String, Object> params) {
		Map<String,Object> returnParams = new HashMap<String, Object>();
		String adminAccessToken = "";

		String respTm = null;
		StopWatch stopWatch = new StopWatch();
	    stopWatch.reset();
	    stopWatch.start();

	    String jsonString = "";
		String ssoUrl = ssoUrlApi + "/users/" + params.get("keycloakUserId").toString();
		//String jsonString = params.get("jsonString").toString();
		//String refNo = params.get("refNo").toString();
		String output1 = "";
		SsoLoginApiRespForm p = new SsoLoginApiRespForm();
		try{
			URL url = new URL(ssoUrl);

			//insert to api0004m
			//
			LOGGER.error("Start Calling keycloak API ...." + ssoUrl + "......\n");
			HttpURLConnection conn1 = (HttpURLConnection) url.openConnection();
			conn1.disconnect();
	        conn1.setDoOutput(true);
	        conn1.setRequestMethod("DELETE");
	        conn1.setRequestProperty("Content-Type", "application/json");
	        conn1.setRequestProperty("Authorization", "Bearer " + params.get("bearer").toString());

	        conn1.connect();
	        /*DataOutputStream out = new DataOutputStream(conn1.getOutputStream());
	        jsonString = "{\"enabled\": "
	        		+ params.get("enabled").toString() + "}";
	        out.write(jsonString.getBytes());
	        out.flush();
	        out.close();*/

	        LOGGER.error("Start Calling keycloak API return......\n");
	        LOGGER.error("Start Calling keycloak API return getResponseCode " + conn1.getResponseCode() + "......\n");
	        LOGGER.error("Start Calling keycloak API return getResponseMessage " + conn1.getResponseMessage() + "......\n");

	        InputStream inputStream;
	        if (conn1.getResponseCode() == 204) {
	        	returnParams.put("status", AppConstants.SUCCESS);
	        	returnParams.put("msg", "");
	        	LOGGER.debug("userDelete success");

	            conn1.disconnect();

	        } else {
	            inputStream = conn1.getErrorStream();
	            returnParams.put("status", AppConstants.FAIL);

	            String output = "";
	            BufferedReader br = new BufferedReader(new InputStreamReader(
		                (inputStream)));
	            LOGGER.error("Output from Server .... \n");
		        while ((output = br.readLine()) != null) {
		        	output1 = output;
		        	LOGGER.error(output);
		        	returnParams.put("msg", output);
		        }
	        }

		}catch(Exception e){
			LOGGER.error("Timeout:");
			LOGGER.error("[keycloak] - Caught Exception: " + e);
		}finally{
			stopWatch.stop();
		    respTm = stopWatch.toString();

		    params.put("responseCode", returnParams.get("status") == null ? "" : returnParams.get("status").toString());
            params.put("responseMessage", returnParams.get("msg") == null ? "" : returnParams.get("msg").toString());
            params.put("reqPrm", jsonString);
            params.put("ipAddr", "");
            params.put("url", ssoUrl);
            params.put("respTm", respTm);
            params.put("resPrm", output1);
            params.put("apiUserId", ssoApiUserId);
            params.put("refNo", params.get("memCode") == null ? params.get("username").toString() :params.get("memCode").toString());

			rtnRespMsg(params);

			return returnParams;
		}
    }

	@Override
    public Map<String, Object> userInfoUpdate(Map<String, Object> params) {
		Map<String,Object> returnParams = new HashMap<String, Object>();
		String adminAccessToken = "";

		String respTm = null;
		StopWatch stopWatch = new StopWatch();
	    stopWatch.reset();
	    stopWatch.start();

	    String jsonString = "";
		String ssoUrl = ssoUrlApi + "/users/" + params.get("keycloakUserId").toString();
		String output1 = "";
		SsoLoginApiRespForm p = new SsoLoginApiRespForm();
		try{
			URL url = new URL(ssoUrl);

			LOGGER.error("Start Calling keycloak API ...." + ssoUrl + "......\n");
			HttpURLConnection conn1 = (HttpURLConnection) url.openConnection();
			conn1.disconnect();
	        conn1.setDoOutput(true);
	        conn1.setRequestMethod("PUT");
	        conn1.setRequestProperty("Content-Type", "application/json");
	        conn1.setRequestProperty("Authorization", "Bearer " + params.get("bearer").toString());
	        conn1.connect();
	        DataOutputStream out = new DataOutputStream(conn1.getOutputStream());
	        jsonString = "";
	        if(params.get("firstName") != null && params.get("firstName").toString() != ""){
	        	jsonString = "{\"firstName\": \""
		        		+ params.get("firstName").toString() + "\"";
	        }

	        if(params.get("email") != null && params.get("email").toString() != ""){
	        	if(jsonString == ""){
	        		jsonString = "{\"email\": \""
			        		+ params.get("email").toString() + "\"";
	        	}else{
	        		jsonString = jsonString + ",\"email\": \""
			        		+ params.get("email").toString() + "\"";
	        	}
	        }

	        jsonString = jsonString + "}";
	        /*jsonString = "{\"enabled\": "
	        		+ params.get("enabled").toString() + "}";*/
	        LOGGER.error("Start Calling keycloak API jsonString...." + jsonString + "......\n");
	        out.write(jsonString.getBytes());
	        out.flush();
	        out.close();

	        LOGGER.error("Start Calling keycloak API return......\n");
	        LOGGER.error("Start Calling keycloak API return getResponseCode " + conn1.getResponseCode() + "......\n");
	        LOGGER.error("Start Calling keycloak API return getResponseMessage " + conn1.getResponseMessage() + "......\n");

	        InputStream inputStream;
	        if (conn1.getResponseCode() == 204) {
	        	returnParams.put("status", AppConstants.SUCCESS);
	        	returnParams.put("msg", "");
	            //inputStream = conn1.getInputStream();
	        	LOGGER.debug("Update info success");

	            conn1.disconnect();

	        } else {
	            inputStream = conn1.getErrorStream();
	            returnParams.put("status", AppConstants.FAIL);

	            String output = "";
	            BufferedReader br = new BufferedReader(new InputStreamReader(
		                (inputStream)));
	            LOGGER.error("Output from Server .... \n");
		        while ((output = br.readLine()) != null) {
		        	output1 = output;
		        	LOGGER.error(output);
		        	returnParams.put("msg", output);
		        }
	        }

			/*if (conn1.getResponseCode() != HttpURLConnection.HTTP_CREATED) {
				BufferedReader br = new BufferedReader(new InputStreamReader(
		                (inputStream)));
				//conn1.getResponseMessage();
				// BufferedReader in = new BufferedReader(new InputStreamReader(conn1.getInputStream()));


		        String output = "";
		        LOGGER.debug("Output from Server .... \n");
		        while ((output = br.readLine()) != null) {
		        	output1 = output;
		        	LOGGER.debug(output);
		        }

		        Gson g = new Gson();
		        p = g.fromJson(output1, SsoLoginApiRespForm.class);

		        LOGGER.error("Start Calling keycloak API return LoginApiRespForm" + p.toString() + "......\n");
		        LOGGER.error("Start Calling keycloak API return getAccess_token : " + p.getAccess_token() + "......\n");
		        returnParams.put("adminAccessToken", p.getAccess_token());
		        //adminAccessToken = p.getAccess_token();
		        String msg = p.getMessage() != null ? "LMS: " + p.getMessage().toString() : "";
		        if(p.getStatus() ==null || p.getStatus().isEmpty()){
		        	p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
//		        	resultValue.put("status", AppConstants.FAIL);
//					resultValue.put("message", msg);
		        }else if(p.getStatus().equals("true")){
		        	p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS));
//		        	resultValue.put("status", AppConstants.SUCCESS);
//					resultValue.put("message", msg);
		        }else{
//		        	resultValue.put("status", AppConstants.FAIL);
//					resultValue.put("message", msg);
		        	p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
		        }

			}else{
//				resultValue.put("status", AppConstants.FAIL);
//				resultValue.put("message", "No Response");
//				p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
//				p.setMessage("No Response");
			}*/
		}catch(Exception e){
			LOGGER.error("Timeout:");
			LOGGER.error("[keycloak] - Caught Exception: " + e);
//			resultValue.put("status", AppConstants.RESPONSE_CODE_TIMEOUT);
//			p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_TIMEOUT));
//			p.setStatus(String.valueOf(AppConstants.RESPONSE_CODE_TIMEOUT));
//			p.setMessage("Timeout " + e.toString());
		}finally{
			stopWatch.stop();
		    respTm = stopWatch.toString();

		    params.put("responseCode", returnParams.get("status") == null ? "" : returnParams.get("status").toString());
            params.put("responseMessage", returnParams.get("msg") == null ? "" : returnParams.get("msg").toString());
            params.put("reqPrm", jsonString);
            params.put("ipAddr", "");
            params.put("url", ssoUrl);
            params.put("respTm", respTm);
            params.put("resPrm", output1);
            params.put("apiUserId", ssoApiUserId);
            params.put("refNo", params.get("memCode") == null ? params.get("username").toString() :params.get("memCode").toString());

			rtnRespMsg(params);

			return returnParams;
//			commonApiService.rtnRespMsg(ssoUrl, p.getCode().toString(), p.getMessage().toString(),respTm , jsonString, output1 ,lmsApiUserId, refNo);
		}
    }

	@Transactional(propagation = Propagation.REQUIRES_NEW)
	@Override
	public void rtnRespMsg(Map<String, Object> param) {

	    EgovMap data = new EgovMap();
	    Map<String, Object> params = new HashMap<>();

	      params.put("respCde", param.get("responseCode"));
	      params.put("errMsg", param.get("responseMessage"));
	      params.put("reqParam", param.get("reqPrm"));
	      params.put("ipAddr", "");
	      params.put("prgPath", param.get("url"));
	      params.put("respTm", param.get("respTm"));
	      params.put("respParam", param.get("resPrm"));
	      params.put("apiUserId", param.get("apiUserId"));
	      params.put("refNo", param.get("refNo"));

	      commonApiMapper.insertApiAccessLog(params);
	  }
}
