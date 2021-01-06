package com.coway.trust.biz.api.impl;

import java.util.List;

/**************************************
 * Author                  Date                    Remark
 * Chew Kah Kit        2020/12/16           API for Common
 ***************************************/

import java.util.Map;
import java.util.Objects;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections4.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.StopWatch;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.api.CommonApiService;
import com.coway.trust.biz.api.EcommApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.google.common.collect.Maps;
import com.coway.trust.AppConstants;
import com.coway.trust.api.project.common.CommonApiDto;
import com.coway.trust.api.project.common.CommonApiForm;
import com.coway.trust.api.project.eCommerce.EComApiDto;
import com.coway.trust.api.project.eCommerce.EComApiForm;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("eCommApiService")
public class EcommApiServiceImpl extends EgovAbstractServiceImpl implements EcommApiService {

  @Resource(name = "EcommApiMapper")
  private EcommApiMapper ecommApiMapper;

  @Resource(name = "CommonApiMapper")
  private CommonApiMapper commonApiMapper;

  @Resource(name = "commonApiService")
  private CommonApiService commonApiService;

  @Override
  public EgovMap checkOrderStatus(HttpServletRequest request,EComApiForm eComApiForm) throws Exception {
    String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0";

    StopWatch stopWatch = new StopWatch();
    stopWatch.reset();
    stopWatch.start();

    EgovMap data = new EgovMap(), access = new EgovMap();
    Map<String, Object> reqPrm = Maps.filterValues(EComApiForm.createMap(eComApiForm),Objects::nonNull);
    EComApiDto rtn = new EComApiDto();

    try{

      access = commonApiMapper.checkAccess(reqPrm);
      if(access == null){
        code = String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED);
        message = AppConstants.RESPONSE_DESC_UNAUTHORIZED;
      }
      else if(CommonUtils.isEmpty(eComApiForm.getOrdNo())){
        code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
        message = "Order Number Not Found";
      }
      else {
        data = ecommApiMapper.checkOrderStatus(EComApiForm.createMap(eComApiForm));

        if(MapUtils.isNotEmpty(data)){
          code = String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS);
          message = String.valueOf(AppConstants.RESPONSE_DESC_SUCCESS);

          rtn = EComApiDto.create(data);
        }else{
          code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
          message = "Order Number Not Found";
        }
      }

    }catch(Exception e){
      code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
      message = StringUtils.substring(e.getMessage(), 0, 4000);
    } finally{
      stopWatch.stop();
      respTm = stopWatch.toString();
    }

    return commonApiService.rtnRespMsg(request, code, message, respTm, reqPrm, EComApiDto.createMap(rtn) ,apiUserId);
  }

  @Override
  public EgovMap cardDiffNRIC(HttpServletRequest request, EComApiForm eComApiForm) throws Exception {

    String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0";

    StopWatch stopWatch = new StopWatch();
    stopWatch.reset();
    stopWatch.start();

    EgovMap data = new EgovMap(), params = new EgovMap(), access = new EgovMap();
    Map<String, Object> reqPrm = Maps.filterValues(EComApiForm.createMap(eComApiForm),Objects::nonNull);

    params.put("cardDiffNRIC", "F");

    try{

      access = commonApiMapper.checkAccess(reqPrm);
      if(access == null){
        code = String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED);
        message = AppConstants.RESPONSE_DESC_UNAUTHORIZED;
      }
      else if(CommonUtils.isEmpty(eComApiForm.getNric())){
        code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
        message = "NRIC not found.";
      }
      else if(CommonUtils.isEmpty(eComApiForm.getCardTokenId())){
        code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
        message = "Card Token Id not found.";
      }
      else {

        data = ecommApiMapper.cardDiffNRIC(EComApiForm.createMap(eComApiForm));

        if(data != null){
          code = String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS);
          message = String.valueOf(AppConstants.RESPONSE_DESC_SUCCESS);

          if(!(data.get("custCrcToken") == null) && data.get("nric") == null )
            params.put("cardDiffNRIC", "Y");
          else{
            params.put("cardDiffNRIC", "N");
          }
        }else{
          code = String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS);
          message = String.valueOf(AppConstants.RESPONSE_DESC_SUCCESS);
          params.put("cardDiffNRIC", "N");
        }

      }

    }catch(Exception e){
      code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
      message = StringUtils.substring(e.getMessage(), 0, 4000);
    } finally{
      stopWatch.stop();
      respTm = stopWatch.toString();
    }

    return commonApiService.rtnRespMsg(request, code, message, respTm, reqPrm, params ,apiUserId);
  }


}
