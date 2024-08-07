package com.coway.trust.biz.commission.report.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.commission.report.CommissionReportService;

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

@Service("commissionReportService")
public class CommissionReportServiceImpl extends EgovAbstractServiceImpl implements CommissionReportService {

	private static final Logger logger = LoggerFactory.getLogger(CommissionReportServiceImpl.class);

	private static final int String = 0;

	@Value("${app.name}")
	private String appName;

	@Resource(name = "commissionReportMapper")
	private CommissionReportMapper commissionReportMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	/**
	 * select count member
	 *
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public EgovMap selectMemberCount(Map<java.lang.String, Object> param) {
		return commissionReportMapper.selectMemberCount(param);
		//return cnt;
	}

	@Override
	public List<EgovMap> commissionGroupType(Map<String, Object> params) {
		return commissionReportMapper.commissionGroupType(params);
	}

	@Override
	public Map commSHIMemberSearch (Map<String, Object> params){
		return commissionReportMapper.commSHIMemberSearch(params);
	}

	@Override
	public List<EgovMap> commSPCRgenrawSHIIndexCall (Map<String, Object> params){
		return commissionReportMapper.commSHIIndexCall(params);

	}

	@Override
	public List<EgovMap> commSHIIndexDetailsCall (Map<String, Object> params){
		return commissionReportMapper.commSHIIndexDetailsCall(params);

	}

	/**
	 * search Organization Gruop List
	 *
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectOrgGrList(Map<String, Object> params) {
		return commissionReportMapper.selectOrgGrList(params);
	}

	/**
	 * search Organization List
	 *
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectOrgList(Map<String, Object> params) {
		return commissionReportMapper.selectOrgList(params);
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
		return commissionReportMapper.selectOrgCdListAll(params);
	}

	@Override
	public List<EgovMap> selectCMRawData(Map<String, Object> params) {
		return commissionReportMapper.selectCMRawData(params);
	}

	@Override
	public List<EgovMap> selectCodyRawData(Map<String, Object> params) {
		return commissionReportMapper.selectCodyRawData(params);
	}

	@Override
	public List<EgovMap> selectHPRawData(Map<String, Object> params) {
		return commissionReportMapper.selectHPRawData(params);
	}

	@Override
	public List<EgovMap> selectCTRawData(Map<String, Object> params) {
		return commissionReportMapper.selectCTRawData(params);
	}

}
