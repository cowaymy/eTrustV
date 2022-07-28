package com.coway.trust.biz.services.as.impl;

import java.math.BigDecimal;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.sales.customer.impl.CustomerServiceImpl;
import com.coway.trust.biz.sales.mambership.impl.MembershipRentalQuotationMapper;
import com.coway.trust.biz.sales.pos.impl.PosMapper;
import com.coway.trust.biz.services.as.PreASManagementListService;
import com.coway.trust.biz.services.as.ASManagementListService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import oracle.sql.DATE;

@Service("PreASManagementListService")
public class PreASManagementListServiceImpl extends EgovAbstractServiceImpl implements PreASManagementListService {

  private static final Logger LOGGER = LoggerFactory.getLogger(PreASManagementListServiceImpl.class);

  @Autowired
  private AdaptorService adaptorService;

  @Resource(name = "PreASManagementListMapper")
  private PreASManagementListMapper PreASManagementListMapper;

  @Resource(name = "ASManagementListMapper")
  private ASManagementListMapper ASManagementListMapper;

  @Resource(name = "servicesLogisticsPFCMapper")
  private ServicesLogisticsPFCMapper servicesLogisticsPFCMapper;

  @Resource(name = "membershipRentalQuotationMapper")
  private MembershipRentalQuotationMapper membershipRentalQuotationMapper;

  @Resource(name = "posMapper")
  private PosMapper posMapper;

  @Override
  public List<EgovMap> selectPreASManagementList(Map<String, Object> params) {
    return PreASManagementListMapper.selectPreASManagementList(params);
  }

  @Override
  public List<EgovMap> selectPreAsStat() {
    return PreASManagementListMapper.selectPreAsStat();
  }

  @Override
  public Map<String, Object> updateRejectedPreAS(Map<String, Object> params) throws Exception {

	  PreASManagementListMapper.updateRejectedPreAS(params);

  	   //Return Message
	   Map<String, Object> rtnMap = new HashMap<String, Object>();
	   rtnMap.put("scnNo", "ok");
	   return rtnMap;

  }




}
