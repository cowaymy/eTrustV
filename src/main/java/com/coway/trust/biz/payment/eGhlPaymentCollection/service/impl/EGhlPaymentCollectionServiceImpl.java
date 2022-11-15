package com.coway.trust.biz.payment.eGhlPaymentCollection.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.payment.eGhlPaymentCollection.service.EGhlPaymentCollectionService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("eGhlPaymentCollectionService")
public class EGhlPaymentCollectionServiceImpl extends EgovAbstractServiceImpl implements EGhlPaymentCollectionService {
	  @Autowired
	  private MessageSourceAccessor messageAccessor;

	  @Resource(name = "eGhlPaymentCollectionMapper")
	  private EGhlPaymentCollectionMapper eGhlPaymentCollectionMapper;

	  @Resource(name = "commonMapper")
	  private CommonMapper commonMapper;

	  private static final Logger LOGGER = LoggerFactory.getLogger(EGhlPaymentCollectionServiceImpl.class);

	  @Override
	  public List<EgovMap> orderNumberBillMobileSearch(Map<String,Object> params){
		  return eGhlPaymentCollectionMapper.orderNumberBillMobileSearch(params);
	  }

	  @Override
	  public String paymentCollectionRunningNumberGet(){
		    String pcNo = commonMapper.selectDocNo("189");

		    return pcNo;
	  }
}
