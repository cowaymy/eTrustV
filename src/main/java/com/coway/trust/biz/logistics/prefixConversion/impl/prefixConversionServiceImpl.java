package com.coway.trust.biz.logistics.prefixConversion.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.prefixConversion.prefixConversionService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("prefixConversionService")
public class prefixConversionServiceImpl extends EgovAbstractServiceImpl implements prefixConversionService {
  private final Logger logger = LoggerFactory.getLogger(this.getClass());

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Resource(name = "prefixConversionMapper")
  private prefixConversionMapper prefixConversionMapper;

  @Override
  public List<EgovMap> searchPrefixConfigList(Map<String, Object> params) {
    params.put("prefixProdId", params.get("sprefixStkId").toString());
    params.put("prefixConvProdId", params.get("sprefixConvStkId").toString());

    return prefixConversionMapper.searchPrefixConfigList(params);
  }

  @Override
  public EgovMap selectPrefixConfigInfo(Map<String, Object> params) {
    return prefixConversionMapper.selectPrefixConfigInfo(params);
  }

  @Override
  public void savePrefixConversion(Map<String, Object> params,SessionVO sessionVO) {

    Map<?, ?> prefixParams = (Map<?, ?>) params.get("prefixConversion");

    String viewType = prefixParams.get("viewType").toString();

    params.put("prefixProdId", prefixParams.get("prefixStkId").toString());
    params.put("prefixConvProdId", prefixParams.get("prefixConvStkId").toString());
    params.put("useYn", prefixParams.get("useYn"));
    params.put("prefixConfigId", prefixParams.get("prefixConfigId"));

    params.put("crtUserId", sessionVO.getUserId());
    params.put("updUserId", sessionVO.getUserId());

    //check duplicate in LOG0205M
    String serialPrefixChk = prefixConversionMapper.selectPrefixConversionByProdId(params);
    if(!StringUtils.isEmpty(serialPrefixChk)){
      throw new ApplicationException(AppConstants.FAIL,
      messageAccessor.getMessage(AppConstants.RESPONSE_DESC_DUP));
    }

    if("1".equals(viewType)){
      prefixConversionMapper.addPrefixConfig(params);
    }else{
      prefixConversionMapper.updatePrefixConfig(params);
    }

  }


}
