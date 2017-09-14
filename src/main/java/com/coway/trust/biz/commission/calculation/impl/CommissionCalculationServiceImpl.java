package com.coway.trust.biz.commission.calculation.impl;

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

import com.coway.trust.biz.commission.calculation.CommissionCalculationService;
import com.coway.trust.biz.commission.system.CommissionSystemService;
import com.coway.trust.web.commission.CommissionConstants;

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

@Service("commissionCalculationService")
public class CommissionCalculationServiceImpl extends EgovAbstractServiceImpl implements CommissionCalculationService {

	private static final Logger logger = LoggerFactory.getLogger(CommissionCalculationServiceImpl.class);

	private static final int String = 0;

	@Value("${app.name}")
	private String appName;

	@Resource(name = "commissionCalculationMapper")
	private CommissionCalculationMapper commissionCalculationMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	/**
	 * search Organization Gruop Code List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectOrgGrCdListAll(Map<String, Object> params) {
		return commissionCalculationMapper.selectOrgGrCdListAll(params);
	}
	
	/**
	 * search Organization Code List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectOrgCdListAll(Map<String, Object> params) {
		return commissionCalculationMapper.selectOrgCdListAll(params);
	}
	
	/**
	 * search Organization Item List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectOrgItemList(Map<String, Object> params) {
		return commissionCalculationMapper.selectOrgItemList(params);
	}
	
	@Override
	 public Map<String, Object> callCommProcedure(Map<String, Object> param){
		return commissionCalculationMapper.callCommProcedure(param);
	}

	/**
	 * search coommission weekly management Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectWeeklyList(Map<java.lang.String, Object> params) {	
		return commissionCalculationMapper.selectWeeklyList(params);
	}
	
	/**
	 * add coommission weekly management Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public int addWeeklyCommissionGrid(List<Object> addList,String loginId) {	
		
		int cnt=0;
		
		for (Object obj : addList) {

			logger.debug("update year : {}", ((Map<String, Object>) obj).get("year"));
			logger.debug("update month : {}", ((Map<String, Object>) obj).get("month"));
			logger.debug("update weeks : {}", ((Map<String, Object>) obj).get("weeks"));
			logger.debug("update startDt : {}", ((Map<String, Object>) obj).get("startDt"));
			logger.debug("update endDt : {}", ((Map<String, Object>) obj).get("endDt"));
			((Map<String, Object>) obj).put("crtUserId", loginId);
			((Map<String, Object>) obj).put("updUserId", loginId);
			
			cnt=cnt+commissionCalculationMapper.addWeeklyCommissionGrid((Map<String, Object>) obj);
		}
		return cnt;
	}

	/**
	 * update coommission weekly management Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public int udtWeeklyCommissionGrid(List<Object> udtList,String loginId) {
		
		int cnt=0;
		for (Object obj : udtList) {		
			((Map<String, Object>) obj).put("crtUserId", loginId);
			((Map<String, Object>) obj).put("updUserId", loginId);

			cnt=cnt+commissionCalculationMapper.udtWeeklyCommissionGrid((Map<String, Object>) obj);
		}
		return cnt;
	}

	

}
