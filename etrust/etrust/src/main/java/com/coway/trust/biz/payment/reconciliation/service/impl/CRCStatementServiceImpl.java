package com.coway.trust.biz.payment.reconciliation.service.impl;

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

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.reconciliation.service.CRCStatementService;
import com.coway.trust.biz.payment.reconciliation.service.CRCStatementVO;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.biz.sample.SampleService;
import com.coway.trust.biz.sample.SampleVO;
import com.coway.trust.cmmn.exception.ApplicationException;

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

@Service("crcStatementService")
public class CRCStatementServiceImpl extends EgovAbstractServiceImpl implements CRCStatementService {

	@Resource(name = "crcStatementMapper")
	private CRCStatementMapper crcStatementMapper;

	
	/**
	 * CRC Statement Transaction 리스트 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectCRCStatementTranList(Map<String, Object> params) {
		return crcStatementMapper.selectCRCStatementTranList(params);
	}
	
	/**
     * CRC Statement Transaction 정보 수정
     * @param params
     */
	@Override	
	public void updateCRCStatementTranList(Map<String, Object> params) {
		crcStatementMapper.updateCRCStatementTranList(params);
	}
	
	/**
     * CRCStatementRunningNo 가져오기
     * @return
     */
	@Override
    public String getCRCStatementRunningNo(){
		return crcStatementMapper.getCRCStatementRunningNo();
	}
	
	/**
	 * CRCStatement Sequence 가져오기
	 * @return
	 */
	@Override
    public Integer getCRCStatementSEQ(){
		return crcStatementMapper.getCRCStatementSEQ();
	}
	
	/**
     * CRC Statement 정보 등록
     * @param params
     */
	@Override
    public void updateCRCStatementUpload(Map<String, Object> crcSatementMap, List<Object> transactionList ){
		
		crcStatementMapper.insertCRCStatement(crcSatementMap);
		
		//CRC Transaction 정보
    	if (transactionList.size() > 0) {    		
    		Map hm = null;    		
    		for (Object map : transactionList) {
    			hm = (HashMap<String, Object>) map;    			
    			crcStatementMapper.insertCRCTransaction(hm);    			
    		}
    	}
	}
	
	/**
     * CRC Statement 정보 등록
     * @param params
     */
	@Override
    public Map<String, Object> testCallStoredProcedure(Map<String, Object> param){
		
		return crcStatementMapper.testCallStoredProcedure(param);
		
		
	}
	
}
