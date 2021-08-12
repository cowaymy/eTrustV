package com.coway.trust.biz.homecare.services.install.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("hcAllocationMapper")
public interface HcAllocationMapper {

	public EgovMap  makeViewList(Map<String, Object> params) throws Exception;

	/**
	 * @Author KR-JIN
	 * @Date 2020. 01. 13.
	 * @param params
	 * @return
	 */
	public List<EgovMap> selectHcDetailList(Map<String, Object> params) throws Exception;
}
