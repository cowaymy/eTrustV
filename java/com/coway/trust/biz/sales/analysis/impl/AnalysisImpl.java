package com.coway.trust.biz.sales.analysis.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.analysis.AnalysisService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("analysisService")
public class AnalysisImpl extends EgovAbstractServiceImpl implements AnalysisService{


	@Resource(name = "analysisMapper")
	private AnalysisMapper analysisMapper;

	@Override
	public EgovMap maintanceSession() {

		return analysisMapper.maintanceSession();
	}

	@Override
	public List<EgovMap> selectPltvProductCodeList(Map<String, Object> params) {
		return analysisMapper.selectPltvProductCodeList(params);
	}

	 @Override
	  public List<EgovMap> selectPltvProductCategoryList(Map<String, Object> params) {
	    return analysisMapper.selectPltvProductCategoryList(params);
	  }

	@Override
	public String selectMaxAccYm() {

		return analysisMapper.selectMaxAccYm();
	}
}
