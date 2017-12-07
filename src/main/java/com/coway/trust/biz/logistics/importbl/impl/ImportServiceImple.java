package com.coway.trust.biz.logistics.importbl.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.importbl.ImportService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("importService")
public class ImportServiceImple extends EgovAbstractServiceImpl implements ImportService { 
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "importMapper")
	private ImportMapper importMapper;
	
	@Override
	public List<EgovMap> importBLList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return importMapper.importBLList(params);
	}
	
	@Override
	public List<EgovMap> importLocationList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return importMapper.importLocationList(params);
	}

	@Override
	public List<EgovMap> searchSMO(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return importMapper.searchSMO(params);
	}
}
