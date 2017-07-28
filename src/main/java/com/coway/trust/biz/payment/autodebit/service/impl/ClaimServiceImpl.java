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

	private static final Logger logger = LoggerFactory.getLogger(ClaimServiceImpl.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "claimMapper")
	private ClaimMapper claimMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	
	
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
	
	
	
}
