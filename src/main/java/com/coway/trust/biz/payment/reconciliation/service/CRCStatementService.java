package com.coway.trust.biz.payment.reconciliation.service;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sample.SampleVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CRCStatementService
{

	
	
	/**
	 * CRC Statement Transaction 리스트 조회
	 * @param params
	 * @return
	 */
    List<EgovMap> selectCRCStatementTranList(Map<String, Object> params);
    
    /**
     * CRC Statement Transaction 정보 수정
     * @param params
     */
    void updateCRCStatementTranList(Map<String, Object> params);
    
    /**
     * CRCStatementRunningNo 가져오기
     * @return
     */
    String getCRCStatementRunningNo();
    
    /**
     * CRCStatement Sequence 가져오기
     * @return
     */
    Integer getCRCStatementSEQ();
    
    /**
     * CRC Statement 정보 등록
     * @param params
     */
    void updateCRCStatementUpload(Map<String, Object> crcSatementMap, List<Object> transactionList );
    
    /**
     * testCallStoredProcedure
     * @param params
     */
    Map<String, Object> testCallStoredProcedure(Map<String, Object> param);
}
