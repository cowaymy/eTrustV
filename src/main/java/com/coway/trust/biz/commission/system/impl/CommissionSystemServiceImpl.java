package com.coway.trust.biz.commission.system.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.commission.system.CommissionSystemService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
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

@Service("commissionSystemService")
public class CommissionSystemServiceImpl extends EgovAbstractServiceImpl implements CommissionSystemService {

	private static final Logger logger = LoggerFactory.getLogger(CommissionSystemServiceImpl.class);

	private static final int String = 0;

	@Value("${app.name}")
	private String appName;

	@Resource(name = "commissionSystemMapper")
	private CommissionSystemMapper commissionSystemMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;
	
	/*@Autowired
	private SessionHandler sessionHandler;*/

	/**
	 * search Organization List
	 * 
	 * @param Map
	 * @return search Organization List
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectOrgGrList(Map<String, Object> params) {
		return commissionSystemMapper.selectOrgGrList(params);
	}
	
	/**
	 * search Organization List
	 * 
	 * @param Map
	 * @return search Organization List
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectOrgList(Map<String, Object> params) {
		return commissionSystemMapper.selectOrgList(params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public int addCommissionGrid(List<Object> addList) {
		//HttpSession session = sessionHandler.getCurrentSession();
		String user="0000000000";
		
		/*if(session != null){
			user = session.getId();
			
		}*/
		for(Object obj : addList){
			
			((Map<String, Object>) obj).put("endDt", CommissionConstants.COMIS_END_DT);
			((Map<String, Object>) obj).put("crtUserId", user);
			((Map<String, Object>) obj).put("updUserId", user);
			
			logger.debug("update orgGrCd : {}", ((Map<String, Object>) obj).get("orgGrCd"));
			logger.debug("update ORG_GR_NM : {}", ((Map<String, Object>) obj).get("orgGrNm"));
			logger.debug("update ORG_CD : {}", ((Map<String, Object>) obj).get("orgCd"));
			logger.debug("update ORG_NM : {}", ((Map<String, Object>) obj).get("orgNm"));
			logger.debug("update USE_YN : {}", ((Map<String, Object>) obj).get("useYn"));	
			logger.debug("update CRT_USER_ID : {}", ((Map<String, Object>) obj).get("crtUserId"));	
			logger.debug("update UPD_USER_ID : {}", ((Map<String, Object>) obj).get("updUserId"));			
		
			List<EgovMap> list = commissionSystemMapper.selectRuleBookMngChk((Map<String, Object>) obj);
			if(list.size()>0){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("orgGrCd", list.get(0).get("orgGrCd"));
				params.put("orgCd", list.get(0).get("orgCd"));
				params.put("orgSeq", list.get(0).get("orgSeq"));
				params.put("updUserId",((Map<String, Object>) obj).get("updUserId"));
				commissionSystemMapper.udtCommissionGridEndDt(params);
			}			
			commissionSystemMapper.addCommissionGrid((Map<String, Object>) obj);
		}
		return 0;
	}

	@Override
	public int udtCommissionGrid(List<Object> udtList) {
		String user="0000000000";
		for(Object obj : udtList){
			((Map<String, Object>) obj).put("endDt", CommissionConstants.COMIS_END_DT);
			((Map<String, Object>) obj).put("crtUserId", user);
			((Map<String, Object>) obj).put("updUserId", user);
			
			logger.debug("update orgGrCd : {}", ((Map<String, Object>) obj).get("orgGrCd"));
			logger.debug("update orgGrNm : {}", ((Map<String, Object>) obj).get("orgGrNm"));
			logger.debug("update orgCd : {}", ((Map<String, Object>) obj).get("orgCd"));
			logger.debug("update orgNm : {}", ((Map<String, Object>) obj).get("orgNm"));
			logger.debug("update useYn : {}", ((Map<String, Object>) obj).get("useYn"));	
			logger.debug("update crtUserId : {}", ((Map<String, Object>) obj).get("crtUserId"));	
			logger.debug("update updUserId : {}", ((Map<String, Object>) obj).get("updUserId"));	
			
			commissionSystemMapper.udtCommissionGridUseYn((Map<String, Object>) obj);
		}
		return 0;
	}

	@Override
	public int delCommissionGrid(List<Object> delList) {
		String user="0000000000";
		for(Object obj : delList){
			((Map<String, Object>) obj).put("endDt", CommissionConstants.COMIS_END_DT);
			((Map<String, Object>) obj).put("crtUserId", user);
			((Map<String, Object>) obj).put("updUserId", user);
			
			logger.debug("update orgGrCd : {}", ((Map<String, Object>) obj).get("orgGrCd"));
			logger.debug("update ORG_GR_NM : {}", ((Map<String, Object>) obj).get("orgGrNm"));
			logger.debug("update ORG_CD : {}", ((Map<String, Object>) obj).get("orgCd"));
			logger.debug("update ORG_NM : {}", ((Map<String, Object>) obj).get("orgNm"));
			logger.debug("update USE_YN : {}", ((Map<String, Object>) obj).get("useYn"));	
			logger.debug("update CRT_USER_ID : {}", ((Map<String, Object>) obj).get("crtUserId"));	
			logger.debug("update UPD_USER_ID : {}", ((Map<String, Object>) obj).get("updUserId"));	
			commissionSystemMapper.delCommissionGrid((Map<String, Object>) obj);
		}
		return 0;
	}

	@Override
	public List<EgovMap> selectRuleBookMngList(Map<String, Object> params) {
		return commissionSystemMapper.selectRuleBookMngList(params);		
	}



}
