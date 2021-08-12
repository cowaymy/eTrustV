package com.coway.trust.biz.payment.reconciliation.service.impl;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.coway.trust.biz.payment.reconciliation.service.PaymentReconciliationService;
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

@Service("paymentReconciliationService")
public class PaymentReconciliationServiceImpl extends EgovAbstractServiceImpl implements PaymentReconciliationService {

	@Resource(name = "paymentReconciliationMapper")
	private PaymentReconciliationMapper paymentReconciliationMapper;

	@Override
	public List<EgovMap> selectReconciliationMasterList(Map<String, Object> params) {
		return paymentReconciliationMapper.selectReconciliationMasterList(params);
	}

	@Override
	public List<EgovMap> selectDepositView(Map<String, Object> params) {
		return paymentReconciliationMapper.selectDepositView(params);
	}

	@Override
	public List<EgovMap> selectDepositList(Map<String, Object> params) {
		return paymentReconciliationMapper.selectDepositList(params);
	}

	@Override
	public boolean updDepositItem(Map<String, Object> params) {
		
		int result = paymentReconciliationMapper.updDepositItem(params);
		
		if(result > 0){
			return true;
		}else{
			return false;
		}
	}

	@Transactional
	public boolean saveExcludeDepositItem(Map<String, Object> params) {
		int depositDsResult = paymentReconciliationMapper.updReconDepositDs(params);
		int depositMsResult = paymentReconciliationMapper.updReconDepositMs(params);
		
		if(depositDsResult > 0 && depositMsResult > 0){
			return true;
		}else{
			return false;
		}
	}

	@Override
	public int selectReconciliationMasterListCount(Map<String, Object> params) {
		return paymentReconciliationMapper.selectReconciliationMasterListCount(params);
	}

}
