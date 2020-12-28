package com.coway.trust.biz.api.impl;

import java.util.List;

/**************************************
 * Author                  Date                    Remark
 * Chew Kah Kit        2020/12/16           API for Common
 ***************************************/

import java.util.Map;

import javax.annotation.Resource;


import org.apache.commons.collections4.MapUtils;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.api.EcommApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;
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

  @Override
  public EComApiDto checkOrderStatus(EComApiForm params) throws Exception {
    if(null == params){
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if(CommonUtils.isEmpty(params.getKey())){
      throw new ApplicationException(String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED),AppConstants.RESPONSE_DESC_UNAUTHORIZED);
    }
    if(commonApiMapper.checkAccess(EComApiForm.createMap(params)) == null){
      throw new ApplicationException(String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED),AppConstants.RESPONSE_DESC_UNAUTHORIZED);
    }
    if(CommonUtils.isEmpty(params.getOrdNo())){
      throw new ApplicationException(AppConstants.FAIL, "Order Number value does not exist.");
    }
    EgovMap access = ecommApiMapper.checkOrderStatus(EComApiForm.createMap(params));
    EComApiDto rtn = new EComApiDto();

    if(MapUtils.isNotEmpty(access)){
      return rtn.create(access);
    }

    return rtn;
  }

  @Override
  public EgovMap isCardExists(EComApiForm params) throws Exception {
    if(null == params){
      throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
    }
    if(CommonUtils.isEmpty(params.getKey())){
      throw new ApplicationException(String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED),AppConstants.RESPONSE_DESC_UNAUTHORIZED);
    }
    if(commonApiMapper.checkAccess(EComApiForm.createMap(params)) == null){
      throw new ApplicationException(String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED),AppConstants.RESPONSE_DESC_UNAUTHORIZED);
    }
    if(CommonUtils.isEmpty(params.getNric())){
      throw new ApplicationException(AppConstants.FAIL, "NRIC value does not exist.");
    }
    if(CommonUtils.isEmpty(params.getCardTokenId())){
      throw new ApplicationException(AppConstants.FAIL, "token ID value does not exist.");
    }
    EgovMap access = new EgovMap();

    if(ecommApiMapper.isCardExists(EComApiForm.createMap(params)) != null ){
      access.put("isCardExists", "Y");
    }else{
      access.put("isCardExists", "N");
    }

    return access;
  }


}
