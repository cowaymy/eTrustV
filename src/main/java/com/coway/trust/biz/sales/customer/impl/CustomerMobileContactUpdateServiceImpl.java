package com.coway.trust.biz.sales.customer.impl;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.sales.customer.CustomerMobileContactUpdateService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("customerMobileContactUpdateService")
public class CustomerMobileContactUpdateServiceImpl extends EgovAbstractServiceImpl implements CustomerMobileContactUpdateService {

  private static final Logger LOGGER = LoggerFactory.getLogger(CustomerMobileContactUpdateServiceImpl.class);

  @Resource(name = "customerMobileContactUpdateMapper")
  private CustomerMobileContactUpdateMapper customerMobileContactUpdateMapper;

  @Autowired
  private MessageSourceAccessor messageSourceAccessor;

  @Override
  public List<EgovMap> selectMobileUpdateJsonList(Map<String, Object> params) {

    return customerMobileContactUpdateMapper.selectMobileUpdateJsonList(params);
  }

  @Override
  public EgovMap selectMobileUpdateDetail(Map<String, Object> params) {

    return customerMobileContactUpdateMapper.selectMobileUpdateDetail(params);
  }

  @Override
  public void updateAppvStatus(Map<String, Object> params) throws Exception {

	  LOGGER.debug("updateAppvStatusPARAMS :: Implementation"+ params);
	  //Rejected status only update main table
	  if(params.get("statusCode").equals("J")){
		  customerMobileContactUpdateMapper.updateAppvStatusSAL0329D(params);
	  }
	  //Approved status to update SAL0027D and main table
	  else if(params.get("statusCode").equals("A")){
		  EgovMap contactInfo = customerMobileContactUpdateMapper.selectMobileUpdateDetail(params);
		  contactInfo.put("userId", params.get("userId"));

		  if((contactInfo.get("newHpNo") != null) && contactInfo.get("newHpNo").equals("-"))
		  {
			  contactInfo.put("newHpNo", "");
		  }

		  if((contactInfo.get("newHomeNo") != null) && contactInfo.get("newHomeNo").equals("-"))
		  {
			  contactInfo.put("newHomeNo", "");
		  }

		  if((contactInfo.get("newOfficeNo") != null) && contactInfo.get("newOfficeNo").equals("-"))
		  {
			  contactInfo.put("newOfficeNo", "");
		  }

		  if((contactInfo.get("newEmail") != null) && contactInfo.get("newEmail").equals("-"))
		  {
			  contactInfo.put("newEmail", "");
		  }

		  LOGGER.debug("updateAppvStatusCONTACTINFO :: Implementation", contactInfo);
		  customerMobileContactUpdateMapper.updateAppvStatusSAL0329D(params);
		  customerMobileContactUpdateMapper.updateAppvStatusSAL0027D(contactInfo);
	  }
  }
}
