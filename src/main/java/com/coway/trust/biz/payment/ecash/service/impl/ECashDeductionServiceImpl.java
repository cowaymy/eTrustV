package com.coway.trust.biz.payment.ecash.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.payment.ecash.service.ECashDeductionService;

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

@Service("eCashDeductionService")
public class ECashDeductionServiceImpl extends EgovAbstractServiceImpl implements ECashDeductionService {

	@Resource(name = "eCashDeductionMapper")
	private ECashDeductionMapper eCashDeductionMapper;

	/**
	 * E-Cash - List
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectECashDeductList(Map<String, Object> params) {
		return eCashDeductionMapper.selectECashDeductList(params);
	}

	/**
	 * E-Cash sub - List
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectECashDeductSubList(Map<String, Object> params) {
		return eCashDeductionMapper.selectECashDeductSubList(params);
	}

	/**
     * E-Cash - Create new claim
     * @param params
     */
	@Override
    public Map<String, Object> createECashDeduction(Map<String, Object> param){
		return eCashDeductionMapper.createECashDeduction(param);
	}

	/**
     * E-Cash - eCash Result Deactivate
     * @param params
     */
	@Override
    public void deactivateECashDeductionStatus(Map<String, Object> param){
		eCashDeductionMapper.deactivateEAutoDebitDeduction(param);
		eCashDeductionMapper.deactivateEAutoDebitDeductionSub(param);
	}

	 /**
     * E-Cash - eCash Result Item Update
     * @param params
     */
	@Override
    public void updateECashDeductionResultItem(Map<String, Object> eCashMap, List<Object> resultItemList ){

		eCashDeductionMapper.deleteECashDeductionResultItem(eCashMap);

    	if (resultItemList.size() > 0) {
    		Map<String, Object> hm = null;
    		for (Object map : resultItemList) {
    			hm = (HashMap<String, Object>) map;
    			eCashDeductionMapper.insertECashDeductionResultItem(hm);
    		}
    	}
	}

	/**
     * E-Cash - eCash Result Update
     * @param params
     */
	@Override
    public void updateECashDeductionResult(Map<String, Object> eCashMap){
		eCashDeductionMapper.updateECashDeductionResult(eCashMap);
	}

}
