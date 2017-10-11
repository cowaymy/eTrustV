package com.coway.trust.biz.logistics.itembt.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.itembt.TRBookService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("trBookService")
public class TRBookServiceImpl extends EgovAbstractServiceImpl implements TRBookService {

	private static final Logger logger = LoggerFactory.getLogger(TRBookServiceImpl.class);

	@Resource(name = "trBookMapper")
	private TRBookMapper trBookMapper;

	@Override
	public List<EgovMap> selectTrBookManagement(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return trBookMapper.selectTrBookManagement(params);
	}
}
