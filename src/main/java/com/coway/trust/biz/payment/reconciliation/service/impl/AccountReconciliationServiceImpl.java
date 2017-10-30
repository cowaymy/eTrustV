package com.coway.trust.biz.payment.reconciliation.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.coway.trust.biz.payment.reconciliation.service.AccountReconciliationService;
import com.coway.trust.cmmn.model.SessionVO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @Class Name : EgovSampleServiceImpl.java
 * @Description : Sample Business Implement Class
 * @Modification Information
 * @ @ 수정일 수정자 수정내용 @ --------- --------- ------------------------------- @ 2009.03.16 최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 * 	 Copyright (C) by MOPAS All right reserved.
 */

@Service("accountReconciliationService")
public class AccountReconciliationServiceImpl extends EgovAbstractServiceImpl implements AccountReconciliationService {

	@Resource(name = "accountReconciliationMapper")
	private AccountReconciliationMapper accountReconciliationMapper;
	
	private static final Logger logger = LoggerFactory.getLogger(AccountReconciliationServiceImpl.class);

	@Override
	public List<EgovMap> selectJournalMasterList(Map<String, Object> params) {
		return accountReconciliationMapper.selectJournalMasterList(params);
	}

	@Override
	public List<EgovMap> selectJournalMasterView(Map<String, Object> params) {
		return accountReconciliationMapper.selectJournalMasterView(params);
	}

	@Override
	public List<EgovMap> selectJournalDetailList(Map<String, Object> params) {
		return accountReconciliationMapper.selectJournalDetailList(params);
	}

	@Override
	public String selectGrossTotal(Map<String, Object> params) {
		return accountReconciliationMapper.selectGrossTotal(params);
	}

}
