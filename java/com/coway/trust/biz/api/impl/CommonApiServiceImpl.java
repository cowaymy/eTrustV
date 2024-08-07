package com.coway.trust.biz.api.impl;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;

/**************************************
 * Author                  Date                    Remark
 * Chew Kah Kit        2020/12/16           API for Common
 ***************************************/

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections4.MapUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.StopWatch;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.api.CommonApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.coway.trust.AppConstants;
import com.coway.trust.api.project.common.CommonApiDto;
import com.coway.trust.api.project.common.CommonApiForm;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("commonApiService")
public class CommonApiServiceImpl extends EgovAbstractServiceImpl implements CommonApiService {

  @Resource(name = "CommonApiMapper")
  private CommonApiMapper commonApiMapper;

  @Value("${cw.api.auth.username}")
  private String CWApiAuthUsername;

  @Value("${cw.api.auth.password}")
  private String CWApiAuthPassword;

  @Override
  public EgovMap checkAccess(HttpServletRequest request,CommonApiForm commonApiForm){

    String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0";

    StopWatch stopWatch = new StopWatch();
    stopWatch.reset();
    stopWatch.start();

    Map<String, Object> reqPrm = CommonApiForm.createMap(commonApiForm);
    CommonApiDto rtn = new CommonApiDto();

    try{
      if(CommonUtils.isEmpty(commonApiForm.getKey())){
        code = String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED);
        message = AppConstants.RESPONSE_DESC_UNAUTHORIZED;
      }

      EgovMap access = commonApiMapper.checkAccess(reqPrm);

      if(MapUtils.isNotEmpty(access)){
        apiUserId = access.get("apiUserId").toString();
        rtn = CommonApiDto.create(access);

        code = String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS);
        message = String.valueOf(AppConstants.RESPONSE_DESC_SUCCESS);
      }else{
        code = String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED);
        message = AppConstants.RESPONSE_DESC_UNAUTHORIZED;
      }
    } catch (Exception e){
      code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
      message = StringUtils.substring(e.getMessage(), 0, 4000);

    } finally {
      stopWatch.stop();
      respTm = stopWatch.toString();
    }

    return rtnRespMsg(request, code, message, respTm, reqPrm, CommonApiDto.createMap(rtn),apiUserId);

  }

  @Override
  public EgovMap rtnRespMsg(HttpServletRequest request, String code, String msg, String respTm, Map<String, Object> reqPrm, Map<String, Object> respPrm, String apiUserId) {

    EgovMap data = new EgovMap();
    Map<String, Object> params = new HashMap<>();
    String pgmPath = StringUtils.defaultString(request.getRequestURI()) + "?" + StringUtils.defaultString(request.getQueryString());

      params.put("respCde", code);
      params.put("errMsg", msg);
      params.put("reqParam", reqPrm.toString());
      params.put("ipAddr", CommonUtils.getClientIp(request));
      params.put("prgPath", pgmPath);
      params.put("respTm", respTm);
      params.put("respParam", respPrm != null ? respPrm.toString().length() >= 4000 ? respPrm.toString().substring(0,4000) : respPrm.toString() : respPrm);
      params.put("apiUserId", apiUserId);

      commonApiMapper.insertApiAccessLog(params);

      data.put("code", code);
      data.put("message", msg);
      data.put("data", respPrm);


    return data;
  }

  @Override
  public EgovMap rtnRespMsg(HttpServletRequest request, String code, String msg, String respTm, String reqPrm, Map<String, Object> respPrm, String apiUserId) {

    EgovMap data = new EgovMap();
    Map<String, Object> params = new HashMap<>();
    String pgmPath = "";
    pgmPath = StringUtils.defaultString(request.getRequestURI());


      params.put("respCde", code);
      params.put("errMsg", msg);
      params.put("reqParam", reqPrm);
	  params.put("ipAddr", CommonUtils.getClientIp(request));
      params.put("prgPath", pgmPath);
      params.put("respTm", respTm);
      params.put("respParam", respPrm != null ? respPrm.toString().length() >= 4000 ? respPrm.toString().substring(0,4000) : respPrm.toString() : respPrm);
      params.put("apiUserId", apiUserId);

      commonApiMapper.insertApiAccessLog(params);

      data.put("code", code);
      data.put("message", msg);
      data.put("status", (code.equals("200")||code.equals("201"))?AppConstants.DESC_SUCCESS:AppConstants.DESC_FAILED);
      if(respPrm != null && !respPrm.isEmpty()){
    	  data.put("data", respPrm);
      }

      return data;
  }

  @Override
  public EgovMap rtnRespMsg(String pgmPath, String code, String msg, String respTm, String reqPrm, Map<String, Object> respPrm, String apiUserId) {

    EgovMap data = new EgovMap();
    Map<String, Object> params = new HashMap<>();

      params.put("respCde", code);
      params.put("errMsg", msg);
      params.put("reqParam", reqPrm);
      params.put("ipAddr", "");
      params.put("prgPath", pgmPath != null ? pgmPath : " ");
      params.put("respTm", respTm);
      params.put("respParam", respPrm != null ? respPrm.toString().length() >= 4000 ? respPrm.toString().substring(0,4000) : respPrm.toString() : respPrm);
      params.put("apiUserId", apiUserId);

      commonApiMapper.insertApiAccessLog(params);

      data.put("code", code);
      data.put("message", msg);
      data.put("status", (code.equals("200")||code.equals("201"))?AppConstants.DESC_SUCCESS:AppConstants.DESC_FAILED);
      if(respPrm != null && !respPrm.isEmpty()){
    	  data.put("data", respPrm);
      }

      return data;
  }

  @Transactional(propagation = Propagation.REQUIRES_NEW)
  @Override
  public EgovMap rtnRespMsg(String pgmPath, String code, String msg, String respTm, String reqPrm, String respPrm, String apiUserId, String refNo) {

    EgovMap data = new EgovMap();
    Map<String, Object> params = new HashMap<>();

      params.put("respCde", code);
      params.put("errMsg", msg);
      params.put("reqParam", reqPrm);
      params.put("ipAddr", "");
      params.put("prgPath", pgmPath != null ? pgmPath : " ");
      params.put("respTm", respTm);
      params.put("respParam", respPrm != null ? respPrm.toString().length() >= 4000 ? respPrm.toString().substring(0,4000) : respPrm.toString() : respPrm);
      params.put("apiUserId", apiUserId);
      params.put("refNo", refNo);

      commonApiMapper.insertApiAccessLog(params);

      data.put("code", code);
      data.put("message", msg);
      data.put("status", (code.equals("200")||code.equals("201"))?AppConstants.DESC_SUCCESS:AppConstants.DESC_FAILED);
      if(respPrm != null && !respPrm.isEmpty()){
    	  data.put("data", respPrm);
      }

      return data;
  }

  @Override
  public String decodeJson(HttpServletRequest request) throws Exception{
		String data = IOUtils.toString(request.getInputStream(), "UTF-8");
	    return data;
	  }

  @Override
  public EgovMap verifyBasicAuth(HttpServletRequest request,Map<String, Object> params)  throws Exception {

    String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0";

    StopWatch stopWatch = new StopWatch();
    stopWatch.reset();
    stopWatch.start();

    try{

    	String authorization = request.getHeader("Authorization");
    	String[] values = {"",""};

  	  	//if (authorization != null && authorization.toLowerCase().startsWith("basic")) {
    	if (authorization != null && authorization.startsWith("Basic")) {
  		  // Authorization: Basic base64credentials
  		  String base64Credentials = authorization.substring("Basic".length()).trim();
  		  byte[] credDecoded = Base64.getDecoder().decode(base64Credentials);
  		  String credentials = new String(credDecoded, StandardCharsets.UTF_8);
  		  // credentials = username:password
  		   values = credentials.split(":", 2);
  	  	}

  	  	Exception e1 = null;
  	  	if(CWApiAuthUsername.equals(values[0].toString()) && CWApiAuthUsername.equals(values[0].toString()) ){
      	  	code = String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS);
            message = String.valueOf(AppConstants.RESPONSE_DESC_SUCCESS);
  	  	}else{
      	  	e1 = new Exception("Invalid Credentials");
            throw e1;
  	  	}

    } catch (Exception e){
      code = String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED);
      message = StringUtils.substring(e.getMessage(), 0, 4000);

    } finally {
      stopWatch.stop();
      respTm = stopWatch.toString();
    }

    return rtnRespMsg(request, code, message, respTm, params, null,apiUserId);

  }

}
