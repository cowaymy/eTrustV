package com.coway.trust.biz.payment.billing.service.impl;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.payment.billing.service.BillingMgmtService;
import com.coway.trust.biz.payment.billing.service.EarlyTerminationBillingService;
import com.coway.trust.biz.payment.billing.service.ProductLostBillingService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("productLostService")
public class ProductLostBillingServiceImpl extends EgovAbstractServiceImpl implements ProductLostBillingService {

	private static final Logger logger = LoggerFactory.getLogger(EarlyTerminationBillingServiceImpl.class);

	@Resource(name = "productLostMapper")
	private ProductLostBillingMapper productLostMapper;

	@Override
	public List<EgovMap> selectRentalProductLostPenalty(String param) {
		// TODO Auto-generated method stub
		return productLostMapper.selectRentalProductLostPenalty(param);
	}

}
