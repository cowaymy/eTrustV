package com.coway.trust.biz.payment.autodebit.service.impl;

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

import com.coway.trust.biz.payment.autodebit.service.ClaimService;

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

@Service("claimService")
public class ClaimServiceImpl extends EgovAbstractServiceImpl implements ClaimService {

	@Resource(name = "claimMapper")
	private ClaimMapper claimMapper;
	
	/**
	 * Auto Debit - Claim List 리스트 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectClaimList(Map<String, Object> params) {
		return claimMapper.selectClaimList(params);
	}
	
	
	/**
     * Auto Debit - Claim Result Deactivate 처리
     * @param params
     */
	@Override
    public void updateDeactivate(Map<String, Object> param){
		
		claimMapper.deleteClaimResultItem(param);
		claimMapper.updateClaimResultStatus(param);
		
	}
	
	/**
	 * Auto Debit - Claim 조회 
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap selectClaimById(Map<String, Object> params) {
		return claimMapper.selectClaimById(params);
	}
	
	/**Auto Debit - Claim Detail List 리스트 조회Auto Debit - Claim List 리스트 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectClaimDetailById(Map<String, Object> params) {
		return claimMapper.selectClaimDetailById(params);
	}
	
	/**
     * Auto Debit - Claim 생성 프로시저 호출
     * @param params
     */
	@Override
    public Map<String, Object> createClaim(Map<String, Object> param){
		return claimMapper.createClaim(param);
	}
	
	 /**
     * Auto Debit - Claim Result Update
     * @param params
     */
	@Override
    public void updateClaimResultItem(Map<String, Object> claimMap, List<Object> resultItemList ){
		
		claimMapper.deleteClaimResultItem(claimMap);
		
		//CRC Transaction 정보
    	if (resultItemList.size() > 0) {    		
    		Map<String, Object> hm = null;    		
    		for (Object map : resultItemList) {
    			hm = (HashMap<String, Object>) map;    			
    			claimMapper.insertClaimResultItem(hm);    			
    		}
    	}
	}
	
	
	
}
