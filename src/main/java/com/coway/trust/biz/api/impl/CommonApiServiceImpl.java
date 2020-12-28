package com.coway.trust.biz.api.impl;

import java.util.List;

/**************************************
 * Author                  Date                    Remark
 * Chew Kah Kit        2020/12/16           API for Common
 ***************************************/

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections4.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.StopWatch;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.api.CommonApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.AppConstants;
import com.coway.trust.api.project.common.CommonApiDto;
import com.coway.trust.api.project.common.CommonApiForm;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("commonApiService")
public class CommonApiServiceImpl extends EgovAbstractServiceImpl implements CommonApiService {

  @Resource(name = "CommonApiMapper")
  private CommonApiMapper commonApiMapper;

  @Override
  public CommonApiDto checkAccess(CommonApiForm params) throws Exception{

    if(null == params){
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if(CommonUtils.isEmpty(params.getKey())){
      throw new ApplicationException(String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED),AppConstants.RESPONSE_DESC_UNAUTHORIZED);
    }
    EgovMap access = commonApiMapper.checkAccess(CommonApiForm.createMap(params));
    CommonApiDto rtn = new CommonApiDto();

    if(MapUtils.isNotEmpty(access)){
      return rtn.create(access);
    }else{
      throw new ApplicationException(String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED),AppConstants.RESPONSE_DESC_UNAUTHORIZED);
    }
  }

  @Override
  public EgovMap returnResponseMessage(HttpServletRequest request, Map<String, Object> params, EgovMap responseData) {

    EgovMap response = new EgovMap();
    String respTm = null;
    String pgmPath = StringUtils.defaultString(request.getRequestURI()) + "?" + StringUtils.defaultString(request.getQueryString());

    try {

      StopWatch stopWatch = new StopWatch();
      stopWatch.reset();
      stopWatch.start();
      stopWatch.stop();
      respTm = stopWatch.toString();

      if (!request.getQueryString().equals(null)) {

        if (responseData.size() < 1) {
          params.put("respCde", AppConstants.RESPONSE_CODE_NOT_FOUND);
          params.put("respDesc", AppConstants.RESPONSE_DESC_NOT_FOUND);
        } else {
          params.put("respCde", AppConstants.RESPONSE_CODE_SUCCESS);
          params.put("respDesc", AppConstants.RESPONSE_DESC_SUCCESS);
        }

      } else {
        params.put("respCde", AppConstants.RESPONSE_CODE_INVALID);
        params.put("respDesc", AppConstants.RESPONSE_DESC_INVALID);
        params.put("errMsg", "No paramater");
      }

    } catch (Exception e) {

      params.put("respCde", AppConstants.RESPONSE_CODE_INVALID);
      params.put("respDesc", AppConstants.RESPONSE_DESC_INVALID);
      params.put("errMsg", StringUtils.substring(e.getMessage(), 0, 4000));

    } finally {
      params.put("reqParam", params.toString());
      params.put("ipAddr", CommonUtils.getClientIp(request));
      params.put("prgPath", pgmPath);
      params.put("respTm", respTm);
      params.put("respParam", responseData != null ? responseData.toString().length() >= 4000 ? responseData.toString().substring(0,4000) : responseData.toString() : responseData);

      commonApiMapper.insertApiAccessLog(params);

      response.put("response", params.get("respCde").toString() + " - " + params.get("respDesc").toString());
      if(responseData.size() > 0) response.put("responseData", responseData);
    }

    return response;
  }

}
