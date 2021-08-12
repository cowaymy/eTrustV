package com.coway.trust.biz.homecare.services.install.impl;


import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("hcInstallationReversalMapper")
public interface HcInstallationReversalMapper {

	public List<EgovMap> selectReverseReason() throws Exception;
	public List<EgovMap> selectFailReason() throws Exception;

	public List<EgovMap> selectOrderList(Map<String, Object> params) throws Exception;

	public EgovMap selectOrderListDetail1(Map<String, Object> params) throws Exception;

	public List<EgovMap> selectBndlInfoList(Map<String, Object> params) throws Exception;

	public List<EgovMap> selectReversalStockState(Map<String, Object> params) throws Exception;
}