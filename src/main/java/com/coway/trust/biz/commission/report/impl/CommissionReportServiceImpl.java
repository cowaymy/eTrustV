package com.coway.trust.biz.commission.report.impl;

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
	public int selectMemberCount(Map<java.lang.String, Object> param) {
		int cnt = commissionReportMapper.selectMemberCount(param);
		return cnt;
	}

}
