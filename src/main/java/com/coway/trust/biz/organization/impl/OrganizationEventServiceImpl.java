package com.coway.trust.biz.organization.impl;
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
import com.coway.trust.biz.organization.OrganizationEventService;
import com.coway.trust.cmmn.exception.ApplicationException;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


/**
 * @Class Name : OrganizationEventServiceImpl.java
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

@Service("organizationEventService")
public class OrganizationEventServiceImpl extends EgovAbstractServiceImpl implements OrganizationEventService {

	private static final Logger logger = LoggerFactory.getLogger(OrganizationEventServiceImpl.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "organizationEventMapper")
	private OrganizationEventMapper organizationEventMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	@Override
	public List<EgovMap> selectOrganizationEventList(Map<String, Object> params) {
		
		return organizationEventMapper.selectOrganizationEventList(params);
		
	}
	
	
}