package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.organization.organization.NeoProAndHPListService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("neoProAndHPListService")
public class NeoProAndHPListListServiceImpl extends EgovAbstractServiceImpl implements NeoProAndHPListService {

	@SuppressWarnings("unused")
	private static final Logger logger = LoggerFactory.getLogger(MemberEventServiceImpl.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "neoProAndHPListMapper")
	private NeoProAndHPListMapper neoProAndHPListMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;


	@Override
	public List<EgovMap> selectNeoProAndHPList(Map<String, Object> params) {

		return neoProAndHPListMapper.selectNeoProAndHPList(params);
	}

	@Override
	public EgovMap checkHpType(Map<String, Object> params) {
	    return neoProAndHPListMapper.checkHpType(params);
	}
}
