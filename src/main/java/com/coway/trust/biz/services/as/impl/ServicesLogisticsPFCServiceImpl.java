package com.coway.trust.biz.services.as.impl;

import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.installation.impl.InstallationResultListMapper;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE            PIC          VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 01/07/2020    ONGHC      1.0.1        - Add updRcdTms, insertTransLog
 *********************************************************************************************/

@Service("servicesLogisticsPFCService")
public class ServicesLogisticsPFCServiceImpl extends EgovAbstractServiceImpl implements ServicesLogisticsPFCService {

  private static final Logger LOGGER = LoggerFactory.getLogger(ServicesLogisticsPFCServiceImpl.class);

  @Resource(name = "servicesLogisticsPFCMapper")
  private ServicesLogisticsPFCMapper servicesLogisticsPFCMapper;

  @Resource(name = "installationResultListMapper")
  private InstallationResultListMapper installationResultListMapper;

  @Override
  public EgovMap SP_LOGISTIC_REQUEST(Map<String, Object> params) {
    return (EgovMap) servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(params);
  }

  @Override
  public EgovMap SP_SVC_LOGISTIC_REQUEST(Map<String, Object> params) {
    return (EgovMap) servicesLogisticsPFCMapper.SP_SVC_LOGISTIC_REQUEST(params);
  }

  @Override
  public void install_Active_SP_LOGISTIC_REQUEST(Map<String, Object> params) {
    servicesLogisticsPFCMapper.install_Active_SP_LOGISTIC_REQUEST(params);
  }

  @Override
  public EgovMap getFN_GET_SVC_AVAILABLE_INVENTORY(Map<String, Object> params) {
    return (EgovMap) servicesLogisticsPFCMapper.getFN_GET_SVC_AVAILABLE_INVENTORY(params);
  }

  // KR_HAN : ADD
  @Override
  public EgovMap SP_SVC_LOGISTIC_REQUEST_SERIAL(Map<String, Object> params) {
    return (EgovMap) servicesLogisticsPFCMapper.SP_SVC_LOGISTIC_REQUEST_SERIAL(params);
  }

  // KR-JIN ADD
  @Override
  public EgovMap SP_SVC_BARCODE_SAVE(Map<String, Object> params) {
    return (EgovMap) servicesLogisticsPFCMapper.SP_SVC_BARCODE_SAVE(params);
  }

  @Override
  public EgovMap SP_LOGISTIC_REQUEST_REVERSE_SERIAL(Map<String, Object> param) {
    return (EgovMap) servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_REVERSE_SERIAL(param);
  }

  @Override
  @Transactional(propagation = Propagation.REQUIRES_NEW)
  public void updRcdTms(Map<String, Object> params) {
    installationResultListMapper.updRcdTms(params);
  }

  @Override
  @Transactional(propagation = Propagation.REQUIRES_NEW)
  public void insertTransLog(Map<String, Object> params) {
    installationResultListMapper.insertTransLog(params);
  }

}
