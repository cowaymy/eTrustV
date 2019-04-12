package com.coway.trust.biz.common.impl;

/**************************************
 * Author                  Date                    Remark
 * Chew Kah Kit        2019/04/11           API for customer portal
 ***************************************/

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.StopWatch;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.ApiService;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.AppConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("apiService")
public class ApiServiceImpl implements ApiService {

  private static final Logger LOGGER = LoggerFactory.getLogger(ApiServiceImpl.class);

  @Autowired
  private ApiMapper apiMapper;

  @Override
  public EgovMap selectCowayCustNricOrPassport(HttpServletRequest request, Map<String, Object> params) {

    EgovMap response = new EgovMap();
    EgovMap custDetails = new EgovMap();
    String respTm = null;
    String pgmPath = StringUtils.defaultString(request.getRequestURI()) + "?" + StringUtils.defaultString(request.getQueryString());

    try {

      StopWatch stopWatch = new StopWatch();
      stopWatch.reset();
      stopWatch.start();
      custDetails = apiMapper.selectCowayCustNricOrPassport(params);
      stopWatch.stop();
      respTm = stopWatch.toString();

      if (!request.getQueryString().equals(null)) {

        if (custDetails.isEmpty()) {
          params.put("respCde", AppConstants.RESPONSE_CODE_NOT_FOUND);
          params.put("respDesc", AppConstants.RESPONSE_DESC_NOT_FOUND);
        } else {
          params.put("respCde", AppConstants.RESPONSE_CODE_SUCCESS);
          params.put("respDesc", AppConstants.RESPONSE_DESC_SUCCESS);
        }
        params.put("errMsg", "");

      } else {

        params.put("respCde", AppConstants.RESPONSE_CODE_INVALID);
        params.put("respDesc", AppConstants.RESPONSE_DESC_INVALID);
        params.put("errMsg", "No paramater");

      }
    } catch (Exception e) {

      custDetails = null;
      params.put("respCde", AppConstants.RESPONSE_CODE_INVALID);
      params.put("respDesc", AppConstants.RESPONSE_DESC_INVALID);
      params.put("errMsg", StringUtils.substring(e.getMessage(), 0, 4000));

    } finally {
      params.put("reqParam", params.toString());
      params.put("ipAddr", CommonUtils.getClientIp(request));
      params.put("prgPath", pgmPath);
      params.put("respTm", respTm);
      params.put("respParam", custDetails.toString());

      apiMapper.insertApiAccessLog(params);

      response.put("response", params.get("respCde").toString() + " - " + params.get("respDesc").toString());
      if(custDetails != null) response.put("custDetails", custDetails.toString());
    }

    return response;
  }
}
