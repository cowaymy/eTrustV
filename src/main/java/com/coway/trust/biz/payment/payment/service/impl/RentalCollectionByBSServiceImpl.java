package com.coway.trust.biz.payment.payment.service.impl;

import java.util.List;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.payment.payment.service.RentalCollectionByBSSearchVO;
import com.coway.trust.biz.payment.payment.service.RentalCollectionByBSService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


@Service("rentalCollectionByBSService")
public class RentalCollectionByBSServiceImpl extends EgovAbstractServiceImpl implements RentalCollectionByBSService {

	private static final Logger logger = LoggerFactory.getLogger(RentalCollectionByBSServiceImpl.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "rentalCollectionByBSMapper")
	private RentalCollectionByBSMapper rentalCollectionByBSMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	
	
	/**
	 * RentalCollectionByBS 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<RentalCollectionByBSSearchVO> searchRentalCollectionByBSList(RentalCollectionByBSSearchVO searchVO) {
		return rentalCollectionByBSMapper.searchRentalCollectionByBSList(searchVO);
	}
	
}
