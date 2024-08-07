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

	@Override
	public List<EgovMap> selectECashDeductList(Map<String, Object> params) {
		return eCashDeductionMapper.selectECashDeductList(params);
	}

	@Override
	public EgovMap selectECashDeductById(Map<String, Object> params) {
		return eCashDeductionMapper.selectECashDeductById(params);
	}

	@Override
	public List<EgovMap>  selectECashDeductSubById(Map<String, Object> params) {
		return eCashDeductionMapper.selectECashDeductSubById(params);
	}


	@Override
	public int selectECashDeductSubByIdCnt(Map<String, Object> params) {
		return eCashDeductionMapper.selectECashDeductSubByIdCnt(params);
	}

	@Override
	public int selectECashDeductCCSubByIdCnt(Map<String, Object> params) {
		return eCashDeductionMapper.selectECashDeductCCSubByIdCnt(params);
	}

	@Override
	public int selectECashDeductBatchGen(Map<String, Object> params) {
		return eCashDeductionMapper.selectECashDeductBatchGen(params);
	}


	@Override
	public List<EgovMap> selectECashDeductSubList(Map<String, Object> params) {
		return eCashDeductionMapper.selectECashDeductSubList(params);
	}

	@Override
    public Map<String, Object> createECashDeduction(Map<String, Object> param){
		return eCashDeductionMapper.createECashDeduction(param);
	}

	@Override
    public void deactivateECashDeductionStatus(Map<String, Object> param){
		eCashDeductionMapper.deactivateEAutoDebitDeduction(param);
		eCashDeductionMapper.deactivateEAutoDebitDeductionSub(param);
	}

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

	@Override
    public void updateECashDeductionResult(Map<String, Object> eCashMap){
		eCashDeductionMapper.updateECashDeductionResult(eCashMap);
	}

	@Override
    public Map<String, Object> createECashGrpDeduction(Map<String, Object> param){
		return eCashDeductionMapper.createECashGrpDeduction(param);
	}

	@Override
    public void updateECashGrpDeductionResult(Map<String, Object> eCashMap){
		eCashDeductionMapper.updateECashGrpDeductionResult(eCashMap);
	}

	@Override
	public void updateECashDeductionResultItemBulk(Map<String, Object> bulkMap) throws Exception{
		eCashDeductionMapper.insertECashDeductionResultItemBulk(bulkMap);

	}

	@Override
	public EgovMap selectECashBankResult(Map<String, Object> eCashMap) {
		return eCashDeductionMapper.selectECashBankResult(eCashMap);
	}

	@Override
	public void deleteECashDeductionResultItem(Map<String, Object> eCashMap) {
		eCashDeductionMapper.deleteECashDeductionResultItem(eCashMap);
	}

	@Override
	public EgovMap selectMstConf(Map<String, Object> params) {
	  return eCashDeductionMapper.selectMstConf(params);
	}

	@Override
	public List<EgovMap> selectSubConf(Map<String, Object> params) {
		  return eCashDeductionMapper.selectSubConf(params);
	}


}
