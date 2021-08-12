package com.coway.trust.biz.organization.organization.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.organization.organization.HpKeyInListService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("hpKeyInListService")
public class HpKeyInListServiceImpl extends EgovAbstractServiceImpl implements HpKeyInListService {

	@SuppressWarnings("unused")
	private static final Logger logger = LoggerFactory.getLogger(HpKeyInListServiceImpl.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "hpKeyInListMapper")
	private HpKeyInListMapper hpKeyInListMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;
	
	@Override
	public List<EgovMap> reqPersonComboList() {

		return hpKeyInListMapper.reqPersonComboList();
	}
	
	
	public List<EgovMap> branchComboList() {

		return hpKeyInListMapper.branchComboList();
	}
	
}
