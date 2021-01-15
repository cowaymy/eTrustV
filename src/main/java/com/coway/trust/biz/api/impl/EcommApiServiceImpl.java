package com.coway.trust.biz.api.impl;

import java.util.HashMap;
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
import com.coway.trust.util.CommonUtils;
import com.google.common.collect.Maps;
import com.coway.trust.AppConstants;
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
  public EgovMap registerOrder(HttpServletRequest request, EComApiForm eComApiForm) throws Exception {
    String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0";

    StopWatch stopWatch = new StopWatch();
    stopWatch.reset();
    stopWatch.start();

    EgovMap access = new EgovMap();
    Map<String, Object> reqPrm = Maps.filterValues(EComApiForm.createRegOrdMap(eComApiForm),Objects::nonNull);

    try{

      access = commonApiMapper.checkAccess(reqPrm);
      if(access == null){
        code = String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED);
        message = AppConstants.RESPONSE_DESC_UNAUTHORIZED;
      }
      else {
        apiUserId = access.get("apiUserId").toString();

        reqPrm.put("apiUserId", apiUserId);

        int created = ecommApiMapper.registerOrd(reqPrm);
        if(created > 0){
          code = String.valueOf(AppConstants.RESPONSE_CODE_CREATED);
          message = AppConstants.RESPONSE_DESC_CREATED;
        }else{
          code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
          message = AppConstants.RESPONSE_DESC_INVALID;
        }
      }

    }catch(Exception e){
      code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
      message = StringUtils.substring(e.getMessage(), 0, 4000);
    } finally{
      stopWatch.stop();
      respTm = stopWatch.toString();
    }

    return commonApiService.rtnRespMsg(request, code, message, respTm, reqPrm, null ,apiUserId);
  }

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

      if(access != null) apiUserId = access.get("apiUserId").toString();

      if(access == null){
        code = String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED);
        message = AppConstants.RESPONSE_DESC_UNAUTHORIZED;
      }
      else if(CommonUtils.isEmpty(eComApiForm.getSofNo())){
        code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
        message = "Sales Order Form No. Not Found";
      }
      else {
        data = ecommApiMapper.checkOrderStatus(EComApiForm.createMap(eComApiForm));

        if(MapUtils.isNotEmpty(data)){
          code = String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS);
          message = AppConstants.RESPONSE_DESC_SUCCESS;

          rtn = EComApiDto.create(data);
        }else{
          code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
          message = "Sales Order Form No. Not Found";
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

      if(access != null) apiUserId = access.get("apiUserId").toString();

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
        data = ecommApiMapper.cardDiffNRIC(reqPrm);

        if(data != null){
          code = String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS);
          message = AppConstants.RESPONSE_DESC_SUCCESS;

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

  @Override
  public EgovMap insertNewAddr(HttpServletRequest request, EComApiForm eComApiForm) throws Exception {
    String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0";

    StopWatch stopWatch = new StopWatch();
    stopWatch.reset();
    stopWatch.start();

    EgovMap access = new EgovMap();
    int created = 0;
    Map<String, Object> reqPrm = Maps.filterValues(EComApiForm.createAddrMap(eComApiForm),Objects::nonNull);

    try{

      access = commonApiMapper.checkAccess(reqPrm);
      if(access == null){
        code = String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED);
        message = AppConstants.RESPONSE_DESC_UNAUTHORIZED;
      }
      else {
        apiUserId = access.get("apiUserId").toString();
        created = ecommApiMapper.insertNewAddr(reqPrm);

        if(created > 0){
          code = String.valueOf(AppConstants.RESPONSE_CODE_CREATED);
          message = AppConstants.RESPONSE_DESC_CREATED;
        }else{
          code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
          message = "Failed to insert address";
        }
      }

    }catch(Exception e){
      code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
      message = StringUtils.substring(e.getMessage(), 0, 4000);
    } finally{
      stopWatch.stop();
      respTm = stopWatch.toString();
    }

    return commonApiService.rtnRespMsg(request, code, message, respTm, reqPrm, null ,apiUserId);
  }

  @Override
  public EgovMap cancelOrder(HttpServletRequest request, EComApiForm eComApiForm) throws Exception {
    String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0";

    StopWatch stopWatch = new StopWatch();
    stopWatch.reset();
    stopWatch.start();

    EgovMap access = new EgovMap();
    Map<String, Object> reqPrm = Maps.filterValues(EComApiForm.createMap(eComApiForm),Objects::nonNull);
    Map<String, Object> cancelResult = new HashMap<String, Object>();

    try{

      access = commonApiMapper.checkAccess(reqPrm);
      if(access == null){
        code = String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED);
        message = AppConstants.RESPONSE_DESC_UNAUTHORIZED;
      }
      else if(CommonUtils.isEmpty(eComApiForm.getSofNo())){
        code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
        message = "Sales Order Form No. Not Found";
      }
      else {
        apiUserId = access.get("apiUserId").toString();
        reqPrm.put("apiUserId", apiUserId);

        ecommApiMapper.cancelOrd(reqPrm);
        if(reqPrm.get("p1").toString().equals("O.K")){
          code = String.valueOf(AppConstants.RESPONSE_CODE_CREATED);
          message = AppConstants.RESPONSE_DESC_CREATED;
        }else{
          code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
          message = reqPrm.get("p1").toString();
        }
      }

    }catch(Exception e){
      code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
      message = StringUtils.substring(e.getMessage(), 0, 4000);
    } finally{
      stopWatch.stop();
      respTm = stopWatch.toString();
    }

    return commonApiService.rtnRespMsg(request, code, message, respTm, reqPrm, null ,apiUserId);
  }

}
